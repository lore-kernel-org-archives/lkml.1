Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbXJCBlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbXJCBlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbXJCBlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:41:23 -0400
Received: from lixom.net ([66.141.50.11]:49636 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXJCBlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:41:22 -0400
Date: Tue, 2 Oct 2007 20:45:27 -0500
From: Olof Johansson <olof@lixom.net>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libata: fix for sata_mv >64KB DMA segments
Message-ID: <20071003014527.GA6316@lixom.net>
References: <20071001220439.GA15332@lixom.net> <470176B8.1000109@pobox.com> <20071002023000.GA19286@lixom.net> <4702D2DE.1050504@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4702D2DE.1050504@pobox.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug in sata_mv for cases where the IOMMU layer has merged SG entries
to larger than 64KB. They need to be split up before being sent to
the driver.

Just for simplicity's sake, split up at 64K boundary instead of 64K size,
since that's what the common code does anyway.

Signed-off-by: Olof Johansson <olof@lixom.net>


---

On Tue, Oct 02, 2007 at 07:23:10PM -0400, Jeff Garzik wrote:
> Olof Johansson wrote:
>> On Mon, Oct 01, 2007 at 06:37:44PM -0400, Jeff Garzik wrote:
>> Looks like it's caused by enabling vmerge (which tends to be on for the
>> common PPC defconfigs). If I disable it, things look OK.
>> Perhaps the Marvell controller doesn't like requests larger than 64K,
>> or wrapping some boundary. Do you have access to erratas/docs?
>> I have verified it on a powermac now as well (had a quick scare that it
>> might have been some problem with the PA Semi IOMMU, but no).
>
> FWIW:  I just tried the 6042 on my AMD64 platform with iommu=force, and was 
> unable to reproduce any trouble.
>
> You could try changing MV_DMA_BOUNDARY to 0xffffU and see what happens.

As per discussion on IRC, it was really caused by mv_fill_sg() not
handing SG entries larger than 64K properly. Below patch fixes it to
behave like ata_fill_sg() instead.

Works OK here after some light testing (restoring my corrupted root
filesystem and running a few fscks on it, among other things).


Thanks,

Olof


diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 11bf6c7..1a82e22 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1139,15 +1139,27 @@ static unsigned int mv_fill_sg(struct ata_queued_cmd *qc)
 		dma_addr_t addr = sg_dma_address(sg);
 		u32 sg_len = sg_dma_len(sg);
 
-		mv_sg->addr = cpu_to_le32(addr & 0xffffffff);
-		mv_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
-		mv_sg->flags_size = cpu_to_le32(sg_len & 0xffff);
+		while (sg_len) {
+			u32 offset = addr & 0xffff;
+			u32 len = sg_len;
 
-		if (ata_sg_is_last(sg, qc))
-			mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
+			if ((offset + sg_len > 0x10000))
+				len = 0x10000 - offset;
+
+			mv_sg->addr = cpu_to_le32(addr & 0xffffffff);
+			mv_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
+			mv_sg->flags_size = cpu_to_le32(len);
+
+			sg_len -= len;
+			addr += len;
+
+			if (!sg_len && ata_sg_is_last(sg, qc))
+				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
+
+			mv_sg++;
+			n_sg++;
+		}
 
-		mv_sg++;
-		n_sg++;
 	}
 
 	return n_sg;
