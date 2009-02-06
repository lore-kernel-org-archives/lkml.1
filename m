Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZBFB46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZBFB46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZBFB4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:56:50 -0500
Received: from relay3.sgi.com ([192.48.171.31]:41771 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752794AbZBFB4t (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:56:49 -0500
Message-ID: <498B9852.5060909@melbourne.sgi.com>
Date: Fri, 06 Feb 2009 12:54:26 +1100
From: Greg Banks <gnb@melbourne.sgi.com>
Organization: File Serving Technologies ; Silicon Graphics Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       nfsv4@linux-nfs.org, systemtap@sources.redhat.com
Subject: Re: [Patch 0/2] dynamic debug
References: <20090205164520.GB3114@redhat.com> <20090205175849.GA936@kroah.com> <20090205184304.GF3114@redhat.com>
In-Reply-To: <20090205184304.GF3114@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> On Thu, Feb 05, 2009 at 09:58:49AM -0800, Greg KH wrote:
>   
>> On Thu, Feb 05, 2009 at 11:45:20AM -0500, Jason Baron wrote:
>>     
>>> hi,
>>>
>>> This patchset combines Greg Bank's dprintk() patchset with the dynamic printk
>>> patchset. We are renaming the combined solution 'dynamic debug'. As a reminder,
>>> the patchset allows debug printk style statements to be dynamically 
>>> enabled/disabled at runtime.
>>>
>>> The key new feature of this patchset is a richer /debugfs control file
>>> interface, (an example output from my system is at the bottom), which allows
>>> fined grained control over the the debug output. The output can be controlled by
>>> function, file and line number, module, and format string. 
>>>       
>> That's nice, but do we really need to have that kind of control?  It
>> seems like overkill.
>>
>>     
>
> given the ability of this feature to very quickly fill the logs, I think
> it makes sense for some cases. Also, Greg found it very useful in his debugging
> work...
>   

This feature was originally written to control the dprintk() macro which
is heavily used in NFS code.  When the NFS/RDMA code was being developed
there was no way to do network packet capture on that transport, so the
dprintk() macros were the only practical debugging tool.  Hence when
fully enabled there are a *lot* of them, thousands per NFS call.  This
flood is

a) extremely hard to wade through
b) tends to overflow the printk buffer
c) tends to get mixed up in the printk buffer
d) slows down the code enough to make some bugs stop happening -
Heisendebugging

Hence the fine-grained control feature.  Later it turned out that field
support guys found it useful too.
>   
>>>
>>> # filename:lineno [module]function flags format
>>> arch/x86/kernel/setup_percpu.c:260 [setup_percpu]numa_set_node - "Setting\040node\040for\040non-present\040cpu\040%d\012"
>>>       
>> Why the \040 syntax?  Can't we handle a space in a string?  Makes it
>> very hard to grep for things...
>>
>>     
>
> ok, patch below resolves the space issue.
>   

The above patch makes the output much easier for a human to read, which
is good.

However it's half the job.  The parser for the language used when
writing to the control file still uses whitespace to tokenize and is
still too dumb to handle quoting and so needs all whitespace escaped,
like this

#echo -n 'format Setting\040node\040for\040non-present\040cpu +p' > /mnt/debugfs/dynamic_debug/control

Which is documented in the howto.  So that you could copy-n-paste in a
terminal window, I chose to make the input and output formats as similar
as possible, and used escaping for all whitespace on output.  That was
just me being lazy, sorry.  Below is a patch which implements a better
solution, which is to fix ddebug_tokenize() to handle simple quoting so
the above would look like

#echo -n 'format "Setting node for non-present cpu" +p' > /mnt/debugfs/dynamic_debug/control


-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.



Allow simple quoting of words in the dynamic debug control language.

This allows more natural specification when using the control language
to match against printk formats, e.g

#echo -n 'format "Setting node for non-present cpu" +p' >
	/mnt/debugfs/dynamic_debug/control

instead of

#echo -n 'format Setting\040node\040for\040non-present\040cpu +p' >
	/mnt/debugfs/dynamic_debug/control

Adjust the dynamic debug documention to describe that and provide a
new example.  Adjust the existing examples in the documentation to
reflect the current whitespace escaping behaviour when reading the
control file.  Fix some minor documentation trailing whitespace.

Signed-off-by: Greg Banks <gnb@melbourne.sgi.com>
---

 Documentation/dynamic-debug-howto.txt |   28 +++++++-----
 lib/dynamic_debug.c                   |   53 ++++++++++++++---------
 2 files changed, 51 insertions(+), 30 deletions(-)

