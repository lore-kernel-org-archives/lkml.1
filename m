Return-Path: <linux-kernel-owner+w=401wt.eu-S935537AbXJQVNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935537AbXJQVNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbXJQVNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:13:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757409AbXJQVNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:13:14 -0400
Date: Wed, 17 Oct 2007 14:11:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071017203140.GF15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
References: <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk>
 <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu>
 <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>
 <20071017193542.GA15552@kernel.dk> <alpine.LFD.0.999.0710171244330.26902@woody.linux-foundation.org>
 <20071017195659.GD15552@kernel.dk> <20071017200638.GE15552@kernel.dk>
 <alpine.LFD.0.999.0710171321400.26902@woody.linux-foundation.org>
 <20071017203140.GF15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
>
> That would hurt... Care to commit your for_each_sg() uglification fixup
> for now then? Or disable the allocation debug config entry, so that the
> sg+1 deref wont crash?

Well, in practice, it will only crash with DEBUG_PAGEALLOC, so few enough 
are going to be hit by it. In that sense I don't think we're in any deep 
trouble yet.

That said, maybe this is an acceptable, if hacky, replacement for the 
current "for_each_sg()" loop.

It does:
 - starts at one *before* the sglist
 - does the sg_next() at the *top* of the loop rather than the bottom of it
 - has a "--count" before that sg_next, so that we don't do it for the 
   case when we break out and have used up all segments.

Totally untested, but it *may* work, and it doesn't look horribly ugly.

Ingo, does this actually make any difference?

		Linus

---
 include/linux/scatterlist.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2dc7464..f5c8e11 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -51,11 +51,18 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
 	return sg;
 }
 
+static inline struct scatterlist *sg_safe_next(struct scatterlist *sg, int left)
+{
+	if (left < 0)
+		return NULL;
+	return sg_next(sg);
+}
+
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
  */
 #define for_each_sg(sglist, sg, nr, __i)	\
-	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
+	for (__i = (nr), sg = (sglist)-1; (sg = sg_safe_next(sg, --__i)) != NULL ; )
 
 /**
  * sg_last - return the last scatterlist entry in a list
