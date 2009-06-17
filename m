Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbZFQHou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbZFQHou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZFQHom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:44:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:34469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZFQHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:44:41 -0400
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090616081348.GC16229@elte.hu>
References: <1245080486.6800.561.camel@laptop>
	 <1245089065.13761.19316.camel@twins> <20090615181555.GA11248@elte.hu>
	 <1245089943.13761.19334.camel@twins> <20090615182549.GD11248@elte.hu>
	 <1245090608.13761.19349.camel@twins> <20090615184217.GG11248@elte.hu>
	 <1245091674.6741.180.camel@laptop> <20090615185259.GK11248@elte.hu>
	 <1245092433.6741.201.camel@laptop>  <20090616081348.GC16229@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Jun 2009 09:44:35 +0200
Message-Id: <1245224675.13761.21598.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 10:13 +0200, Ingo Molnar wrote:

> > By removing the types it becomes very difficult to verify the max 
> > depth. I really don't like removing them.
> 
> The fact that it implies an atomic section pretty much limits its 
> depth in practice, doesnt it?
> 
> All we need to track in the debug code is 
> max-{syscall,softirq,hardirq,nmi}. The sum of these 4 counts must be 
> smaller than the max - even if (as you are right to point out) we 
> dont hit that magic combo that truly maximizes the depth.

Right, so the thing I'd worry about is someone adding kmap_atomic() to
an interrupt context that didn't have interrupts disabled and then
managing to nest that a few times.

Suppose you put it in some IO completion handler, and someone has 4 IO
controllers installed and all 4 IO interrupts come in at the 'same'
time.

With types you could warn on similarly to what we do today, but with the
simple push/pop that might be a lot harder.

Anyway, with the whole cr2 fiddling bit being discussed this seems to
become redundant.

> And note that in practice many of the current types are exclusive to 
> each other - so using the stack would _reduce_ the amount of 
> kmap-atomic space we need.

Yeah, I did realize that.
