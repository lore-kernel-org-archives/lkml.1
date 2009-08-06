Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZHFCxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZHFCxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZHFCxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:53:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZHFCxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:53:01 -0400
Message-Id: <20090806025300.829898871@goodmis.org>
References: <20090806025206.306150861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Aug 2009 22:52:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: [PATCH 3/3] tracing: do not use functions starting with .L in recordmcount.pl
Content-Disposition: inline; filename=0003-tracing-do-not-use-functions-starting-with-.L-in-rec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

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
-- 
1.6.3.3

-- 
