Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZG1XuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZG1XuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZG1XuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:21 -0400
Received: from kroah.org ([198.145.64.141]:35874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbZG1XuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:59 2009
Message-Id: <20090728234158.845281426@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Anglin <dave.anglin@nrc-cnrc.gc.ca>, Helge Deller <deller@gmx.de>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: [patch 48/71] parisc: fix ldcw inline assembler
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=parisc-fix-ldcw-inline-assembler.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Helge Deller <deller@gmx.de>

commit 7d17e2763129ea307702fcdc91f6e9d114b65c2d upstream.

There are two reasons to expose the memory *a in the asm:

1) To prevent the compiler from discarding a preceeding write to *a, and
2) to prevent it from caching *a in a register over the asm.

The change has had a few days testing with a SMP build of 2.6.22.19
running on a rp3440.

This patch is about the correctness of the __ldcw() macro itself.
The use of the macro should be confined to small inline functions
to try to limit the effect of clobbering memory on GCC's optimization
of loads and stores.

Signed-off-by: Dave Anglin <dave.anglin@nrc-cnrc.gc.ca>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/system.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/system.h
+++ b/arch/parisc/include/asm/system.h
@@ -168,8 +168,8 @@ static inline void set_eiem(unsigned lon
 /* LDCW, the only atomic read-write operation PA-RISC has. *sigh*.  */
 #define __ldcw(a) ({						\
 	unsigned __ret;						\
-	__asm__ __volatile__(__LDCW " 0(%1),%0"			\
-		: "=r" (__ret) : "r" (a));			\
+	__asm__ __volatile__(__LDCW " 0(%2),%0"			\
+		: "=r" (__ret), "+m" (*(a)) : "r" (a));		\
 	__ret;							\
 })
 


