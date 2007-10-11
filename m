Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbXJKFzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbXJKFzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbXJKFy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:54:56 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:18473 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXJKFyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G5qLmzsInZhFfNRyS7/BN2JcWYRTpo1W1f1oi6n9DuZmju1hKQrRswr8W2Lu98BqjmptS3UVbLL/Z5s43bHoFxUqGmZO0ca3ardJnCyGzLCe58d4EGnKacrmmtROF0sxV6Xk0nbLg64b17TdXyB+yF4HdSfsEYBHA4n8JNnTQEY=
Message-ID: <64bb37e0710102254n60e22338t4baf75a47b93ac14@mail.gmail.com>
Date: Thu, 11 Oct 2007 07:54:53 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <470D97BD.4020300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
	 <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
	 <20071004170536.GY19691@waste.org>
	 <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>
	 <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com>
	 <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com>
	 <470D97BD.4020300@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Tejun Heo <htejun@gmail.com> wrote:
> Torsten Kaiser wrote:
> > Looking closer at
> > http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=ec6fdded4d76aa54aa57341e5dfdd61c507b1dcd
> > the change to libata.h seems bogus :
> >
> > in ata_qc_first_sg:
> > old                                new
> > return qc->__sg                    return qc->__sg
> > qc->__sg - qc->__sg == 0           qc->n_iter=0
> > -> sg - qc->__sg corresponds to qc->n_iter
> >
> > in ata_qc_next_sg:
> > sg++;                              sg_next(sg); qc->n_iter++;
> > sg - qc->__sg < qc->n_elem         qc->n_iter < qc->nelem
> > -> sg - qc->__sg corresponds to qc->n_iter
> >
> > but in ata_sg_is_last:
> > (sg - qc->__sg) +1 == qc->n_elem   qc->n_iter == qc->n_elem
> > if sg - qc->__sg corresponds to qc->n_iter then shoudn't it be
> > qc->n_iter+1 == qc->n_elem?
> >
> > That missing +1 would explain, why the SGE_TRM never gets set.
>
> Thanks a lot for tracking this down.  Does changing the above code fix
> your problem?

I did not try it.
I'm not an libata expert and while this change looks suspicios, I
can't be 100% sure if that change was intended.
And I did not want to experiment this deep in the code and risk
corrupting the hole drive.

> Jens, Torsten's analysis looks correct && depending on qc state (n_iter)
> during iteration doesn't look like a good idea.  Those iterators are not
> supposed to have side effects.  Would it be difficult to implement
> sg_last() test?
>
> > And it would fit the symptoms, that the boot would fail at random. If
> > the "correct" garbage was in place to where the sglist runs off it
> > hangs the drive.
> > And that would even fit the two different errors that I only got one time each:
> > * a completely illegal access (PCI master abort while fetching SGT)
> > * wrong alignment of the SGT (SGT no on qword boundary)
> > At that that times the garbage seemed to point invalid addresses.
> >
> > But I'm still not understanding, how the kernel could only fail
> > sometimes at bootup, but after that working without any visible
> > errors? Is the sil-chip rather intelligent about detecting corrupted
> > sglists and silently ignoring them?
>
> I have no idea why it fails only sometimes.

And that is, why I'm so unsure.
The error looks to serious to only cause random failures on one of two
drives on bootup.
I never had trouble with the remaining drive on the SiI-chip or both
drives if one got killed during booting.

I'm guessing that leaving the computer powered down long enough fills
the RAM with a special pattern that really hangs the drive, while
normaly it would just reject the invalid data. (I have ECC-RAM, does
this matter?)

Another guess might be that most of the time the Sil-chip correctly
terminates after the transfer-length is reached, even if SGE_TRM is
missing...

Torsten
