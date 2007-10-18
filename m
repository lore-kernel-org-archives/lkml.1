Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXJRIdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXJRIdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbXJRIcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:32:51 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3606 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbXJRIcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:32:50 -0400
Date: Thu, 18 Oct 2007 10:32:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018083213.GN5063@kernel.dk>
References: <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471717BF.4030108@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Jeff Garzik wrote:
> Ingo Molnar wrote:
>> * Jens Axboe <jens.axboe@oracle.com> wrote:
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -39,7 +39,7 @@
>>>   * (unless chaining is used). Should ideally fit inside a single page, 
>>> to
>>>   * avoid a higher order allocation.
>>>   */
>>> -#define SCSI_MAX_SG_SEGMENTS	128
>>> +#define SCSI_MAX_SG_SEGMENTS	129
>> this one finally made the trick and it's booting fine now, without any 
>> crashes!
>
> Alas, this didn't help me here.  I did manage to capture the error messages 
> this time, and in the two machines I'm actively testing on, sata_mv is the 
> driver that's dying in both cases.  Machine A additionally has sata_nv, 
> which is working.  Machine B additionally has ata_piix, which is working.  
> So in both cases, its sata_mv that is throwing SError complaints:

Theory - ata_sg_is_last() isn't returning true for the last entry. Can
you double check that it correcly marks the last entry in mv_fill_sg()?
Alternatively, just try this patch.


diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4df8311..b858183 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1139,6 +1139,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 	struct mv_port_priv *pp = qc->ap->private_data;
 	struct scatterlist *sg;
 	struct mv_sg *mv_sg;
+	int end_marked = 0;
 
 	mv_sg = pp->sg_tbl;
 	ata_for_each_sg(sg, qc) {
@@ -1159,13 +1160,15 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 			sg_len -= len;
 			addr += len;
 
-			if (!sg_len && ata_sg_is_last(sg, qc))
+			if (!sg_len && ata_sg_is_last(sg, qc)) {
 				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
+				end_marked++;
+			}
 
 			mv_sg++;
 		}
-
 	}
+	BUG_ON(end_marked != 1);
 }
 
 static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)

-- 
Jens Axboe

