Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbXBVAxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbXBVAxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXBVAxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:53:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:35367 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXBVAxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZY+m8dwsi3T9fCUL536d7VWlDoOH0QsabBR32A52fdVCY6y+A3Fpj3UbXM+3ImDGT/DLctX5TtUhB9lFSD5Vm1kjWcSlPzvw6diV2zvU8i28XC8rP5QDteAKdMIywJVT8DsqHH+pnLUFNRavB/VnAvd2riM7512AXNqkW4SRNmQ=
Message-ID: <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com>
Date: Wed, 21 Feb 2007 16:53:08 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070221225711.GB32031@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221225711.GB32031@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> threadlets, when they dont block, are just regular user-space function
> calls - so no need to schedule or throttle them. [*]

Right.  That's a great design feature.

> threadlets, when they block, are regular kernel threads, so the regular
> O(1) scheduler takes care of them. If MMU trashing is of any concern
> then syslets should be used to implement the most performance-critical
> events: under Linux a kernel thread that does not exit out to user-space
> does not do any TLB switching at all. (even if there are multiple
> processes active and their syslets intermix)

As far as I am concerned syslets by themselves are a dead letter,
because you can't do any of the things that potential application
coders need to do with them.  As for threadlets, making them kernel
threads is not such a good design feature, O(1) scheduler or not.  You
take the full hit of kernel task creation, on the spot, for every
threadlet that blocks.  You don't fence off the threadlet from any of
the stuff that it ought to be fenced off from for thread-safety
reasons, so you don't have much choice but to create a new TLS arena
for it (which you need anyway for errno), so they have horrible MMU
and memory overhead.  You can't dispatch them inexpensively, while the
data delivered by a softirq is still hot in cache, to traverse 1-3
lines of userspace code and make the next syscall.  So they're just
not usable for any of the things that a real AIO application actually
does.

> throttling of outstanding async contexts is most easily done by
> user-space - you can see an example in threadlet-test.c, but there's
> also fio/engines/syslet-rw.c. v2 had a kernel-space throttling mechanism
> as well, i'll probably reintroduce that in later versions.

You're telling me that scheduling parallel I/O is the kernel's job but
throttling it is userspace's job?

> [*] although certain more advanced scheduling tactics like the detection
>     of frequently executed threadlet functions and their pushing out to
>     separate contexts is possible too - but this is an optional add-on
>     and for later.

You won't be able to do it later if you don't design for it now.
Don't reinvent the square wheel -- there's a model to follow that was
so successful that it has killed all alternate models in its sphere.
Namely, IEEE 754.  But please try not to make pipeline flushes suck as
much as they did on the i860.

Cheers,
- Michael