Index: linux-git/lib/dynamic_debug.c
===================================================================
--- linux-git.orig/lib/dynamic_debug.c
+++ linux-git/lib/dynamic_debug.c
@@ -196,32 +196,45 @@ static void ddebug_change(const struct d
 }
 
 /*
- * Wrapper around strsep() to collapse the multiple empty tokens
- * that it returns when fed sequences of separator characters.
- * Now, if we had strtok_r()...
- */
-static inline char *nearly_strtok_r(char **p, const char *sep)
-{
-	char *r;
-
-	while ((r = strsep(p, sep)) != NULL && *r == '\0')
-		;
-	return r;
-}
-
-/*
  * Split the buffer `buf' into space-separated words.
- * Return the number of such words or <0 on error.
+ * Handles simple " and ' quoting, i.e. without nested,
+ * embedded or escaped \".  Return the number of words
+ * or <0 on error.
  */
 static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 {
 	int nwords = 0;
 
-	while (nwords < maxwords &&
-	       (words[nwords] = nearly_strtok_r(&buf, " \t\r\n")) != NULL)
-		nwords++;
-	if (buf)
-		return -EINVAL;	/* ran out of words[] before bytes */
+	while (*buf) {
+		char *end;
+
+		/* Skip leading whitespace */
+		while (*buf && isspace(*buf))
+			buf++;
+		if (!*buf)
+			break;	/* oh, it was trailing whitespace */
+
+		/* Run `end' over a word, either whitespace separated or quoted */
+		if (*buf == '"' || *buf == '\'') {
+			int quote = *buf++;
+			for (end = buf ; *end && *end != quote ; end++)
+				;
+			if (!*end)
+				return -EINVAL;	/* unclosed quote */
+		} else {
+			for (end = buf ; *end && !isspace(*end) ; end++)
+				;
+			BUG_ON(end == buf);
+		}
+		/* Here `buf' is the start of the word, `end' is one past the end */
+
+		if (nwords == maxwords)
+			return -EINVAL;	/* ran out of words[] before bytes */
+		if (*end)
+			*end++ = '\0';	/* terminate the word */
+		words[nwords++] = buf;
+		buf = end;
+	}
 
 	if (verbose) {
 		int i;
Index: linux-git/Documentation/dynamic-debug-howto.txt
===================================================================
--- linux-git.orig/Documentation/dynamic-debug-howto.txt
+++ linux-git/Documentation/dynamic-debug-howto.txt
@@ -5,13 +5,13 @@ Introduction
 This document describes how to use the dynamic debug (ddebug) feature.
 
 Dynamic debug is designed to allow you to dynamically enable/disable kernel
-code to obtain additional kernel information. Currently, if 
+code to obtain additional kernel information. Currently, if
 CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_debug() calls can be
 dynamically enabled per-callsite.
 
 Dynamic debug has even more useful features:
 
- * Simple query language allows turning on and off debugging statements by 
+ * Simple query language allows turning on and off debugging statements by
    matching any combination of:
 
    - source filename
@@ -20,7 +20,7 @@ Dynamic debug has even more useful featu
    - module name
    - format string
 
- * Provides a debugfs control file: <debugfs>/dynamic_debug/control which can be 
+ * Provides a debugfs control file: <debugfs>/dynamic_debug/control which can be
    read to display the complete list of known debug statements, to help guide you
 
 Controlling dynamic debug Behaviour
@@ -32,7 +32,7 @@ filesystem, in order to make use of this
 control file as: <debugfs>/dynamic_debug/control. For example, if you want to
 enable printing from source file 'svcsock.c', line 1603 you simply do:
 
-nullarbor:~ # echo 'file svcsock.c line 1603 +p' > 
+nullarbor:~ # echo 'file svcsock.c line 1603 +p' >
 				<debugfs>/dynamic_debug/control
 
 If you make a mistake with the syntax, the write will fail thus:
@@ -49,10 +49,10 @@ via:
 
 nullarbor:~ # cat <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup - "SVCRDMA\040Module\040Removed,\040deregister\040RPC\040RDMA\040transport\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init - "\011max_inline\040\040\040\040\040\040\040:\040%d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init - "\011sq_depth\040\040\040\040\040\040\040\040\040:\040%d\012"
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init - "\011max_requests\040\040\040\040\040:\040%d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:323 [svcxprt_rdma]svc_rdma_cleanup - "SVCRDMA Module Removed, deregister RPC RDMA transport\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:341 [svcxprt_rdma]svc_rdma_init - "\011max_inline       : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:340 [svcxprt_rdma]svc_rdma_init - "\011sq_depth         : %d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svc_rdma.c:338 [svcxprt_rdma]svc_rdma_init - "\011max_requests     : %d\012"
 ...
 
 
@@ -72,7 +72,7 @@ you can view all the debug statement cal
 
 nullarbor:~ # awk '$3 != "-"' <debugfs>/dynamic_debug/control
 # filename:lineno [module]function flags format
-/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process:\040st_sendto\040returned\040%d\012"
+/usr/src/packages/BUILD/sgi-enhancednfs-1.4/default/net/sunrpc/svcsock.c:1603 [sunrpc]svc_send p "svc_process: st_sendto returned %d\012"
 
 
 Command Language Reference
@@ -166,11 +166,15 @@ format
     entire format, only some part.  Whitespace and other
     special characters can be escaped using C octal character
     escape \ooo notation, e.g. the space character is \040.
+    Alternatively, the string can be enclosed in double quote
+    characters (") or single quote characters (').
     Examples:
 
     format svcrdma:	    // many of the NFS/RDMA server dprintks
     format readahead	    // some dprintks in the readahead cache
-    format nfsd:\040SETATTR // how to match a format with whitespace
+    format nfsd:\040SETATTR // one way to match a format with whitespace
+    format "nfsd: SETATTR"  // a neater way to match a format with whitespace
+    format 'nfsd: SETATTR'  // yet another way to match a format with whitespace
 
 line
     The given line number or range of line numbers is compared
@@ -230,3 +234,7 @@ nullarbor:~ # echo -n 'func svc_process 
 // disable all 12 messages in the function svc_process()
 nullarbor:~ # echo -n 'func svc_process -p' >
 				<debugfs>/dynamic_debug/control
+
+// enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
+nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
+				<debugfs>/dynamic_debug/control



