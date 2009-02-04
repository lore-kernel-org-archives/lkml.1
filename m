Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZBDSuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZBDSuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759561AbZBDSpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:45:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:21361 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759768AbZBDSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:45:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=uf9RXy9R7ssCL+a4aXpDo9KPKpzmHaznBm/lZpG+LfahiZj0fFi3nywv5bww2HFNnD
         GwCO/Ii+xkhcAJAbs+jQtmjqCfKv8MzalxRyr2JTgXbXp5vZL0FvSyJ3OvPY1tFpZxkd
         uEOLcIm3VhLQCJGNqwV//EA8r9weaEyaleXl4=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Do not __always_inline bvec_kmap_irq() and bvec_kunmap_irq()
Date: Wed,  4 Feb 2009 16:45:02 -0200
Message-Id: <1233773102-12903-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.1.1.363.g2a3bd
In-Reply-To: <20090203085111.GT30821@kernel.dk>
References: <20090203085111.GT30821@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03 2009, Andrew Morton wrote:
> The comment is wrong - this was a sparc requirement, long since removed.

So remove both the comment and the inline requirement, going back to the
inline hint.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---

So I came up with this, but I'm not sure if it's better than just avoid the
inline and placing them somewhere else. If you want me to write a different
patch, let me know.

Thanks a lot,
		Alberto



 include/linux/bio.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 713ec6e..20bcc51 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -442,10 +442,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
 /*
  * remember never ever reenable interrupts between a bvec_kmap_irq and
  * bvec_kunmap_irq!
- *
- * This function MUST be inlined - it plays with the CPU interrupt flags.
  */
-static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
+static inline char *bvec_kmap_irq(struct bio_vec *bvec,
 		unsigned long *flags)
 {
 	unsigned long addr;
@@ -462,7 +460,7 @@ static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
 	return (char *) addr + bvec->bv_offset;
 }
 
-static __always_inline void bvec_kunmap_irq(char *buffer,
+static inline void bvec_kunmap_irq(char *buffer,
 		unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
-- 
1.6.1.1.363.g2a3bd

