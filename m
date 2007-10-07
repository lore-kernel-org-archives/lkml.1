Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbXJGTHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbXJGTHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbXJGTHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:07:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49664 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXJGTHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:07:38 -0400
Date: Sun, 7 Oct 2007 15:05:47 -0400
Message-Id: <200710071905.l97J5l6r018154@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Ingo Molnar <mingo@elte.hu>, apw@shadowen.org
Cc: Erez Zadok <ezk@cs.sunysb.edu>, rdunlap@xenotime.net,
       jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 checkpatch updates, new checkfiles script 
In-reply-to: Your message of "Sat, 06 Oct 2007 13:13:43 +0200."
             <20071006111343.GA29484@elte.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071006111343.GA29484@elte.hu>, Ingo Molnar writes:
> 
> * Erez Zadok <ezk@cs.sunysb.edu> wrote:
> 
> > So, I ran the above script and it found nearly 1.5 million reported 
> > warnings/errors, with drivers being the largest abuser, not 
> > surprisingly. [...]
> 
> have you tried that with the latest version too:
> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-next
> 
> it outputs far fewer false positives.
> 
> 	Ingo

Andy, Ingo,

I tried the new checkpatch.pl on 2.6.23-rc9:

$ ./scripts/checkpatch.pl -q --file --emacs fs/namei.c

and got many perl warnings such as:

Use of uninitialized value in concatenation (.) or string at ./scripts/checkpatch.pl line 455.

followed by the usual verbose error message instead of one-per-line as I
assume the --emacs option is supposed to produce:

:2823: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#2823: FILE: namei.c:2820:
+EXPORT_SYMBOL(vfs_mkdir);

BTW, calling the option --emacs is a bit too restrictive.  Emacs didn't
invent the format of "filename:linenumeber:message".  C compilers had it
before.  Even "grep -n *" had it before.  That's why I think calling it a
"terse output" option may be more accurate.

The following small patch to checkpath.pl-next seems to fix the perl
warnings, but it still outputs the long error messages along with the
shorter one-liners.

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bdc493e..bbc4825 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -85,7 +85,7 @@ for my $filename (@ARGV) {
 		push(@rawlines, $_);
 	}
 	close(FILE);
-	if (!process($ARGV, @rawlines)) {
+	if (!process($filename, @rawlines)) {
 		$exit = 1;
 	}
 	@rawlines = ();
@@ -452,7 +452,7 @@ sub process {
 
 		my $rawline = $line;
 
-		$prefix = "$ARGV:$linenr: " if ($emacs);
+		$prefix = "$filename:$linenr: " if ($emacs);
 
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {

Cheers,
Erez.
