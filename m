Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbYJIX5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbYJIX5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYJIX4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:56:32 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54655 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbYJIX43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:56:29 -0400
X-BigFish: VPS-43(zz1432R541L98aR98dR1805M936fO8b9bkzzzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <48EE9A1C.8040301@am.sony.com>
Date: Thu, 9 Oct 2008 16:56:12 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC - size tool for kernel build system
References: <48EBD268.50208@am.sony.com> <20081009152151.GB17013@cs181140183.pp.htv.fi>
In-Reply-To: <20081009152151.GB17013@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2008 23:56:13.0527 (UTC) FILETIME=[9C60F670:01C92A6A]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The building blocks that would be useful are IMHO:
> - a make target that generates a report for one kernel
>   (like the checkstack or export_report targets)
> - a script that compares two such reports and outputs the
>   size differences
> 
> That's also easy to do, and if that's what's wanted I can send a patch 
> that does it.

I took a stab at this with the attached two scripts.  These are
not quite ready for prime time, but show the basic idea.
I only have a partial list of subsystems, and am skipping the
runtime data collection, for now.

I have only made the scripts, not any make targets for them.

I record all data into a flat namespace, which makes it easier to compare
later.

> Everything else is IMHO overdesigned.
One element of this design is the ability to configure
the diff-size-report tool to watch only certain values, and to
return a non-zero exit code under certain conditions.  This makes
it possible to use the tool with git-bisect to find the source of
a size regression. I believe Linus asked for something like this
at the last kernel summit.

Without the use of the config file, diff-size-report is very
to bloat-o-meter, but provides info about additional
aggregate items (like subsystems and the full kernel).

Feedback is welcome.
 -- Tim

commit d4c8434396cc9a06dbd682f4eea44e2cfb44950f
Author: Tim Bird <tim.bird@am.sony.com>
Date:   Thu Oct 9 16:50:08 2008 -0700

    Add size reporting and monitoring scripts to the Linux kernel

Signed-off-by: Tim Bird <tim.bird@am.sony.com>

diff --git a/scripts/diff-size-report b/scripts/diff-size-report
new file mode 100755
index 0000000..40663cb
--- /dev/null
+++ b/scripts/diff-size-report
@@ -0,0 +1,237 @@
+#!/usr/bin/python
+#
+# diff-size-report - tool to show differences between two size reports
+#
+# Copyright 2008 Sony Corporation
+#
+# GPL version 2.0 applies
+#
+
+import sys, os
+
+conf_file="scripts/diff-size.conf"
+
+def usage():
+	print """Usage: %s file1 file2
+
+If a configuration file is present, then only show requested info.
+The default config file is: %s
+
+If any threshold specified in the config file is exceeded, the
+program returns a non-zero exit code.  This should be useful with
+git-bisect, to find the commit which creates a size regression.
+
+A sample config file is:
+  watch kernel_total
+  threshold kernel_total 15%%
+  watch subsys_net_text changes
+  threshold subsys_drivers_char_total +20000
+  threshold symbol___log_buf 64000
+
+This always shows the value of kernel_total, and shows a warning if
+the kernel_total increases by more than 15%% from file1 to file2.
+It only shows subsys_net_text if it's value changes.  It shows a warning
+if subsys_drivers_char_total increases more than 20000 bytes, and a
+warning if symbol___log_buf is bigger than 64000 bytes.
+""" % (os.path.basename(sys.argv[0]), conf_file)
+
+def read_report(filename):
+	lines = open(filename).readlines()
+	d = {}
+	in_block=0
+	for line in lines:
+		# accrete block, if still in one
+		if in_block:
+			if line.startswith(block_name+"_end"):
+				in_block=0
+				d[block_name] = block
+				continue
+			block += line
+			continue
+
+		# ignore empty lines and comments
+		if not line.strip() or line.startswith("#"):
+			continue
+
+		# get regular one-line value
+		if line.find("=") != -1:
+			name, value = line.split('=',1)
+			name = name.strip()
+			value = value.strip()
+			try:
+				value = int(value)
+			except:
+				pass
+			d[name] = value
+			continue
+
+		# check for start of block
+		if line.find("_start:") != -1 and not in_block:
+			in_block=1
+			block = ""
+			block_name=line.split("_start:")[0]
+			continue
+			
+		sys.stderr.write("Unrecognized line in file %s\n" % filename)
+		sys.stderr.write("line=%s"  % line)
+
+	if in_block:
+		sys.stderr.write("Error: Untermined block '%s' in file %s\n"\
+			 % (block_name, filename))
+	return d
+
+
+def show_warning(msg, value, t_str, name, o, d):
+	print "WARNING: %s of %d exceeds threshold of %s for '%s'" % \
+		(msg, value, t_str, name)
+	pchange = (float(d)/float(o))* 100
+	print "Old value: %d,  New value: %d, Change: %d (%.1f%%)" % \
+		(o, o+d, d, pchange)
+
+# allowed thresholds are:
+# +t - tree if delta > t
+# -t - tree if delta < t
+# t - true if new value > t
+# t% - true if delta > old value + t%
+def do_threshold(name, o, d, t_str):
+	rcode = 0
+	if t_str.startswith("+"):
+		t = int(t_str[1:])
+		if d > t:
+			show_warning("Change", d, t_str, name, o, d)
+			rcode = -1
+		return rcode
+
+	if t_str.startswith("-"):
+		t = int(t_str[1:])
+		if delta < t:
+			show_warning("Change", d, t_str, name, o, d)
+			rcode = -1
+		return rcode
+
+	if t_str.endswith("%"):
+		# handle percentage
+		t = o + (o*int(t_str[:-1]))/100
+		if o+d>t:
+			show_warning("Change", d, t_str, name, o, d)
+			rcode = -1
+		return rcode
+
+	t = int(t_str)
+	if o+d>t:
+		show_warning("Value", o+d, t_str, name, o, d)
+		rcode = -1
+	return rcode
+			
+
+# returns non-zero on threshold exception
+def process_report_conf(conf_file, old, delta):
+	rcode = 0
+	conf_list = open(conf_file).readlines()
+
+	# convert delta list to map
+	dmap = {}
+	for (value, name) in delta:
+		dmap[name] = value
+
+	for c in conf_list:
+		if not c.strip or c.startswith("#"):
+			continue
+		cparts = c.split()
+		cmd = cparts[0]
+		if cmd=="watch":
+			name = cparts[1]
+			if not dmap.has_key(name):
+				sys.stderr.write("Error: could not find item '%s' to watch\n" % name)
+				continue
+			d = dmap[name]
+			o = old[name]
+			
+			if len(cparts)>2 and cparts[2].startswith("change") \
+				and d==0:
+				# skip unchanged values	
+				continue
+			if d==0:
+				print "%s stayed at %d bytes" % (name, o)
+				continue
+			
+			p = (float(d)/float(o))* 100
+			print "%s changed by %d bytes (%.1f%%)" % (name, d, p)
+			continue
+
+		if cmd=="threshold":
+			name = cparts[1]
+			t_str = cparts[2]
+			if not dmap.has_key(name):
+				sys.stderr.write("Error: could not find item '%s' for threshold check\n" % name)
+				continue
+			o = old.get(name, 0)
+			d = dmap[name]
+			rcode |= do_threshold(name, o, d, t_str)
+
+	return rcode
+
+
+def main():
+	if len(sys.argv) != 3:
+		usage()
+		sys.exit(1)
+
+	old = read_report(sys.argv[1])
+	new = read_report(sys.argv[2])
+
+	# ignore kernel config (should do diffconfig eventually)
+	old_config = old["kernel_config"]
+	del(old["kernel_config"])
+	new_config =  new["kernel_config"]
+	del(new["kernel_config"])
+
+	# delta generation copied from bloat-o-meter
+	up = 0
+	down = 0
+	delta = []
+	common = {}
+
+	for a in old:
+		if a in new:
+			common[a] = 1
+
+	for name in old:
+		if name not in common:
+			down += old[name]
+			delta.append((-old[name], name))
+
+	for name in new:
+		if name not in common:
+			up += new[name]
+			delta.append((new[name], name))
+
+	for name in common:
+		d = new.get(name, 0) - old.get(name, 0)
+		if d>0: up += d
+		if d<0: down -= d
+		delta.append((d, name))
+
+	delta.sort()
+	delta.reverse()
+
+	if os.path.isfile(conf_file):
+		rcode = process_report_conf(conf_file, old, delta)
+		sys.exit(rcode)
+	else:
+		print "up: %d, down %d, net change %d" % (up, -down, up-down)
+		fmt = "%-40s %7s %7s %+7s %8s"
+		print fmt % ("item", "old", "new", "change", "percent")
+		fmt = "%-40s %7s %7s %+7s (%4.1f%%)"
+		for d, n in delta:
+			if d:
+				o = old.get(n,0)
+				if o!=0:
+					p = (float(d)/float(o))*100
+				else:
+					p = 100
+				print fmt % (n, old.get(n,"-"),
+					new.get(n,"-"), d, p)
+	sys.exit(0)
+
+main()
diff --git a/scripts/gen-size-report b/scripts/gen-size-report
new file mode 100755
index 0000000..7566c30
--- /dev/null
+++ b/scripts/gen-size-report
@@ -0,0 +1,213 @@
+#!/usr/bin/python
+#
+# gen-size-report - create a size report for the current kernel
+# in a canonical format (human readable, and easily machine diff'able)
+#
+# Copyright 2008 Sony Corporation
+#
+# GPL version 2.0 applies
+#
+# Major report sections:
+# Image totals, Subsystems, Symbols, Runtime, Reference
+#
+# Statement syntax:
+# name=<value>
+# foo_start:
+#  multi-line...
+#  value
+# foo_end
+#
+
+import os, sys
+import commands
+import time
+
+MAJOR_VERSION=0
+MINOR_VERSION=9
+
+outfd = sys.stdout
+
+def usage():
+	print """Usage: gen-size-report [<options>]
+
+-V	show program version
+-h	show this usage help
+"""
+
+
+def title(msg):
+	global outfd
+	outfd.write("### %s\n" % msg)
+
+def close_section():
+	global outfd
+	outfd.write("\n")
+
+def write_line(keyword, value, max_keylen=30):
+	global outfd
+	# format default to: "%-20s %10s\n" % max_keylen
+	format="%%-%ds %%10s\n" % max_keylen
+	outfd.write(format % (keyword+'=', value))
+
+def write_block(keyword, block):
+	global outfd
+	outfd.write("%s_start:\n" % keyword)
+	outfd.write(block)
+	outfd.write("%s_end\n" % keyword)
+	
+def get_sizes(filename):
+	global KBUILD_OUTPUT
+
+	# get image sizes using 'size'
+	cmd = "size %s/%s" % (KBUILD_OUTPUT, filename)
+	(rcode, result) = commands.getstatusoutput(cmd)
+	try:
+		sizes = result.split('\n')[1].split()
+	except:
+		sizes = []
+
+	return sizes
+
+def write_sizes(keyword, sizes):
+	if sizes:
+		write_line("%s_total" % keyword, sizes[3])
+		write_line("%s_text" % keyword, sizes[0])
+		write_line("%s_data" % keyword, sizes[1])
+		write_line("%s_bss" % keyword, sizes[2])
+
+# return a list of compressed images which are present
+def get_compressed_image_list():
+	global KBUILD_OUTPUT
+
+	possible_images = [
+		"arch/x86/boot/bzImage",
+		"arch/arm/boot/Image",
+		"arch/arm/boot/uImage",
+		"arch/arm/boot/zImage",
+		"arch/arm/boot/compressed/vmlinux",
+	]
+	present_images = []
+	for file in possible_images:
+		if os.path.isfile(file):
+			present_images.append(file)
+	return present_images
+	
+def gen_totals():
+	title("Kernel image totals")
+
+	sizes = get_sizes("vmlinux")
+	write_sizes("kernel", sizes)
+
+	# try to find compressed image size
+	# this is arch and target dependent
+	compressed_images = get_compressed_image_list()
+	for filename in compressed_images:
+		size = os.path.getsize(filename)
+		type = os.path.basename(filename)
+		write_line("total_compressed_%s" % type, size)
+
+	close_section()
+
+
+def gen_subsystems():
+	title("Subsystems")
+
+	subsys_list = [
+		("net", "net/built-in.o"),
+		("drivers_net", "drivers/net/built-in.o"),
+		("ipc", "ipc/built-in.o"),
+		("lib", "lib/built-in.o"),
+		("security", "security/built-in.o"),
+		("fs", "fs/built-in.o"),
+		("sound", "sound/built-in.o"),
+		("drivers_char", "drivers/char/built-in.o"),
+		("drivers_video", "drivers/video/built-in.o"),
+		# could add more here
+	]
+
+	for (name, file) in subsys_list:
+		sizes = get_sizes(file)
+		write_sizes("subsys_%s" % name, sizes)
+
+	close_section()
+
+def gen_symbols():
+	global KBUILD_OUTPUT
+
+	title("Symbols")
+
+	# read symbols from kernel image
+	# (some code stolen from bloat-o-meter)
+	filename = "%s/vmlinux" % KBUILD_OUTPUT
+	symlines = os.popen("nm --size-sort %s" % filename).readlines()
+
+    	symbols = {}
+    	for line in symlines:
+        	size, type, name = line[:-1].split()
+        	if type in "tTdDbB":
+            		if "." in name:
+				name = "static_" + name.split(".")[0]
+            		symbols[name] = symbols.get(name, 0) + int(size, 16)
+
+	symlist = symbols.keys()
+	max_sym_len = 0
+	for sym in symlist:
+		if max_sym_len<len(sym):
+			max_sym_len= len(sym)
+	symlist.sort()
+	for sym in symlist:
+		write_line("symbol_%s" % sym, symbols[sym], max_sym_len)
+	
+	# FIXTHIS - should highlight symbols with largest size here?
+	# sort by size, and list top 20 (?) entries
+
+	close_section()
+
+	
+def gen_reference():
+	global KBUILD_OUTPUT
+
+	title("Reference\n")
+
+	# FIXTHIS - show kernel version
+	# FIXTHIS - show compiler version
+
+	# save configuration with report
+	config_filename = "%s/.config" % KBUILD_OUTPUT
+	config = open(config_filename).read()
+	write_block("kernel_config", config)
+
+	close_section()
+
+def main():
+	global KBUILD_OUTPUT
+
+	if "-V" in sys.argv:
+		print "gen-size-report version %d.%d" % \
+			(MAJOR_VERSION, MINOR_VERSION)
+		sys.exit(0)
+	if "-h" in sys.argv:
+		usage()
+		sys.exit(0)
+
+	try:
+		KBUILD_OUTPUT=os.environ["KBUILD_OUTPUT"]
+	except:
+		KBUILD_OUTPUT="."
+	
+	# make sure the kernel is built and ready for sizing
+	# check that vmlinux is present
+	kernel_file = "%s/vmlinux" % KBUILD_OUTPUT
+	if not os.path.isfile(kernel_file):
+		print "Error: Didn't find kernel file: %s" % kernel_file
+		print "Not continuing.  Please build kernel and try again."
+		sys.exit(1)
+
+	# generate size information
+	gen_totals()
+	gen_subsystems()
+	gen_symbols()
+	#gen_runtime()
+	gen_reference()
+
+main()

