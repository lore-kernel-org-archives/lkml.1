Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXJRJRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXJRJRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbXJRJRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:17:44 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23077 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761688AbXJRJRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:17:43 -0400
Date: Thu, 18 Oct 2007 11:17:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018091706.GO5063@kernel.dk>
References: <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471720FE.4090004@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Jeff Garzik wrote:
> Jens Axboe wrote:
>> index 4df8311..b858183 100644
>> --- a/drivers/ata/sata_mv.c
>> +++ b/drivers/ata/sata_mv.c
>> @@ -1139,6 +1139,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>>  	struct mv_port_priv *pp = qc->ap->private_data;
>>  	struct scatterlist *sg;
>>  	struct mv_sg *mv_sg;
>> +	int end_marked = 0;
>>   	mv_sg = pp->sg_tbl;
>>  	ata_for_each_sg(sg, qc) {
>> @@ -1159,13 +1160,15 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>>  			sg_len -= len;
>>  			addr += len;
>>  -			if (!sg_len && ata_sg_is_last(sg, qc))
>> +			if (!sg_len && ata_sg_is_last(sg, qc)) {
>>  				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
>> +				end_marked++;
>> +			}
>>   			mv_sg++;
>>  		}
>> -
>>  	}
>> +	BUG_ON(end_marked != 1);
>
>
> Your BUG_ON() does indeed trip, here.
>
> Its surprising that other folks don't explode, considering that 
> mv_fill_sg() intentionally mirrors the logic in ata_fill_sg().

The sata_mv construct looks a bit odd. Does this work? That last
end_mv_sg test should always be true, just being paranoid...

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4df8311..5397eea 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1138,8 +1138,9 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct mv_port_priv *pp = qc->ap->private_data;
 	struct scatterlist *sg;
-	struct mv_sg *mv_sg;
+	struct mv_sg *mv_sg, *end_mv_sg;
 
+	end_mv_sg = NULL;
 	mv_sg = pp->sg_tbl;
 	ata_for_each_sg(sg, qc) {
 		dma_addr_t addr = sg_dma_address(sg);
@@ -1158,14 +1159,12 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 
 			sg_len -= len;
 			addr += len;
-
-			if (!sg_len && ata_sg_is_last(sg, qc))
-				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
-
+			end_mv_sg = mv_sg;
 			mv_sg++;
 		}
-
 	}
+	if (end_mv_sg)
+		end_mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
 }
 
 static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)

-- 
Jens Axboe

