Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXGBAdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXGBAdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 20:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXGBAdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 20:33:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:25122 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXGBAdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 20:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kcIMRKDXm/7wuAK7/Jyw1XsKQK0RH8a1U/ozAROTUWKF0CodQQccgpIed0xj2io4ukLze0uSf3s0KHcWGY6BYvsEA7nFgOat2hBYDd/D6usSUzanCap/hcU9QPFN1niKQi+tNLIj4Qe12AMK9HhTdN+Wm4eVSjFWOVj7pJDb3SY=
Message-ID: <a8e1da0707011733g643730eakde04b40a4f8293c0@mail.gmail.com>
Date: Mon, 2 Jul 2007 00:33:35 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] ioremap: fix iounmap numpages
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4684FCC9.7010709@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070629170907.GA1735@darkstar.te-china.tietoenator.com>
	 <4684FCC9.7010709@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 6/29/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Dave Young wrote:
> > Hi,
> > The second parameter of change_page_attr in iounmap is wrong, it should be (p->size - 1) >> PAGE_SHIFT
> >
>
> Why's that?  Isn't p->size always going to be a pagesize multiple; in
> which case, why would you want to change_page_attr on n-1 pages?
>
> Are you seeing a problem that this patch fixes?
>
>     J
>
Hi,
Please read the  ioremap_nocache function, the page number is calculated by:

last_addr = phys_addr + size - 1;
npages = (last_addr - phys_addr) >> PAGE_SHIFT;

but the pages number in iounmap is p->size >> PAGE_SHIFT, the result
is not consistent.

If there's no netsc520 device then the netsc520 mtd driver
initializing will cause oops.
I debugged it with some printk messages, find that the ioremap_nocache
call change_page_attr 256 times, but the iounmap call change_page_attr
more than 256 times, so kernel oops. please finid the oops message:

------------[ cut here ]------------
kernel BUG at arch/i386/mm/pageattr.c:175!
invalid opcode: 0000 [#1]
PREEMPT SMP
Modules linked in: cfi_probe gen_probe netsc520 mtdpart mtdcore
chipreg map_funcs snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_intel snd_pcm
snd_timer snd soundcore snd_page_alloc capability common
cap e100 mii agpgart pcspkr psmouse
CPU:    0
EIP:    0060:[<c0118ff5>]    Not tainted VLI
EFLAGS: 00010082   (2.6.22-rc6 #15)
EIP is at __change_page_attr+0x185/0x1a0
eax: 0000afe0   ebx: c1006000   ecx: c100afe0   edx: c1000000
esi: c057fc00   edi: c0300000   ebp: 00000163   esp: f74c7f40
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process modprobe (pid: 1440, ti=f74c6000 task=f742aa20 task.ti=f74c6000)
Stack: 00000163 c1006000 00000100 00000000 00000101 c011904b 00000202 00000163
       f7b46ee0 f8980000 c1004000 f74c6000 c0118c60 f886e237 f88810a6 f8881600
       0805f9c8 00000001 f88830d2 f88810cc 00100000 00000000 00200000 00000000
Call Trace:
 [<c011904b>] change_page_attr+0x3b/0x70
 [<c0118c60>] iounmap+0xd0/0xe0
 [<f88830d2>] init_netsc520+0xd2/0xf5 [netsc520]
 [<c01451a9>] sys_init_module+0xd9/0x140
 [<c0104238>] syscall_call+0x7/0xb
 [<c0420000>] packet_rcv+0x90/0x320
 =======================
Code: c3 85 db b8 f4 ff ff ff 74 af a1 80 15 5a c0 89 d9 89 fa 29 c1
c1 f9 05 89 f0 c1 e1 0c 09 e9 e8 22 fe ff ff 89 d9 e9 07 f
f ff ff <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe eb 0d 90 90 90 90 90 90 90
EIP: [<c0118ff5>] __change_page_attr+0x185/0x1a0 SS:ESP 0068:f74c7f40

Regards
dave
