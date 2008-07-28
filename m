Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYG1N66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYG1N66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYG1N6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:58:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:3669 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYG1N6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:58:49 -0400
Message-Id: <488DECD9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 28 Jul 2008 14:59:21 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Joerg Roedel" <joro@8bytes.org>, "Andi Kleen" <andi@firstfloor.org>,
       <tglx@linutronix.de>, "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] i386: improve double fault handling
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com>
 <48846B02.76E4.0078.0@novell.com> <20080721110510.GC10782@elte.hu>
 <4885CEFE.76E4.0078.0@novell.com> <20080728134252.GI5515@elte.hu>
In-Reply-To: <20080728134252.GI5515@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Also, you seem to be setting things up to turn NMIs and MCEs into task 
>gates too, right?

Yes, at the very minimum I'd like to have the possibility to do so. Perhaps
under a default-off config option.

>So i'm really uneasy about all this. Breakage in such rarely used code 
>gets found very late, and has thus a high risk of losing debug 
>information when we need it the most. (i.e. it works in the exact 
>_opposite_ way of the intented goal of making things more robust - it 
>makes things less robust)

I realize this aspect, but think that either way has its advantages and
disadvantages.

>Firstly, 64-bit does not use a task gate for double faults anymore. (but 
>uses a separate IST stack for double faults)

Sure - because there are no task gates on 64-bit.

>Secondly, task gates are really a relic that should not be proliferated. 
>Besides the complications in virtualized environments (if more common 
>things like Big Real Mode are not supported well in virtual mode what do 
>we expect of more esoteric features as task gates?) it does not get 
>nearly as much testing on real silicon as other, more mainstream CPU 
>features.
>
>Thirdly, NMI based profiling is quite common, so by turning NMIs into 
>task gates we'd slow that down quite a lot.

As said above, I'd like to allow the option of doing so. Profiling via
NMI certainly will not want this. I'm really uncertain whether modern
machines can report any hardware issue through NMI (no chipset spec
I read 'recently' [covering quite a number of years] was really explicit
about this) - if it can't, MCE would be the only candidate unless
running on really old hardware.

>Also, the change to doublefault_fn is quite ugly - that inner block 
>should be split out into a separate function.

That's certainly doable - if the whole thing is acceptable apart from
that issue, which it doesn't seem it is...

>Plus the notifier - why do we care about that? It's not like we can 

In order to let a kernel debugger take control.

>sanely kexec into a safe kernel from double faulting kernels in most 
>cases. In real cases where i've seen double faults it was due to us 
>corrupting kernel pagetables - kexec has no chance there. To recover 
>from that we'd have to set up the TSS with a safe(r) cr3 as well - but 
>your patch leaves _that_ untouched. (nor do we want to waste extra 
>unswappable memory on such remote possibilities i think)

I've seen double faults due to other than page table corruption, but
I do understand if it is the page tables that caused it handling the
condition is almost impossible without a second complete set of (kernel)
page tables.

Jan

