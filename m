Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbYDOMvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbYDOMvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYDOMvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:51:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31252 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761452AbYDOMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:51:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qYqnyfgdHMk4WFKY6GiqLb59cLwUqFFed4qN+0DUnEOHBaxAshfTmCTe0CeqO5KKK
	ieUVmAMB+xSZos1EYc1Pw==
Message-ID: <d43160c70804150547v7896e813t4bb1bafd932c30ec@mail.gmail.com>
Date: Tue, 15 Apr 2008 08:47:37 -0400
From: "Ross Biro" <rossb@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] MM: Make page tables relocatable -- conditional flush (rc9)
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080414155702.ca7eb622.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414163933.A9628DCA48@localhost>
	 <20080414155702.ca7eb622.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 6:57 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  This patchset doesn't apply to the 2.6.26 queue because of the ongoing x86
>  shell game: the arch/x86/kernel/smp_??.c files were consolidated.

It's probably best to just wait until the smoke clears on 2.6.26 then.
 I'll add some comments, however I usually get in trouble for adding
too verbose comments, so I've learned to go the other way.  If you
prefer comments though, I'll add them.

>  - Must ->page_table_relocation_lock be a semaphore?  mutexes are
>   preferred.

Not any more.  It used to require a semaphore, but I can switch it
back to a mutex now.  I can even replace the mutex with an atomic
inc/dec which might be even better since it will work at interrupt
time as well.

>  - The patch adds a number of largeish inlined functions.  There's rarely
>   a need for this, and it can lead to large icache footprint which will, we
>   expect, produce slower code.

If these are the ones I'm thinking of, they are in the fast path on
page faults.  So they should be inlined.  However, I could easily
change it to a small macro or inline function and a regular function
call that would rarely be taken.  This should be a win from the icache
point of view and only a loss in a case we really don't care much
about.

>  - The patch adds a lot of macros which look like they could have been
>   implemented as inlines.  Inlines are preferred, please.  They look nicer,
>   they provide typechecking, they avoid accidental
>   multiple-reference-to-arguments bugs and they help to avoid
>   unused-variable warnings.

Here I disagree.  The only added function-like #define's I see are
either just aliasing functions, or the case when any function that
does nothing.  I guess the later could be replaced by inlines to avoid
warnings.

>  - Doing PAGE_SIZE memcpy under spin_lock_irqsave() might get a bit
>   expensive from an interrupt-latency POV.  It could (I think?) result in
>   large periods of time where interrupts are almost always disabled, which
>   might disrupt some device drivers.

Here I'm just being stupid.  There is no reason to have interrupts
disabled at this point.

>
>  - Why is this code doing spin_lock_irqsave() on page_table_lock?  The
>   rest of mm/ doesn't disable IRQs for that lock.  This implies that

Laziness.  I didn't feel like figuring this out if the irqsave was
necessary when I started, and forgot to go back and fix it later.
There is no reason.


>  - I haven't checked, but if the code is taking KM_USER0 from interrupt
>   context then that would be a bug.  Switching to KM_IRQ0 would fix that.

KM_USER0 is currently correct.  For memory hotplug, we may need to
change this in the future.


     Ross
