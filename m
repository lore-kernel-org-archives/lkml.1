Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZFQWSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZFQWSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZFQWS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:18:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461AbZFQWS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:18:26 -0400
Date: Wed, 17 Jun 2009 15:17:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] block updates for 2.6.31-rc1
Message-Id: <20090617151754.e7c4c58c.akpm@linux-foundation.org>
In-Reply-To: <20090616071823.GL11363@kernel.dk>
References: <20090616071823.GL11363@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 09:18:23 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Martin K. Petersen (1):
>       block: Introduce helper to reset queue limits to default values


i386 allnoconfig:

block/blk-settings.c: In function 'blk_set_default_limits':
block/blk-settings.c:115: warning: large integer implicitly truncated to unsigned type


The patch was sent on June 12, acked on June 15, merged into mainline
June 16 and never made an appearance in linux-next.

It doesn't look like it'll cause any runtime problems, but that just
means we got lucky.  


Suggested fix is to use plain old "-1", rather than (incorrectly)
guessing what type the caller might be assigning to.

--- a/include/linux/blkdev.h~a
+++ a/include/linux/blkdev.h
@@ -702,7 +702,7 @@ extern unsigned long blk_max_low_pfn, bl
 #else
 #define BLK_BOUNCE_HIGH		-1ULL
 #endif
-#define BLK_BOUNCE_ANY		(-1ULL)
+#define BLK_BOUNCE_ANY		(-1)
 #define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)
 
 /*
_


Or is the code just buggy?  What are the units of BLK_BOUNCE_HIGH,
BLK_BOUNCE_ANY and BLK_BOUNCE_ISA?  Seems that they are physical
addresses.  So why are we copying one of these onto a variable which
records pfns?

If BLK_BOUNCE_ANY's units are indeed pfns (not the case afaict) then
using a ULL was inappropriate.

