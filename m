Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbXJKIhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbXJKIhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXJKIgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:36:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:28950 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbXJKIgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Pqj8WhtB7r7SyeAzZi5RwEStprtkRBBM6a3y6JdYxGbOv+BRyRju16jSAZF8tefB9dDRvaXuxHwi5R6py2AffqNRTD1nCtvYR9x62JO5qVbY5bGOi6uG+ZYqai4UzveHyRZLfUP+Wni0Rv7o0AgE1J+DMD95lMD5Qgf4hELdxAg=
Message-ID: <470DE09D.7080508@gmail.com>
Date: Thu, 11 Oct 2007 17:36:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com> <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com> <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com> <20071003163804.GR19691@waste.org> <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com> <20071004170536.GY19691@waste.org> <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com> <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com> <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com> <470D97BD.4020300@gmail.com> <20071011082604.GB5142@kernel.dk>
In-Reply-To: <20071011082604.GB5142@kernel.dk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> This is the old ata_sg_is_last:
> 
> static inline int
> ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
> {
>         if (sg == &qc->pad_sgent)
>                 return 1;
>         if (qc->pad_len)
>                 return 0;
>         if (((sg - qc->__sg) + 1) == qc->n_elem)
>                 return 1;
>         return 0;
> }
> 
> and the new one:
> 
> static inline int
> ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
> {
>         if (sg == &qc->pad_sgent)
>                 return 1;
>         if (qc->pad_len)
>                 return 0;
>         if (qc->n_iter == qc->n_elem)
>                 return 1; 
>         return 0;
> }
> 
> ->n_iter is how ata_qc_next_sg() walks over the sglist, I don't
> understand your reference to why depending on that during iteration
> would be bad?

Because that makes ata_sg iterator macros have hidden side effects
(nothing in the interface suggests it can't be nested and when somebody
actually nests it, finding what went wrong can be pretty difficult).  I
think it would be better to have explicit ata_sg_iter passed around if
sg itself isn't enough to walk the sg list.

> So we could add a test for sg_last() there, but that would turn sg table
> iteration into an O(N^2) operation for those drivers that use
> ata_sg_is_last() with chained sg tables. I'd much rather just get rid of
> ata_sg_is_last(), it's only used to mark end-of-table entries for
> hardware. That logic can be performed cheaper.

Yeap, it can be removed but having "is this the last one?" test is just
nicer to low level drivers.  With ata_sg_iter, I think we can do it in
O(N) by looking up and caching the next entry.

Thanks.

-- 
tejun
