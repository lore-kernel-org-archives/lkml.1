Return-Path: <linux-kernel-owner+w=401wt.eu-S1763560AbYCUXEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763560AbYCUXEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763807AbYCUWvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59379 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763130AbYCUWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:06 -0400
Message-Id: <20080321224419.305083831@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Pagano <mpagano@gentoo.org>, kernel@gentoo.org, dsd@gentoo.org,
       Nick Cheng <nick.cheng@areca.com.tw>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 46/76] arcmsr: fix IRQs disabled warning spew
Content-Disposition: inline; filename=arcmsr-fix-irqs-disabled-warning-spew.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mike Pagano <mpagano@gentoo.org>

As of 2.6.24, running the archttp passthrough daemon with the arcmsr
driver produces an endless spew of dma_free_coherent warnings:

	WARNING: at arch/x86/kernel/pci-dma_64.c:169 dma_free_coherent()

It turns out that coherent memory is not needed, so commit 76d78300 by
Nick Cheng <nick.cheng@areca.com.tw> switched it to kmalloc (as well as
making a lot of other changes which have not been included here).

James Bottomley pointed out that the new kmalloc usage was also wrong,
I corrected this in commit 69e562c2.

This patch combines both of the above for the purpose of fixing 2.6.24.
details in http://bugs.gentoo.org/208493.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Cc: Nick Cheng <nick.cheng@areca.com.tw>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/arcmsr/arcmsr_hba.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1380,17 +1380,16 @@ static int arcmsr_iop_message_xfer(struc
 	switch(controlcode) {
 
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {
-		unsigned long *ver_addr;
-		dma_addr_t buf_handle;
+		unsigned char *ver_addr;
 		uint8_t *pQbuffer, *ptmpQbuffer;
 		int32_t allxfer_len = 0;
 
-		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
+		ver_addr = kmalloc(1032, GFP_ATOMIC);
 		if (!ver_addr) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
-		ptmpQbuffer = (uint8_t *) ver_addr;
+		ptmpQbuffer = ver_addr;
 		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
 			&& (allxfer_len < 1031)) {
 			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
@@ -1419,25 +1418,24 @@ static int arcmsr_iop_message_xfer(struc
 			}
 			arcmsr_iop_message_read(acb);
 		}
-		memcpy(pcmdmessagefld->messagedatabuffer, (uint8_t *)ver_addr, allxfer_len);
+		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);
 		pcmdmessagefld->cmdmessage.Length = allxfer_len;
 		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
-		pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
+		kfree(ver_addr);
 		}
 		break;
 
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
-		unsigned long *ver_addr;
-		dma_addr_t buf_handle;
+		unsigned char *ver_addr;
 		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
 
-		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
+		ver_addr = kmalloc(1032, GFP_ATOMIC);
 		if (!ver_addr) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
-		ptmpuserbuffer = (uint8_t *)ver_addr;
+		ptmpuserbuffer = ver_addr;
 		user_len = pcmdmessagefld->cmdmessage.Length;
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
 		wqbuf_lastindex = acb->wqbuf_lastindex;
@@ -1483,7 +1481,7 @@ static int arcmsr_iop_message_xfer(struc
 				retvalue = ARCMSR_MESSAGE_FAIL;
 			}
 			}
-			pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
+			kfree(ver_addr);
 		}
 		break;
 

-- 
