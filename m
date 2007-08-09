Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbXHIStm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbXHIStm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXHIStd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:49:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:10768 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbXHISta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JeEvnSB2wK/8CbolTZftjHRxE9o+dAaRF6PysSNyx1rZ6viAvWYkMLrKQsqS7lWCuotOENxVg1epeoZhDGHbzORCtSnz4fr+/OoNDa0cCNNsgqUX0tM4hv0dVR2HV9b8jmMT9LWHWOj+uZAdZpp41KaZ/GgOK/NwWCrZiHCdOaY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: James Smart <james.smart@emulex.com>
Subject: [PATCH] Emulex FC HBA driver: fix overflow of statically allocated array
Date: Thu, 9 Aug 2007 20:47:15 +0200
User-Agent: KMail/1.9.7
Cc: linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708092047.16101.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Coverity checker noticed that we may overrun a statically allocated 
array in drivers/scsi/lpfc/lpfc_sli.c::lpfc_sli_hbqbuf_find().

The case is this; In 'struct lpfc_hba' we have 

	#define LPFC_MAX_HBQS  4
	...
	struct lpfc_hba {
		...
		struct hbq_s hbqs[LPFC_MAX_HBQS];
		...
	};

But then in lpfc_sli_hbqbuf_find() we have this code 

	hbqno = tag >> 16;
	if (hbqno > LPFC_MAX_HBQS)
		return NULL;

if 'hbqno' ends up as exactely 4, then we won't return, and then this

	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {

will cause an overflow of the statically allocated array at index 4, 
since the valid indices are only 0-3. 

I propose this patch, that simply changes the 'hbqno > LPFC_MAX_HBQS' 
into 'hbqno >= LPFC_MAX_HBQS' as a possible fix.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ce5ff2b..e5337ad 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -675,7 +675,7 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 	uint32_t hbqno;
 
 	hbqno = tag >> 16;
-	if (hbqno > LPFC_MAX_HBQS)
+	if (hbqno >= LPFC_MAX_HBQS)
 		return NULL;
 
 	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {



