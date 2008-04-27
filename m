Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYD0IUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYD0IUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYD0IUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:20:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYD0IU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:20:29 -0400
Date: Sun, 27 Apr 2008 10:20:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427082010.GA13848@elte.hu>
References: <20080426.215513.141243565.davem@davemloft.net> <20080427055943.GA16290@elte.hu> <20080426.230807.144232984.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.230807.144232984.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 27 Apr 2008 07:59:43 +0200
> 
> > ... as i saw no reason why this feature, which i found rather 
> > useful, should be delayed another year or so. I'd be more than happy 
> > to promote this feature back to lib/Kconfig.debug, sparc64 interest 
> > would make that a strong argument.
> 
> So you caved in to FUD in order to pad your commit and signoff count?

David, stop this nonsense already.

Had you read the lkml discussion thread i linked to:

  http://lkml.org/lkml/2008/3/3/122

... you'd realize that the first thing i did was to make it a generic 
feature. But it was claimed on lkml that this would break an unknown 
number of architectures:

| > > And what we should do is to attack the excessive wrong usage of 
| > > inlines in .c files, not messing with a global #define in a way 
| > > that the results on 24 architectures with 7 different releases of 
| > > gcc would be unpredictable.

Where were you in that thread defending my position? Andrew showed 
interest, gave me feedback and i incorporated that feedback.

I am fully willing and ready to move this feature to a generic file (via 
the patch below), in fact i implemented it that way from the get go, but 
only:

   _if other architecture maintainers want it too_

Nobody countered the "it would break other architectures" position in 
that discussion, and i'm not interested in endless bikeshed painting 
either.

lets look at a counter-example where other architecture maintainers 
showed interest: the recent bitops generalizations we did for x86 and 
extended to all other architectures. It was welcome by other maintainers 
and we did it that way. See the merge commit 9b79ed952bd734 for an 
overview of this topic:

    x86, bitops: select the generic bitmap search functions
    x86: include/asm-x86/pgalloc.h/bitops.h: checkpatch cleanups - formatting
    x86: finalize bitops unification
    x86, UML: remove x86-specific implementations of find_first_bit
    x86: optimize find_first_bit for small bitmaps
    x86: switch 64-bit to generic find_first_bit
    x86: generic versions of find_first_(zero_)bit, convert i386
    bitops: use __fls for fls64 on 64-bit archs
    generic: implement __fls on all 64-bit archs
    generic: introduce a generic __fls implementation
    x86: merge the simple bitops and move them to bitops.h
    x86, generic: optimize find_next_(zero_)bit for small constant-size bitmap
    x86, uml: fix uml with generic find_next_bit for x86
    x86: change x86 to use generic find_next_bit
    uml: Kconfig cleanup
    uml: fix build error

	Ingo

-------------------------------->
Subject: generic: optimize inlining
From: Ingo Molnar <mingo@elte.hu>
Date: Sun Apr 27 09:36:29 CEST 2008

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.debug |   12 ------------
 init/Kconfig           |   13 +++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

Index: linux/arch/x86/Kconfig.debug
===================================================================
--- linux.orig/arch/x86/Kconfig.debug
+++ linux/arch/x86/Kconfig.debug
@@ -355,15 +355,3 @@ config CPA_DEBUG
 
 endmenu
 
-config OPTIMIZE_INLINING
-	bool "Allow gcc to uninline functions marked 'inline'"
-	default y
-	help
-	  This option determines if the kernel forces gcc to inline the functions
-	  developers have marked 'inline'. Doing so takes away freedom from gcc to
-	  do what it thinks is best, which is desirable for the gcc 3.x series of
-	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
-	  disabling this option will generate a smaller kernel there. Hopefully
-	  this algorithm is so good that allowing gcc4 to make the decision can
-	  become the default in the future, until then this option is there to
-	  test gcc for this.
Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -520,6 +520,19 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+config OPTIMIZE_INLINING
+	bool "Allow gcc to uninline functions marked 'inline'"
+	default y
+	help
+	  This option determines if the kernel forces gcc to inline the functions
+	  developers have marked 'inline'. Doing so takes away freedom from gcc to
+	  do what it thinks is best, which is desirable for the gcc 3.x series of
+	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
+	  disabling this option will generate a smaller kernel there. Hopefully
+	  this algorithm is so good that allowing gcc4 to make the decision can
+	  become the default in the future, until then this option is there to
+	  test gcc for this.
+
 config SYSCTL
 	bool
 
