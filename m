Return-Path: <linux-kernel-owner+w=401wt.eu-S938306AbXHLWXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938306AbXHLWXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbXHLWXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:23:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:43752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbXHLWXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YjsD8tp0S2KOR0DGlPUGSfO3Ek71GCwFmpm44RM6LcCTgJsQTDrZBItQJx1mgPTghrd9afRncQV1gKeE3veq3+HVPG36I4V2sA424HmEqhNUGIveaKQfa1tK3d9cwHHKI7scejMhe/jh/adX9SCGt/pjOMXY5Jxto6pbA/SxLLw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/6][RESEND] Emulex FC HBA driver: fix overflow of statically allocated array
Date: Mon, 13 Aug 2007 00:21:06 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200708130016.11281.jesper.juhl@gmail.com>
In-Reply-To: <200708130016.11281.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130021.07068.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(previously send on 09-Aug-2007 20:47)

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
Acked-by: James Smart <james.smart@emulex.com>
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



