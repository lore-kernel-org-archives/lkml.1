Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZFKGno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZFKGno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZFKGng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:43:36 -0400
Received: from exprod7og127.obsmtp.com ([64.18.2.210]:42841 "EHLO
	exprod7og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZFKGnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:43:35 -0400
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 02:42:32 EDT
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jens Axboe <jens.axboe@oracle.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kashyap@mail2.lsil.com" <Kashyap@mail2.lsil.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Tejun Heo <tj@kernel.org>
Date: Thu, 11 Jun 2009 11:53:21 +0530
Subject: RE: linux-next: manual merge of the block tree with the scsi tree
Thread-Topic: linux-next: manual merge of the block tree with the scsi tree
Thread-Index: AcnpgH1Dox6Mosk8QyW1dJEx7lZIGAA1dKfA
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A2C14CA@inbmail01.lsi.com>
References: <20090610140234.2d008ed1.sfr@canb.auug.org.au>
In-Reply-To: <20090610140234.2d008ed1.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

I have verified those conflict fixed by Stephen R. It is just context changes. OK to patch it if it is not patched to mainline.

- Kashyap

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Wednesday, June 10, 2009 9:33 AM
To: Jens Axboe
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Kashyap@mail2.lsil.com; Desai, Kashyap; James Bottomley; Tejun Heo
Subject: linux-next: manual merge of the block tree with the scsi tree

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
