Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbXGXNcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbXGXNcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbXGXNb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:31:57 -0400
Received: from emulex.emulex.com ([138.239.112.1]:55209 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbXGXNb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:31:56 -0400
Message-ID: <46A5FD7C.6050104@emulex.com>
Date: Tue, 24 Jul 2007 09:24:12 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.23 regression: lpfc_sli.c: off-by-10
References: <20070723003215.GQ26212@stusta.de>
In-Reply-To: <20070723003215.GQ26212@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2007 13:24:14.0113 (UTC) FILETIME=[EDA65110:01C7CDF5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian,

Thanks.

Syntax-wise, it is incorrect. However there's no risk.  The datastructure
its indexing into is a union, and its size is sufficient for the index.
The union supports old and new firmware interfaces. We mistakenly used the
array for the old interface and should have used the (larger) array for
the newer interface.

We're posting a set of fixes later this week and will include the fix for
this.

-- james s


Adrian Bunk wrote:
> The Coverity checker spotted the following off-by-10
> in drivers/scsi/lpfc/lpfc_sli.c:
> 
> 
> <--  snip  -->
> 
> ...
> static int
> lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>                             struct lpfc_iocbq *saveq)
> {
> ...
>                         saveq->context3 = lpfc_sli_replace_hbqbuff(phba,
>                                                 irsp->un.ulpWord[15]);
> ...
> 
> <--  snip  -->
> 
> 
> due to the following code in drivers/scsi/lpfc/lpfc_hw.h:
> 
> 
> <--  snip  -->
> 
> ...
> #define IOCB_WORD_SZ    8
> ...
> typedef struct _IOCB {  /* IOCB structure */
> ...
>                 uint32_t ulpWord[IOCB_WORD_SZ - 2];     /* generic 6 'words' */
> ...
> 
> <--  snip  -->
> 
> 
> cu
> Adrian
> 
