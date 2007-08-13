Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbXHMOEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbXHMOEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765203AbXHMK45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:56:57 -0400
Received: from emulex.emulex.com ([138.239.112.1]:47323 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761371AbXHMK4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:56:52 -0400
Message-ID: <46C038E3.5090204@emulex.com>
Date: Mon, 13 Aug 2007 06:56:35 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 4/6][RESEND] Emulex FC HBA driver: fix overflow of statically
 allocated array
References: <200708130016.11281.jesper.juhl@gmail.com> <200708130021.07068.jesper.juhl@gmail.com>
In-Reply-To: <200708130021.07068.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2007 10:56:34.0606 (UTC) FILETIME=[9D3BD4E0:01C7DD98]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NACK

The fix is contained in our 8.2.2 sources recently posted and pushed by James
as part of his last scsi fixes.

-- james s

Jesper Juhl wrote:
> (previously send on 09-Aug-2007 20:47)
> 
> Hi,
> 
> The Coverity checker noticed that we may overrun a statically allocated 
> array in drivers/scsi/lpfc/lpfc_sli.c::lpfc_sli_hbqbuf_find().
> 
> The case is this; In 'struct lpfc_hba' we have 
> 
> 	#define LPFC_MAX_HBQS  4
> 	...
> 	struct lpfc_hba {
> 		...
> 		struct hbq_s hbqs[LPFC_MAX_HBQS];
> 		...
> 	};
> 
> But then in lpfc_sli_hbqbuf_find() we have this code 
> 
> 	hbqno = tag >> 16;
> 	if (hbqno > LPFC_MAX_HBQS)
> 		return NULL;
> 
> if 'hbqno' ends up as exactely 4, then we won't return, and then this
> 
> 	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {
> 
> will cause an overflow of the statically allocated array at index 4, 
> since the valid indices are only 0-3. 
> 
> I propose this patch, that simply changes the 'hbqno > LPFC_MAX_HBQS' 
> into 'hbqno >= LPFC_MAX_HBQS' as a possible fix.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> Acked-by: James Smart <james.smart@emulex.com>
> ---
> 
>  drivers/scsi/lpfc/lpfc_sli.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index ce5ff2b..e5337ad 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -675,7 +675,7 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
>  	uint32_t hbqno;
>  
>  	hbqno = tag >> 16;
> -	if (hbqno > LPFC_MAX_HBQS)
> +	if (hbqno >= LPFC_MAX_HBQS)
>  		return NULL;
>  
>  	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {
> 
> 
> 
> 
