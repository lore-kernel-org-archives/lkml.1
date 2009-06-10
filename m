Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZFJEDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZFJEDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 00:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZFJEDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 00:03:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42782 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZFJEDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 00:03:07 -0400
Date: Wed, 10 Jun 2009 14:02:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kashyap@vger.kernel.org, Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with the scsi tree
Message-Id: <20090610140234.2d008ed1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/message/fusion/mptsas.c between commits
14d0f0b063f5363984dd305a792854f9c23e9e97 ("[SCSI] mpt fusion: Fixing 1078
data corruption issue for 36GB memory region") and
2f187862e579f1f5e883188cab6bd867cb60387f ("[SCSI] mpt fusion: Code
Cleanup patch") from the scsi tree and commit
b0790410300abaaf4f25f702803beff701baebf1 ("block: cleanup rq->data_len
usages") from the block tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/message/fusion/mptsas.c
index 14c490a,79f5433..0000000
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@@ -2177,32 -1319,26 +2177,32 @@@ static int mptsas_smp_handler(struct Sc
  	/* request */
  	flagsLength = (MPI_SGE_FLAGS_SIMPLE_ELEMENT |
  		       MPI_SGE_FLAGS_END_OF_BUFFER |
 -		       MPI_SGE_FLAGS_DIRECTION |
 -		       mpt_addr_size()) << MPI_SGE_FLAGS_SHIFT;
 +		       MPI_SGE_FLAGS_DIRECTION)
 +		       << MPI_SGE_FLAGS_SHIFT;
- 	flagsLength |= (req->data_len - 4);
+ 	flagsLength |= (blk_rq_bytes(req) - 4);
  
  	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
- 				      req->data_len, PCI_DMA_BIDIRECTIONAL);
+ 				      blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
  	if (!dma_addr_out)
  		goto put_mf;
 -	mpt_add_sge(psge, flagsLength, dma_addr_out);
 -	psge += (sizeof(u32) + sizeof(dma_addr_t));
 +	ioc->add_sge(psge, flagsLength, dma_addr_out);
 +	psge += ioc->SGE_size;
  
  	/* response */
 -	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
 +	flagsLength = MPI_SGE_FLAGS_SIMPLE_ELEMENT |
 +		MPI_SGE_FLAGS_SYSTEM_ADDRESS |
 +		MPI_SGE_FLAGS_IOC_TO_HOST |
 +		MPI_SGE_FLAGS_END_OF_BUFFER;
 +
 +	flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
- 	flagsLength |= rsp->data_len + 4;
+ 	flagsLength |= blk_rq_bytes(rsp) + 4;
  	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
- 				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
+ 				      blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
  	if (!dma_addr_in)
  		goto unmap;
 -	mpt_add_sge(psge, flagsLength, dma_addr_in);
 +	ioc->add_sge(psge, flagsLength, dma_addr_in);
  
 +	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
  	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
  
  	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
@@@ -2221,11 -1357,10 +2221,11 @@@
  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
  		memcpy(req->sense, smprep, sizeof(*smprep));
  		req->sense_len = sizeof(*smprep);
- 		req->data_len = 0;
- 		rsp->data_len -= smprep->ResponseDataLength;
+ 		req->resid_len = 0;
+ 		rsp->resid_len -= smprep->ResponseDataLength;
  	} else {
 -		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
 +		printk(MYIOC_s_ERR_FMT
 +		    "%s: smp passthru reply failed to be returned\n",
  		    ioc->name, __func__);
  		ret = -ENXIO;
  	}
