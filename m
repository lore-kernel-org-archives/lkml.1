Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbXHJBDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbXHJBDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXHJBDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:03:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:4638 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbXHJBDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=es0BcMQNIM1RPQWqL9kTtt0sAoSDaf0tbwuU1JiNQ2Px5LGvxTjgYL5jG+TeRM+9ZE1vMTWdrQOKfvkPkh7eNaYaf+MBaWN8crqxicuF9287h9vjF2pZccfGvm/XZ5sdPOogwrsotD/fKMyDa4DyD/Xk+pcnwRSrAsImUA7OCIo=
Message-ID: <a56dfcf00708091803o5d66456s355641d06b362591@mail.gmail.com>
Date: Fri, 10 Aug 2007 01:03:22 +0000
From: "Dan Merillat" <dan.merillat@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Andrea Arcangeli" <andrea@suse.de>, "Eric Sandeen" <sandeen@sandeen.net>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Matt Mackall" <mpm@selenic.com>, "Rene Herman" <rene.herman@gmail.com>,
       "Ray Lee" <ray-lk@madrabbit.org>, "Bodo Eggert" <7eggert@gmx.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "Denis Vlasenko" <vda.linux@googlemail.com>
In-Reply-To: <20070801164408.1d5ed1c1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719013955.1bedc423@the-village.bc.nu>
	 <20070719112436.GG29728@v2.random>
	 <20070719124419.48c3d610@the-village.bc.nu>
	 <46A9ECD5.3050801@sandeen.net>
	 <20070727183807.2d7dbe7b@the-village.bc.nu>
	 <a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
	 <46B003A3.1090507@sandeen.net>
	 <a56dfcf00708010111n4b862a11wf91fe9677ee46143@mail.gmail.com>
	 <20070801133358.GD6910@v2.random>
	 <20070801164408.1d5ed1c1@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 1 Aug 2007 15:33:58 +0200
> Andrea Arcangeli <andrea@suse.de> wrote:
> > Tweaking kernel ptes is prohibitive during clone() because that's
> > kernel memory and it would require a flush tlb all with IPIs that
> > won't scale (IPIs are really the blocker)
>
> Agreed - except when doing debug work then its an acceptable cost. You
> still have to sort the debug side out because you are going to fault the
> kernel stack which will probably then cause a triple fault and reboot on
> the spot.

I was assuming debugging work, yes.  I was also thinking it wouldn't
be done at clone() time, but mapped (on a single CPU) at the time of a
context switch.  It would eliminate IPI, but would probably make the
rest of the TLB handling much too ugly to contemplate.    As an
alternative, could the TLB flush and associated IPI be deferred until
the process migrates?   First migration would trigger flush/IPI,
further migration would be as now, no?   I'd happily run it with
various dm/md layers underneath

On 8/1/07, Denis Vlasenko <vda.linux@googlemail.com> wrote:
> Hmm, neat. Why do you need to _allocate second page_ at all?
> Just mark it "not present"...

Because the kernel mapping covers all physical memory contiguously, so
if the page isn't allocated, it could be used by a kernel data
structure you need to access.  Same reason the kernel stack has to be
contiguous pages.   Well, for non-highmem at least.  Either way, you
don't want to mark an in-use page as inaccessable, you never know
what's under there.
