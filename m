Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbYKIXAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbYKIXAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 18:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbYKIXAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 18:00:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756365AbYKIXAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:00:36 -0500
Date: Sun, 9 Nov 2008 14:59:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-Id: <20081109145959.6a8d9e8e.akpm@linux-foundation.org>
In-Reply-To: <20081109223748.3182e31d@neptune.home>
References: <20081109202537.33ead0a2@neptune.home>
	<20081109113603.d45361ad.akpm@linux-foundation.org>
	<20081109122515.1deb9ec2@infradead.org>
	<20081109213811.4b85adc6@neptune.home>
	<20081109125522.b5266352.akpm@linux-foundation.org>
	<20081109223748.3182e31d@neptune.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 22:37:48 +0100 Bruno Pr__mont <bonbons@linux-vserver.org> wrote:

> 
> Ok scanned under drivers/video/ for users of fb_cursor() and all those
> (under drivers/video/console/) do GPT_ATOMIC allocations before calling
> fbops->fb_cursor, so my patch chooses the wrong allocation constraint.
> 
> Fixed patch below

Updated, thanks.

> > > In addition I get panics some time after start-up which I'm not sure
> > > what to associate them with (apparently unrelated)
> > > It could be some stack overflow by calling fbset (I will to more
> > > testing in order to find out)
> > > 
> > > First attempt: calling fbset via ssh:
> > > 
> > > [ 1806.952151] BUG: unable to handle kernel NULL pointer
> > > dereference at 00000123 [ 1806.952601] IP: [<c03d2737>]
> > > icmpv6_send+0x387/0x580
> > > 
> > > ...
> > >
> > > Second attempt, delayed after calling fbset from console:
> > > 
> > > [  217.260426] BUG: unable to handle kernel NULL pointer
> > > dereference at 000000c7 [  217.260915] IP: [<c0380b46>]
> > > rt_worker_func+0xb6/0x160
> > 
> > gack.  Your kernel was destroyed.
> > 
> > Stack overflow might well explain this.  Does it work OK with 8k
> > stacks?
> My last attempt with 8k stacks is a bit dated (2.6.27-rc) but back then
> I saw the same kind of behavior than now with viafb, crash with 4k-stack
> but running system with 8k-stack. Running system does of course not mean
> that stack cannot overflow :)
> 
> > scripts/checkstack.pl should help find the problems.
> 
> Thanks for the pointer!
> 
> It show a nice candidate, viafb_ioctl in top-6:
> 0xc011612b identity_mapped [vmlinux]:                   4096

erk!

> 0xc017896b do_sys_poll [vmlinux]:                       888
> 0xc0178bdd do_sys_poll [vmlinux]:                       888
> 0xc024506b sha256_transform [vmlinux]:                  752
> 0xc024768b sha256_transform [vmlinux]:                  752
> 0xc027d933 viafb_ioctl [vmlinux]:                       728
> 0xc01783c8 do_select [vmlinux]:                         708
> 0xc0178853 do_select [vmlinux]:                         708
> 
> 
> On a new attempt the box survived fbset "1280x1024-60" though
> I did wait some time after boot up before calling it.
> So it's pretty probable that either it gets near the limit of stack
> or this time the neighborhood of the stack was not just as critical :/
> 
> Shall I trim down that function's stack usage as well?
> (many structs allocated from stack)

Yes please.

> What is preferred, allocating a big block of memory and point various
> variables inside that block or do multiple individual allocations?
> 
> e.g.
>   u8 data[CURSOR_SIZE/8]
>   u32 data_bak[CURSOR_SIZE/32]
>  =>
>   u8 *data = kzalloc(...)
>   u32 *data_bak = kzalloc(...)
>  or
>   u8 *data = kzalloc(CURSOR_SIZE/8 + CURSOR_SIZE/32, ...)
>   u32 *data_bak = (u32*)(data+CURSOR_SIZE/8);
> 
> First option is more readable, second should be more efficient...

If the total allocation is greater than 4096 then it will need a
larger-than-order-zero allocation, and there are some reliability
risks there.  But if it's 4096 we're OK.

A good way to code this would be

	struct {
		u8 data[CURSOR_SIZE/8];
		u32 data_bak[CURSOR_SIZE/32];
		...
	} *local_data = kzalloc(sizeof(*local_data, GFP_WHATEVER));

	if (!local_data)
		bummer();
	...
	local_data->data = foo;
	...
	kfree(local_data);

where GFP_WHATEVER should be the reliable GFP_KERNEL if possible, and
the unreliable GFP_ATOMIC otherwise.

> The end result readability would suffer even more in case of viafb_ioctl()
> with the big amount of different structs that could be allocated from heap
> instead of stack...

Perhaps the above texhnique could be used there as well.


