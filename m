Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZAaNsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZAaNsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 08:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAaNso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 08:48:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:39479 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZAaNso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 08:48:44 -0500
Subject: Re: Out of memory error
From: Peter Zijlstra <peterz@infradead.org>
To: Cliffe <cliffe@ii.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49846071.1020809@ii.net>
References: <m2eiz06iav.fsf@ssh.synack.fr>
	 <200901291025.36076.paul.moore@hp.com>
	 <1233267347.13812.22.camel@sp-laptop3.sp-local>
	 <200901291738.36148.paul.moore@hp.com>
	 <1233275267.13812.31.camel@sp-laptop3.sp-local>
	 <m2ocxpzhs2.fsf@ssh.synack.fr>  <49844F4D.3010006@ii.net>
	 <1233406730.4787.3.camel@laptop>  <49846071.1020809@ii.net>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 14:48:40 +0100
Message-Id: <1233409720.4787.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 22:30 +0800, Cliffe wrote:

> > Its simply a case of you using kmalloc(GFP_ATOMIC) and that's failing.
> >   
> 
> So it has nothing to do with stack size because we are talking heap?
> What could be causing the problem?

Right, heap. The thing is, Linux has a greedy memory usage, and tries to
keep as much as possible in memory, this means that we're basically in a
constant state of low memory.

Regular allocations (GFP_KERNEL) can sleep, and can therefore reclaim
memory (write out stuff dirty to disk, swap a little, etc..).

Your allocation (GFP_ATOMIC) isn't allowed to sleep, and can therefore
not reclaim memory -- if it really hits rock bottom, not uncommon, it
just fails to provide memory.

Any code using GFP_ATOMIC (or for that matter, any kernel allocation,
GFP_KERNEL can fail too, just not as easy) must be able to deal with
allocation failures.

How to do that is very domain specific.

> How limited is the stack?

Depends on the arch and build details, 4k is a reasonable assumption.

> > Furthermore, it appears to me you're not using frame pointers for your
> > kernel builds, please ammend that, it gives far more readable output.
> >   
> 
> I'll look into that. Is that a kernel compile config option?

CONFIG_FRAME_POINTER=y

