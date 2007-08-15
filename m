Return-Path: <linux-kernel-owner+w=401wt.eu-S964880AbXHOVL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880AbXHOVL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbXHOVLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:11:21 -0400
Received: from flpi101.sbcis.sbc.com ([207.115.20.70]:16123 "EHLO
	flpi101.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbXHOVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:11:20 -0400
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH] Eliminate result signage problem in asm-x86_64/bitops.h
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2007 17:02:47 -0400
Message-ID: <20070815210247.3518.89243.stgit@monet.1015granger.net>
In-Reply-To: <20070815204939.3518.63203.stgit@monet.1015granger.net>
References: <20070815204939.3518.63203.stgit@monet.1015granger.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The return type of __scanbit() doesn't match the return type of
find_{first,next}_bit().  Thus when you construct something like
this:

   boolean ? __scanbit() : find_first_bit()

you get an unsigned long result if "boolean" is true, and a signed
long result if "boolean" is false.

In file included from /home/cel/src/linux/include/linux/mmzone.h:15,
                 from /home/cel/src/linux/include/linux/gfp.h:4,
                 from /home/cel/src/linux/include/linux/slab.h:14,
                 from /home/cel/src/linux/include/linux/percpu.h:5,
                 from
/home/cel/src/linux/include/linux/rcupdate.h:41,
                 from /home/cel/src/linux/include/linux/dcache.h:10,
                 from /home/cel/src/linux/include/linux/fs.h:275,
                 from /home/cel/src/linux/fs/nfs/sysctl.c:9:
/home/cel/src/linux/include/linux/nodemask.h: In function
‘__first_node’:
/home/cel/src/linux/include/linux/nodemask.h:229: warning: signed and
unsigned type in conditional expression
/home/cel/src/linux/include/linux/nodemask.h: In function
‘__next_node’:
/home/cel/src/linux/include/linux/nodemask.h:235: warning: signed and
unsigned type in conditional expression
/home/cel/src/linux/include/linux/nodemask.h: In function
‘__first_unset_node’:
/home/cel/src/linux/include/linux/nodemask.h:253: warning: signed and
unsigned type in conditional expression

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---

 include/asm-x86_64/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86_64/bitops.h b/include/asm-x86_64/bitops.h
index d4dbbe5..1d7d9b4 100644
--- a/include/asm-x86_64/bitops.h
+++ b/include/asm-x86_64/bitops.h
@@ -260,7 +260,7 @@ extern long find_first_bit(const unsigned long * addr, unsigned long size);
 extern long find_next_bit(const unsigned long * addr, long size, long offset);
 
 /* return index of first bet set in val or max when no bit is set */
-static inline unsigned long __scanbit(unsigned long val, unsigned long max)
+static inline long __scanbit(unsigned long val, unsigned long max)
 {
 	asm("bsfq %1,%0 ; cmovz %2,%0" : "=&r" (val) : "r" (val), "r" (max));
 	return val;

