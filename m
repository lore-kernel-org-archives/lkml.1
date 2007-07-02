Return-Path: <linux-kernel-owner+w=401wt.eu-S1751223AbXGBECQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbXGBECQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 00:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXGBECG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 00:02:06 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:25474 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXGBECF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 00:02:05 -0400
Date: Mon, 2 Jul 2007 08:01:26 +0400
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioremap: fix iounmap numpages
Message-ID: <20070702040126.GB11032@dnb.sw.ru>
Mail-Followup-To: Dave Young <hidave.darkstar@gmail.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
References: <20070629170907.GA1735@darkstar.te-china.tietoenator.com> <4684FCC9.7010709@goop.org> <a8e1da0707011733g643730eakde04b40a4f8293c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8e1da0707011733g643730eakde04b40a4f8293c0@mail.gmail.com>
Organization: SWsoft.
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:33 Пнд 02 Июл     , Dave Young wrote:
> > On 6/29/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Dave Young wrote:
> > > Hi,
> > > The second parameter of change_page_attr in iounmap is wrong, it should 
> > be (p->size - 1) >> PAGE_SHIFT
> > >
> >
> > Why's that?  Isn't p->size always going to be a pagesize multiple; in
> > which case, why would you want to change_page_attr on n-1 pages?
> >
> > Are you seeing a problem that this patch fixes?
> >
> >     J
> >
>  Hi,
>  Please read the  ioremap_nocache function, the page number is calculated by:
> 
>  last_addr = phys_addr + size - 1;
>  npages = (last_addr - phys_addr) >> PAGE_SHIFT;
> 
>  but the pages number in iounmap is p->size >> PAGE_SHIFT, the result
>  is not consistent.
It's absolutely true in fact last page is just guard page witch can't be
toched. And (size -1) magic was used in all io**map code before,
but when someone remove this magic by occasion :)
BTW: XEN currently use this magic.
arch/i386/mm/ioremap-xen.c: iounmap() {
....
	/* p->size includes the guard page, but cpa doesn't like that */
	change_page_attr(virt_to_page(bus_to_virt(p->phys_addr)),
		(p->size - PAGE_SIZE) >> PAGE_SHIFT

> 
>  If there's no netsc520 device then the netsc520 mtd driver
>  initializing will cause oops.
>  I debugged it with some printk messages, find that the ioremap_nocache
>  call change_page_attr 256 times, but the iounmap call change_page_attr
>  more than 256 times, so kernel oops. please finid the oops message:
> 
>  ------------[ cut here ]------------
>  kernel BUG at arch/i386/mm/pageattr.c:175!
>  invalid opcode: 0000 [#1]
>  PREEMPT SMP
>  Modules linked in: cfi_probe gen_probe netsc520 mtdpart mtdcore
>  chipreg map_funcs snd_seq_dummy snd_seq_oss snd_seq_midi_event
>  snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_intel snd_pcm
>  snd_timer snd soundcore snd_page_alloc capability common
>  cap e100 mii agpgart pcspkr psmouse
>  CPU:    0
>  EIP:    0060:[<c0118ff5>]    Not tainted VLI
>  EFLAGS: 00010082   (2.6.22-rc6 #15)
>  EIP is at __change_page_attr+0x185/0x1a0
>  eax: 0000afe0   ebx: c1006000   ecx: c100afe0   edx: c1000000
>  esi: c057fc00   edi: c0300000   ebp: 00000163   esp: f74c7f40
>  ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
>  Process modprobe (pid: 1440, ti=f74c6000 task=f742aa20 task.ti=f74c6000)
>  Stack: 00000163 c1006000 00000100 00000000 00000101 c011904b 00000202 
>  00000163
>        f7b46ee0 f8980000 c1004000 f74c6000 c0118c60 f886e237 f88810a6 
>  f8881600
>        0805f9c8 00000001 f88830d2 f88810cc 00100000 00000000 00200000 
>  00000000
>  Call Trace:
>  [<c011904b>] change_page_attr+0x3b/0x70
>  [<c0118c60>] iounmap+0xd0/0xe0
>  [<f88830d2>] init_netsc520+0xd2/0xf5 [netsc520]
>  [<c01451a9>] sys_init_module+0xd9/0x140
>  [<c0104238>] syscall_call+0x7/0xb
>  [<c0420000>] packet_rcv+0x90/0x320
>  =======================
>  Code: c3 85 db b8 f4 ff ff ff 74 af a1 80 15 5a c0 89 d9 89 fa 29 c1
>  c1 f9 05 89 f0 c1 e1 0c 09 e9 e8 22 fe ff ff 89 d9 e9 07 f
>  f ff ff <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe eb 0d 90 90 90 90 90 90 90
>  EIP: [<c0118ff5>] __change_page_attr+0x185/0x1a0 SS:ESP 0068:f74c7f40
> 
>  Regards
>  dave
>  -
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/

