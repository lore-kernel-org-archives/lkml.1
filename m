Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbYKZJTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYKZJTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKZJTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:19:18 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:37707 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752015AbYKZJTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:19:16 -0500
Date: Wed, 26 Nov 2008 18:17:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Detecting endianness in scripts/recordmcount.pl?
Message-ID: <20081126091752.GA21466@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20081126083905.GA20472@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126083905.GA20472@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 05:39:05PM +0900, Paul Mundt wrote:
> Presently there doesn't seem to be any way to determine whether the
> target is big or little endian, and it is assumed that the compiler will
> do the right thing by default. Unfortunately this can not be assumed,
> and mismatches ensue, resulting in the linker bailing out.
> 
> The only obvious solution I saw was to pass in KBUILD_CFLAGS and ld_flags
> along with $(CC) and $(LD) to the script, and killing off the hardcoded
> flags. This at least gets things building, but that still leaves objcopy
> and objdump as the odd ones out. On the other hand, the format can be figured
> out by objdumping the object and reading in the file format line, but people
> obviously do not have consistent naming for these, and a double-pass would
> be needed -- once for establishing little or big, followed by figuring out
> which set of regexes to use.
> 
This is roughly what I had in mind for the objdump test, perhaps
something like this could be reimplemented by someone who knows something
about perl?

---

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index c67cec8..177f4ee 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -143,6 +143,20 @@ if ($arch eq "x86") {
     }
 }
 
+open(IN, "$objdump -p $inputfile|") || die "error running $objdump";
+
+my $endian = "little";
+
+while (<IN>) {
+	next if /^(\s)*$/;
+	s/^.*file format //g;
+	if (/big/) {
+		$endian = "big";
+	}
+	last;
+}
+close(IN);
+
 if ($arch eq "x86_64") {
     $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
@@ -174,10 +188,15 @@ if ($arch eq "x86_64") {
     $type = ".long";
 
     # force flags for this arch
-    $ld .= " -m shlelf_linux";
-    $objcopy .= " -O elf32-sh-linux";
-    $cc .= " -m32";
-
+    if ($endian eq "big") {
+	    $ld .= " -m shelf_linux";
+	    $objcopy .= " -O elf32-shbig-linux";
+	    $cc .= " -mb";
+    } else {
+            $ld .= " -m shlelf_linux";
+            $objcopy .= " -O elf32-sh-linux";
+            $cc .= " -ml";
+    }
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
