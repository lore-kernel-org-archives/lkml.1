Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYKZUqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYKZUqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYKZUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:45:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55720 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYKZUpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:45:55 -0500
Date: Wed, 26 Nov 2008 21:56:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 23/24] perfmon: kernel documentation
Message-ID: <20081126205619.GD6703@one.firstfloor.org>
References: <492d0c14.02225e0a.15ab.6f8e@mx.google.com> <20081126122107.GV6703@one.firstfloor.org> <7c86c4470811261021t5a7da650w95c30a71838172c4@mail.gmail.com> <20081126193429.GC6703@one.firstfloor.org> <7c86c4470811261224k20ae2554m32af5504488664cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811261224k20ae2554m32af5504488664cf@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 09:24:59PM +0100, stephane eranian wrote:
> 
> >> I have never played with that myself, even with regular file
> >> descriptors. But I can only
> >> assume passing a file descriptor increments its refcount. Thus you
> >> simply get another
> >> controlling process. There is enough context locking in place in the
> >> kernel to make this
> >> work.
> >
> > Ok as long as it isn't a root hole or similar.
> >
> I need to figure out how you actually pass a fd form one process to another.
> I seem to remember you need a pipe or socket + some ioctl().

Unix sockets and the SCM_RIGHTS auxilliary message. See man 7 unix  

> But then, there is one issue with RDPMC which is not clearly stated in the SDM
> if I recall. Take Core 2, counters are 40 bits, thus RDPMC returns 40-bit worth
> of data. But wrmsrl() can only set the bottom 32 bits. Bits 32-39 are
> sign extension

For this usecase wrmsrl is not really needed, it would be just a free 
running counter like the TSC.

> of bit 31. Thus, you may need some masking in case the counter is high.  On
> Intel processors, perfmon considers that all counters are actually 31-bit wide
> (bits 32 and up are always set) and they are all virtualized to 64-bit via the
> overflow interrupt. The issue with RDPMC vs. wrmsrl() is important in per-thread
> mode because on context switch we may have to restore the counter.

Ok is there a simple way currently to just enable the counter?

> If we all agree on this, I can have the kernel adjust the limit based
> on the number
> of registers. We would not necessarily need to expose that limit in
> /sys, if we assume
> that tools will never try to pass vector with more entries than there
> are registers. And if
> they do, the call will fail.

I would suggest to just hardcode PAGE_SIZE and only worry about
it again if really some driver exceeds it.

-Andi

-- 
ak@linux.intel.com
