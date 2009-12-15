Return-Path: <linux-kernel-owner+w=401wt.eu-S933953AbZLOWJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbZLOWJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933930AbZLOWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:09:04 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:44384 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922AbZLOWJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:09:01 -0500
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Heinz Diehl <htd@fancy-poultry.org>,
       LKML <linux-kernel@vger.kernel.org>, martin.petersen@oracle.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device mapper warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <200912091049.12604.borntraeger@de.ibm.com>
	<20091209212516.GA6206@fancy-poultry.org>
	<20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
	<alpine.DEB.2.01.0912151354350.3483@bogon.housecafe.de>
	<20091215220249.GG28252@kernel.dk>
Date: Tue, 15 Dec 2009 17:08:45 -0500
In-Reply-To: <20091215220249.GG28252@kernel.dk> (Jens Axboe's message of "Tue,
	15 Dec 2009 23:02:50 +0100")
Message-ID: <yq14onrubyq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B2808F4.0099:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> I'll revert the bad commit tomorrow so that -rc1 wont be affected,
Jens> at least.

I'm pretty close to having a new stacking algorithm that works.  If I
don't have it ready by tomorrow maybe we should commit the following
patch instead of reverting the discard changes wholesale?

diff --git a/block/blk-settings.c b/block/blk-settings.c
index dd1f1e0..65ae861 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -555,10 +555,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	if (offset &&
-	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
+	    (offset & (b->discard_granularity - 1)) != b->discard_alignment)
 		t->discard_misaligned = 1;
-		ret = -1;
-	}
 
 	/* If top has no alignment offset, inherit from bottom */
 	if (!t->alignment_offset)
