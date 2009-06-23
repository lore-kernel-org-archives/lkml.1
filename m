Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbZFWWyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbZFWWyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZFWWx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:53:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34447 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbZFWWx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:53:57 -0400
Date: Tue, 23 Jun 2009 18:53:15 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jesper Nilsson <Jesper.Nilsson@axis.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@ksplice.com>,
       Mikael Starvik <mikael.starvik@axis.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH] Shuffle INIT_TASK* macro names in vmlinux.lds.h (was Re:
 [PATCH] cris: use new macros for .data.init_task.)
In-Reply-To: <20090623211222.GB24201@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0906231721040.2178@vinegar-pot.mit.edu>
References: <1241135077-8001-1-git-send-email-tabbott@mit.edu> <1241135077-8001-2-git-send-email-tabbott@mit.edu> <20090623090614.GZ12383@axis.com> <20090623211222.GB24201@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Sam Ravnborg wrote:

> I have concentrated on the vmlinux.lds stuff.
> And I hope Tim will look into the rest once more.
> 
> Tim - any news from your side?

I've been extremely busy and so I've not had time to rebase my patch 
series for all the architectures for the changes made to the macros in 
vmlinux.lds.h since my original patches were written.  But I will find 
time to send a new version of the prerequisite macros to the files other 
than vmlinux.lds.h tonight, since the macros are just a few small patches.

> On Tue, Jun 23, 2009 at 11:06:14AM +0200, Jesper Nilsson wrote:
> > (And it looks a bit dodgy as it uses INIT_TASK without any argument...)

Also, Jesper's comment reveals a bug in the new macros we merged into 
vmlinux.lds.h:

We recently added a INIT_TASK(align) in include/asm-generic/vmlinux.lds.h, 
but there is already a macro INIT_TASK in include/linux/init_task.h, which 
is quite confusing.  We should switch the macro in the linker script to 
INIT_TASK_DATA. (Sorry that I missed this in reviewing the patch).  Since 
the macros are new, there is only one user of the INIT_TASK in 
vmlinux.lds.h, arch/mn10300/kernel/vmlinux.lds.S.

However, we are currently using INIT_TASK_DATA for laying down an entire 
.data.init_task section.  So rename that to INIT_TASK_DATA_SECTION.

I would be worried about changing the meaning of INIT_TASK_DATA, but the 
old INIT_TASK_DATA implementation had no users, and in fact if anyone had 
tried to use it, it would have failed to compile because it didn't pass 
the alignment to the old INIT_TASK.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/vmlinux.lds.S |    2 +-
 include/asm-generic/vmlinux.lds.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index bcebcef..c96ba3d 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -61,7 +61,7 @@ SECTIONS
 	_edata = .;		/* End of data section */
   }
 
-  .data.init_task : { INIT_TASK(THREAD_SIZE); }
+  .data.init_task : { INIT_TASK_DATA(THREAD_SIZE); }
 
   /* might get freed after init */
   . = ALIGN(PAGE_SIZE);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 92b73b6..fb20e74 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -191,7 +191,7 @@
 	. = ALIGN(align);						\
 	*(.data.cacheline_aligned)
 
-#define INIT_TASK(align)						\
+#define INIT_TASK_DATA(align)						\
 	. = ALIGN(align);						\
 	*(.data.init_task)
 
@@ -434,10 +434,10 @@
 /*
  * Init task
  */
-#define INIT_TASK_DATA(align)						\
+#define INIT_TASK_DATA_SECTION(align)					\
 	. = ALIGN(align);						\
 	.data.init_task : {						\
-		INIT_TASK						\
+		INIT_TASK_DATA(align)					\
 	}
 
 #ifdef CONFIG_CONSTRUCTORS
@@ -707,7 +707,7 @@
 #define RW_DATA_SECTION(cacheline, nosave, pagealigned, inittask)	\
 	. = ALIGN(PAGE_SIZE);						\
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
-		INIT_TASK(inittask)					\
+		INIT_TASK_DATA(inittask)				\
 		CACHELINE_ALIGNED_DATA(cacheline)			\
 		READ_MOSTLY_DATA(cacheline)				\
 		DATA_DATA						\
-- 
1.6.3.1

	-Tim Abbott


