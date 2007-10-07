Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXJGOj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXJGOj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 10:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXJGOjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 10:39:18 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:62538 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXJGOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 10:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FnxEbVVSVE+oTpMrWdFj0PlXS/03Cabre2h33K/07lBd01M2OdFPEnAbALVih1IekJxmIaVwSGo3aQCq/gU8UxcHnFS/KUNJW4F33ClreYd0SyZL9z7goOtwnul8YNbyslYR9EecPG1DgoJ9B1ZnT8G9YAnlWPHr/SGj1rC/c0o=
Message-ID: <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com>
Date: Sun, 7 Oct 2007 16:39:15 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>, "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
	 <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
	 <20071004170536.GY19691@waste.org>
	 <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>
	 <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Jens Axboe, the author of what looks like the probable cause]
On 10/7/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> My sil24_fill_sg now looks like this:
> static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
>                                  struct sil24_sge *sge)
> {
>         struct scatterlist *sg;
>
>         ata_for_each_sg(sg, qc) {
>                 sge->addr = cpu_to_le64(sg_dma_address(sg));
>                 sge->cnt = cpu_to_le32(sg_dma_len(sg));
>                 if (ata_sg_is_last(sg, qc))
>                         sge->flags = cpu_to_le32(SGE_TRM);
>                 else
>                         sge->flags = 0;
>                 DPRINTK("flags,addr,cnt = 0x%x, 0x%X, 0x%X\n", sge->flags,
>                         sge->addr, sge->cnt);
>                 sge++;
>         }
> }
>
> Suspicious is, that *all* output from this DPRINTK shows flags as 0x0,
> so the last sg is never terminated (SGE_TRM is 1<<31)?
> But if that is the cause, how is this working at all? Or am I doing
> something stupid?

Looking closer at
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=ec6fdded4d76aa54aa57341e5dfdd61c507b1dcd
the change to libata.h seems bogus :

in ata_qc_first_sg:
old                                new
return qc->__sg                    return qc->__sg
qc->__sg - qc->__sg == 0           qc->n_iter=0
-> sg - qc->__sg corresponds to qc->n_iter

in ata_qc_next_sg:
sg++;                              sg_next(sg); qc->n_iter++;
sg - qc->__sg < qc->n_elem         qc->n_iter < qc->nelem
-> sg - qc->__sg corresponds to qc->n_iter

but in ata_sg_is_last:
(sg - qc->__sg) +1 == qc->n_elem   qc->n_iter == qc->n_elem
if sg - qc->__sg corresponds to qc->n_iter then shoudn't it be
qc->n_iter+1 == qc->n_elem?

That missing +1 would explain, why the SGE_TRM never gets set.

And it would fit the symptoms, that the boot would fail at random. If
the "correct" garbage was in place to where the sglist runs off it
hangs the drive.
And that would even fit the two different errors that I only got one time each:
* a completely illegal access (PCI master abort while fetching SGT)
* wrong alignment of the SGT (SGT no on qword boundary)
At that that times the garbage seemed to point invalid addresses.

But I'm still not understanding, how the kernel could only fail
sometimes at bootup, but after that working without any visible
errors? Is the sil-chip rather intelligent about detecting corrupted
sglists and silently ignoring them?

Torsten
