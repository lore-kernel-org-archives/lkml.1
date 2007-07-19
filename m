Return-Path: <linux-kernel-owner+w=401wt.eu-S939619AbXGSPvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939619AbXGSPvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939575AbXGSPus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:50:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:53467 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939590AbXGSPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Wiu9AW+Ron2gryp+31zu4m73bNb53bFNP0S3j5QcuYD/sbHaGVcazViR+xpn/VpkUNmHKk9N6zAdhjzjKL4cTBp1yuy2Qx9cFNx0VS0UcXBD42dv6Imc8/NgT+lN5Dm46rPDgQLpzsDNgyfNBXUdkjg+9cc7KK/IxfdWPKgwXos=
Message-ID: <469F884B.6010402@gmail.com>
Date: Thu, 19 Jul 2007 11:50:35 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: James.Smart@emulex.com
CC: James.Bottomley@SteelEye.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] [scsi] lpfc: potential leak in lpfc_sli_hbqbuf_fill_hbqs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If lpfc_hbq_alloc() fails, an hbq_buffer is leaked. Found by Coverity 
(1775).

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 drivers/scsi/lpfc/lpfc_sli.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f4d5a6b..fe16b0c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -622,8 +622,10 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 			return 1;
 		hbq_buffer->dbuf.virt = lpfc_hbq_alloc(phba, MEM_PRI,
 							&hbq_buffer->dbuf.phys);
-		if (hbq_buffer->dbuf.virt == NULL)
+		if (hbq_buffer->dbuf.virt == NULL) {
+			kfree(hbq_buffer);
 			return 1;
+		}
 		hbq_buffer->tag = (i | (hbqno << 16));
 		lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer);
 		lpfc_hbq_defs[hbqno]->buffer_count++;

