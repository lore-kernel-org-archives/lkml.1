Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbXJKD0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbXJKD0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 23:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbXJKD0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 23:26:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:17082 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbXJKDZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 23:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tDE3B0uCCRIh5yQ6u9Xg2OhAwOaVBBe1GJmzFxf9poLrPBUpx2vdd1/kInXgCbgB2J6z1fHTEG1H+sRqDssmgj6F87eWXqr2MYr+5oq4snvHbSEEj7dZUPoKRtSzCi52PuynmWmMw3oysEDRkhdYs8P3V2ykU0+lZHQrq0XAcGY=
Message-ID: <470D97BD.4020300@gmail.com>
Date: Thu, 11 Oct 2007 12:25:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>	 <20071003163804.GR19691@waste.org>	 <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>	 <20071004170536.GY19691@waste.org>	 <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>	 <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com> <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com>
In-Reply-To: <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> Looking closer at
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=ec6fdded4d76aa54aa57341e5dfdd61c507b1dcd
> the change to libata.h seems bogus :
> 
> in ata_qc_first_sg:
> old                                new
> return qc->__sg                    return qc->__sg
> qc->__sg - qc->__sg == 0           qc->n_iter=0
> -> sg - qc->__sg corresponds to qc->n_iter
> 
> in ata_qc_next_sg:
> sg++;                              sg_next(sg); qc->n_iter++;
> sg - qc->__sg < qc->n_elem         qc->n_iter < qc->nelem
> -> sg - qc->__sg corresponds to qc->n_iter
> 
> but in ata_sg_is_last:
> (sg - qc->__sg) +1 == qc->n_elem   qc->n_iter == qc->n_elem
> if sg - qc->__sg corresponds to qc->n_iter then shoudn't it be
> qc->n_iter+1 == qc->n_elem?
> 
> That missing +1 would explain, why the SGE_TRM never gets set.

Thanks a lot for tracking this down.  Does changing the above code fix
your problem?

Jens, Torsten's analysis looks correct && depending on qc state (n_iter)
during iteration doesn't look like a good idea.  Those iterators are not
supposed to have side effects.  Would it be difficult to implement
sg_last() test?

> And it would fit the symptoms, that the boot would fail at random. If
> the "correct" garbage was in place to where the sglist runs off it
> hangs the drive.
> And that would even fit the two different errors that I only got one time each:
> * a completely illegal access (PCI master abort while fetching SGT)
> * wrong alignment of the SGT (SGT no on qword boundary)
> At that that times the garbage seemed to point invalid addresses.
> 
> But I'm still not understanding, how the kernel could only fail
> sometimes at bootup, but after that working without any visible
> errors? Is the sil-chip rather intelligent about detecting corrupted
> sglists and silently ignoring them?

I have no idea why it fails only sometimes.

-- 
tejun
