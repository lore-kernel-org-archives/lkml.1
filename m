Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbYIFOv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbYIFOv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 10:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYIFOvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 10:51:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43774 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYIFOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 10:51:47 -0400
Date: Sat, 6 Sep 2008 16:51:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [2.6.27] overlapping early reservations [was: early exception
	- lockdep related?]
Message-ID: <20080906145122.GA7693@elte.hu>
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com> <1220642738.11202.21.camel@twins.programming.kicks-ass.net> <48C19415.9060108@kernel.org> <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luca Tettamanti <kronos.it@gmail.com> wrote:

> On Fri, Sep 5, 2008 at 10:18 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> > Peter Zijlstra wrote:
> >>
> >> On Fri, 2008-09-05 at 21:17 +0200, Luca Tettamanti wrote:
> >>>
> >>> On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com>
> >>> wrote:
> >>>>
> >>>> On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org>
> >>>> wrote:
> >>>>>
> >>>>> Sadly your config just boots, albeit not to userspace due to missing
> >>>>> drivers.
> >>>>
> >>>> Yes, I managed to boot it with qemu... I tried kgdb - without luck -
> >>>> kernel dies too early.
> >>>> I also managed to get a stack trace :D
> >>>>
> >>>> http://img151.imageshack.us/my.php?image=tracedm1.jpg
> >>>>
> >>>> It seems that lockdep is an innocent bystander... the kernel died with
> >>>> panic() in __reserve_early, and then took another exception while
> >>>> printing the panic (I guess).
> >>>> Will add further debug stuff to see wtf is going on.
> >>>
> >>> Hum, kernel says:
> >>>
> >>> http://img177.imageshack.us/my.php?image=overlappingus2.jpg
> >>>
> >>> Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
> >>> TEXT DATA BSS
> >>>
> >>> It would appear that the initramfs is overlapping the kernel itself,
> >>> is the boot loader (LILO) doing something stupid?
> >>
> >> Suppose it is, lets ask hpa..
> >>
> >
> > It definitely looks like it.
> 
> Is there anything that the kernel could to do confuse lilo? The issue 
> started appearing with 2.6.27 and the outcome of the boot process 
> varies between versions and seems sensitive to configuration changes 
> (though a "bad" kernel consistently fails).

good question. Does your successful 2.6.26 bootup actually _depend_ on 
the initrd? Or does it perhaps have enough built-in drivers that make it 
boot just fine?

in that case v2.6.26 might just have stomped on the initrd silently, 
corrupted it (during kernel decompress), and the initrd unpacker saw the 
corruption and ignored it. Userspace wouldnt care as the kernel had all 
the drivers it needed.

or perhaps something made your v2.6.27 bzImage larger so that the 
overlap happens - while it didnt before.

> Orthogonal to my problem: the panic() in reserve_early is useless for 
> debugging since the output won't reach the screen or the serial 
> console (even worse: the kernel takes an exception while trying to 
> execute the panic). Is it acceptable to replace it with an 
> early_printk + hlt?

very much so. I was wondering about that already.

In any case it would make sense to turn that particular overlap 
situation into a warning message and disable initrd decompress - and try 
to boot with whatever is built-in the kernel.

	Ingo
