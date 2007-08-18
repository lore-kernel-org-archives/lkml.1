Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbXHRKhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbXHRKhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXHRKh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:37:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60850 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXHRKhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:37:25 -0400
Date: Sat, 18 Aug 2007 12:37:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hajime Inoue <hinoue@ccsl.carleton.ca>, linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
Message-ID: <20070818103722.GA15626@one.firstfloor.org>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca> <20070814000956.7c8929dd@the-village.bc.nu> <46C1E5F5.9050702@ccsl.carleton.ca> <p73zm0tnbf8.fsf@bingen.suse.de> <20070814234206.76121d02@the-village.bc.nu> <20070814224835.GJ23308@one.firstfloor.org> <20070817141900.GA7223@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817141900.GA7223@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 10:19:00AM -0400, Dave Jones wrote:
> On Wed, Aug 15, 2007 at 12:48:35AM +0200, Andi Kleen wrote:
> 
>  > > > In general the .data protection is only considered a debugging
>  > > > feature. I don't know why Fedora enables it in their production
>  > > > kernels.
>  > > 
>  > > That would be because we think you are wrong 8)
>  > 
>  > Well, it might at best buy you a few weeks/months in
>  > terms of the exploit arms race, but thrash your user's TLBs
>  > forever.
> 
> Show me a single situation where this matters.

We had a couple of benchmarks where compiled in vs external
4K mapped drivers made a noticeable difference.

> When we first enabled, we tried both benchmarks and real-world
> loads, and it didn't matter at all.  Unless something fundamental

It also depends on the CPU -- the sizes of the TLBs vary widely.
On some older CPUs using 2/4MB pages was indeed a bad idea
because the number of large TLB entries were very small.

Also there are sometimes effects where the CPU splits the 
TLBs internally so even with 2MB pages you effectively
get 4K TLB use. You could have run in one of those

> has changed since then, the story should still be the same.

Well if you believe it is that hyper useful you should try to convince 
Linus then to readd the text protection for DEBUG_RODATA and a working text_poke() 
that handles it correctly. The last version was nearly there, unfortunately the
time allowed for a new feature to be buggy and getting fixed before it 
is reverted is very short these days[1].

Even if you say "my dumb attacker can patch sys_call_table but not
root_inode->i_ops in memory" it is still much harder to say 
"my dumb attacker can patch sys_call_table but not a jump into *sys_read"
So without text protection your scheme is really double plus useless.

Modules could be also protected early BTW if you waste enough memory
to make .data page aligned [so likely raising minimal module size
from one page to two]

-Andi

[1] unless you name it pci sysinfo -- then anything is allowed.

