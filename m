Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZHFMZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZHFMZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHFMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:25:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:55591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZHFMZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:25:32 -0400
Date: Thu, 6 Aug 2009 12:25:01 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, airlied@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, airlied@gmail.com
In-Reply-To: <alpine.DEB.2.00.0908052011590.5010@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0908052011590.5010@gandalf.stny.rr.com>
Subject: [tip:tracing/urgent] tracing: do not use functions starting with .L in recordmcount.pl
Message-ID: <tip-3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8@git.kernel.org>
Git-Commit-ID: 3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 12:25:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8
Gitweb:     http://git.kernel.org/tip/3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Wed, 5 Aug 2009 22:00:14 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 5 Aug 2009 22:45:07 -0400

tracing: do not use functions starting with .L in recordmcount.pl

On Wed, 5 Aug 2009, Ingo Molnar wrote:
> * Dave Airlie <airlied@gmail.com> wrote:
>
> > Hey,
> >
> > So I spent 3-4 hrs today (I'm stupid yes) tracking down a .o
> > breakage by blaming rawhide gcc/binutils as I was using make
> > V=1and seeing only the compiler chain running,
>
> Hm, is this that powerpc related build bug you just reported?

Well we tracked it down and it is powerpc64 specific.

Seems that in drivers/hwmon/lm93.c there's a function called:

   LM93_IN_FROM_REG()

But PPC64 has function descriptors and the real function names (the ones
you see in objdump) start with a '.'. Thus this in objdump you have:

 Disassembly of section .text:

 0000000000000000 <.LM93_IN_FROM_REG>:
       0:       7c 08 02 a6     mflr    r0
       4:       fb 81 ff e0     std     r28,-32(r1)

The function name used is .LM93_IN_FROM_REG. But gcc considers symbols
that start with ".L" as a special symbol that is used inside the assembly
stage.

The nm passed into recordmcount uses the --synthetic option which shows
the ".L" symbols (my runs outside of the build did not include the
--synthetic option, so my older patch worked). We see the function as a
local.

Now to capture all the locations that use "mcount" we need to have a
reference to link into the object file a list of mcount callers. We need a
reference that will not disappear. We try to use a global function and if
that does not work, we use a local function as a reference. But to relink
the section back into the object, we need to make it global. In this case,
we run objcopy using --globalize-symbol and --localize-symbol to convert
the symbol into a global symbol, link the mcount list, then convert it
back to a local symbol.

This works great except for this case. .L* symbols can not be converted
into a global symbol, and the mcount section referencing it will remain
unresolved.

Reported-by: Dave Airlie <airlied@gmail.com>
LKML-Reference: <alpine.DEB.2.00.0908052011590.5010@gandalf.stny.rr.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 scripts/recordmcount.pl |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d29baa2..4889c44 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -414,7 +414,10 @@ while (<IN>) {
 	    $offset = hex $1;
 	} else {
 	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) && !defined($weak{$text})) {
+	    if (!defined($ref_func) && !defined($weak{$text}) &&
+		 # PPC64 can have symbols that start with .L and
+		 # gcc considers these special. Don't use them!
+		 $text !~ /^\.L/) {
 		$ref_func = $text;
 		$offset = hex $1;
 	    }
