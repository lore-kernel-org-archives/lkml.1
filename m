Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbXI1VdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbXI1VdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXI1Vcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:32:51 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55875 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbXI1Vct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:32:49 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>, Erez Zadok <ezk@cs.sunysb.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>
Subject: [PATCH 1/3] CodingStyle updates
Date: Fri, 28 Sep 2007 17:32:00 -0400
Message-Id: <11910151223447-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. Updates chapter 13 (printing kernel messages) to expand on the use of
   pr_debug()/pr_info(), what to avoid, and how to hook your debug code with
   kernel.h.

2. New chapter 19, branch prediction optimizations, discusses the whole
   un/likely issue.

Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: roel <12o3l@tiscali.nl>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/CodingStyle |   88 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 7f1730f..00b29e4 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -643,8 +643,26 @@ Printing numbers in parentheses (%d) adds no value and should be avoided.
 There are a number of driver model diagnostic macros in <linux/device.h>
 which you should use to make sure messages are matched to the right device
 and driver, and are tagged with the right level:  dev_err(), dev_warn(),
-dev_info(), and so forth.  For messages that aren't associated with a
-particular device, <linux/kernel.h> defines pr_debug() and pr_info().
+dev_info(), and so forth.
+
+A number of people often like to define their own debugging printf's,
+wrapping printk's in #ifdef's that get turned on only when subsystem
+debugging is compiled in (e.g., dprintk, Dprintk, DPRINTK, etc.).  Please
+don't reinvent the wheel but use existing mechanisms.  For messages that
+aren't associated with a particular device, <linux/kernel.h> defines
+pr_debug() and pr_info(); the latter two translate to printk(KERN_DEBUG) and
+printk(KERN_INFO), respectively.  However, to get pr_debug() to actually
+emit the message, you'll need to turn on DEBUG in your code, which can be
+done as follows in your subsystem Makefile:
+
+ifeq ($(CONFIG_WHATEVER_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+In this way, you can create a Kconfig parameter to turn on debugging at
+compile time, which will also turn on DEBUG, to enable pr_debug() to emit
+actual messages; conversely, when CONFIG_WHATEVER_DEBUG is off, DEBUG is
+off, and pr_debug() will display nothing.
 
 Coming up with good debugging messages can be quite a challenge; and once
 you have them, they can be a huge help for remote troubleshooting.  Such
@@ -779,6 +797,69 @@ includes markers for indentation and mode configuration.  People may use their
 own custom mode, or may have some other magic method for making indentation
 work correctly.
 
+		Chapter 19: branch prediction optimizations
+
+The kernel includes macros called likely() and unlikely(), which can be used
+as hints to the compiler to optimize branch prediction.  They operate by
+asking gcc to shuffle the code around so that the more favorable outcome
+executes linearly, avoiding a JMP instruction; this can improve cache
+pipeline efficiency.  For technical details how these macros work, see the
+References section at the end of this document.
+
+An example use of this as as follows:
+
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (unlikely(!ptr))
+		...
+
+or
+	err = some_function(...);
+	if (likely(!err))
+		...
+
+The main two problems with using un/likely() are that (a) programmers can
+easily be wrong about their code's likelihood to take one branch
+vs. another, and (b) on average, gcc will do a much better job optimizing
+branches that the programmer can.  The benefit on some systems for
+predicting correctly can be in saving a few instructions.  But the penalty
+for wrong use of un/likely() can be very significant (possibly dozens of
+instructions), as you may be doing a JMP instruction, hurting your pipeline
+cache, EACH time you get to the branch in question!
+
+Therefore, use un/likely() sparingly, consider it primarily for hot paths,
+use it only when you are certain that the condition in question rarely
+happens, be sure that it happens with roughly the same probability under
+most/all user conditions.  One rule of thumb suggested is that the
+probability of the branch un/taken should exceed 99% (although some would
+consider 95% as well).  Of course, beware of silly mistakes such as
+intending to use likely() and using unlikely() instead.
+
+A good example of this is the above kmalloc(GFP_KERNEL) call.  The chances
+of kmalloc() returning NULL are rather small, because even if it doesn't
+have memory to return to you at the moment, with GFP_KERNEL/__GFP_WAIT
+passed, kmalloc() will wait and suspend your thread, while it goes off to
+find some free memory (purging caches, flushing buffers, etc.).  In other
+words, kmalloc() tries very hard to give you the memory you asked for by the
+time it return.
+
+Consider the next, bad example.  Suppose you're developing a file system
+which performs logically different actions on different types of entities:
+files, directories, symlinks, devices, etc. and you use this code:
+
+	if (unlikely(S_ISBLK(mode))
+		...
+
+On first glance, the above use of unlikely() seems right.  After all, most
+file system objects are files and directories, and very few of them tend to
+be block devices.  So this optimization should work well, no?  Although it's
+true that it'll work well for most users, what about some user who happens
+to have a file system with lots of block devices?  Or what if the user has
+only one block device object on the file system, but the user has an
+application which causes the above conditional to be traversed very
+frequently (e.g., a shell script that deals with devices)?  Such users will
+be penalized heavily for going [sic] down the wrong path...  Therefore, you
+should consider also whether a seemingly-rare condition is indeed rare ALL
+the time.
 
 
 		Appendix I: References
@@ -804,6 +885,9 @@ language C, URL: http://www.open-std.org/JTC1/SC22/WG14/
 Kernel CodingStyle, by greg@kroah.com at OLS 2002:
 http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
 
+FAQ/LikelyUnlikely:
+http://kernelnewbies.org/FAQ/LikelyUnlikely
+
 --
 Last updated on 2007-July-13.
 
-- 
1.5.2.2

