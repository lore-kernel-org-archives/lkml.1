Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFIN6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFIN6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYFIN6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:58:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:42189 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYFIN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WqLJPFKH8E15jfUJJ2cCJDCSboFlBe0nzv9hIcCwKfoAteVP/jeDGcnSQzG8u5L6F5
         /bPIJqE5IOFJIEiHzCIEHaxE5hsgwY5VBsykWt1BKeYBvNiXBwCpZ18ZXJ8gi4Y8ep9B
         /mzMQKReyzANLV+RUGHo29APaesmt/PhBrzyY=
Message-ID: <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
Date: Mon, 9 Jun 2008 15:58:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in blk_lookup_devt()/prepare_namespace()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Neil Brown" <neilb@suse.de>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
In-Reply-To: <20080609133426.GB20194@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080609080312.GA32458@elte.hu>
	 <20080609020623.b6727f2b.akpm@linux-foundation.org>
	 <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
	 <20080609133426.GB20194@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Jun 09, 2008 at 11:09:07AM +0200, Vegard Nossum wrote:
>  > On Mon, Jun 9, 2008 at 11:06 AM, Andrew Morton
>  > <akpm@linux-foundation.org> wrote:
>  > > On Mon, 9 Jun 2008 10:03:12 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > >> -tip testing has started triggering a new type of sporadic bootup crash
>  > >> a few days ago. Find below a collection of 14 crashes i've managed to
>  > >> capture so far, which are all similar to this crash pattern:
>  > >>
>  > >>  BUG: unable to handle kernel paging request at ffff81003b984fb8
>  > >>  IP: [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
>  > >>  PGD 8063 PUD 9063 PMD 3be2d163 PTE 800000003b984160
>  > >>  Oops: 0000 [1] SMP DEBUG_PAGEALLOC
>  > >>
>  > >>  Call Trace:
>  > >>   [<ffffffff80bac17b>] ? ip_auto_config+0x0/0xd94
>  > >>   [<ffffffff80209259>] name_to_dev_t+0x145/0xeec
>  > >>   [<ffffffff803ff2be>] ? __next_cpu_nr+0x22/0x2b
>  > >>   [<ffffffff80b7f372>] prepare_namespace+0x91/0x14c
>  > >>   [<ffffffff80b7eb70>] kernel_init+0x2fe/0x314
>  > >>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
>  > >>   [<ffffffff80741bbb>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  > >>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
>  > >>   [<ffffffff8020d3f8>] child_rip+0xa/0x12
>  > >>   [<ffffffff8020c90c>] ? restore_args+0x0/0x30
>  > >>   [<ffffffff8025068d>] ? trace_hardirqs_off+0xd/0xf
>  > >>   [<ffffffff80b7e872>] ? kernel_init+0x0/0x314
>  > >>   [<ffffffff8020d3ee>] ? child_rip+0x0/0x12
>  > >
>  > > Did you work out where it's dying?  Deref of `dev' I assume?
>  >
>  >                         struct gendisk *disk = dev_to_disk(dev);
>
>
> Mariusz already ran into this.
>
>  Neil already did some analysis of what could cause such problems [1],
>  but since Mariusz was no longer able to reproduce it with more recent
>  kernels it became somehow forgotten.
>

Hi,

Thanks, that matches exactly my findings too. And I agree very much
that it's strange how something which is not a gendisk can sneak
itself onto this list. So I have a feeling that it's something more
subtle than that.

It seems that Ingo is able to reproduce this "quite often", given the
number of reports he had (even though it was several thousand
bootups). We might simply add a printk() in there to determine which
device it is that is failing -- and look up the corresponding code to
see if it's doing anything weird.

But it seems more likely to be some kind of corruption.

I'm by no means familiar with this area, so please excuse me if what
I'm writing seems very obvious or stupid :-)

It seems that this list (block_class.devices) is protected by
block_class_lock in block/genhd.c. This list is only ever modified by
device_add() and device_del() in drivers/base/core.c. Both of those
are (only) protected by dev->class->sem, however. Is there a locking
mismatch here? But none of the locking code here seems to be changed
in years...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
