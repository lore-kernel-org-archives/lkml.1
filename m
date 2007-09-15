Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbXIOJrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbXIOJrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbXIOJrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:47:13 -0400
Received: from nn7.de ([85.214.94.156]:50765 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbXIOJrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:47:11 -0400
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
From: Soeren Sonnenburg <kernel@nn7.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-fsdevel@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200709140722.58046.nickpiggin@yahoo.com.au>
References: <1189675222.5352.10.camel@localhost>
	 <200709130951.48194.nickpiggin@yahoo.com.au>
	 <1189749754.25045.10.camel@localhost>
	 <200709140722.58046.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 15 Sep 2007 09:47:07 +0000
Message-Id: <1189849627.4270.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 07:22 +1000, Nick Piggin wrote:
> On Friday 14 September 2007 16:02, Soeren Sonnenburg wrote:
> > On Thu, 2007-09-13 at 09:51 +1000, Nick Piggin wrote:
> > > On Thursday 13 September 2007 19:20, Soeren Sonnenburg wrote:
> > > > Dear all,
> > > >
> > > > I've just seen this in dmesg on a AMD K7 / kernel 2.6.22.6 machine
> > > > (config attached).
> > > >
> > > > Any ideas / which further information needed ?
> > >
> > > Thanks for the report. Is it reproduceable? It seems like the
> > > locks_free_lock call that's oopsing is coming from __posix_lock_file.
> > > The actual function looks fine, but the lock being freed could have
> > > been corrupted if there was slab corruption, or a hardware corruption.
> > >
> > > You could: try running memtest86+ overnight. And try the following
> > > patch and turn on slab debugging then try to reproduce the problem.
> >
> > OK so far I've run memtest86+ 1.40 from freedos for 8 hrs (v1.70 hung on
> > startup) - nothing.
> 
> Thanks.
> 
> > Could this corruption be caused by a pci card/driver? I am asking as I
> > am using a new dvb-t card (asus p7131) and the oops happened after 5 or
> > 6 days of uptime just about a day after watching some movie (very bad
> > reception/lots of errors).
> 
> It could be caused by that, definitely. slab debugging plus my earlier
> patch may help to narrow it down. (or stress testing with / without the
> dvb card in action).
> 
> 
> > However this machine used to have uptimes of months before the dvb card
> > was in there and the kernel version upgrade (don't know which version
> > that was...).
> >
> > Anyway I am not sure if this is reproducible, but I will keep memtest
> > running today and then proceed as you said...
> 
> OK. Don't put too much effort into memtest if it hasn't caught anything
> by now -- it's really only exercising your CPU and memory, so even if it
> is your video hardware, it probably won't find the problem.

Memtest did not find anything after 16 passes so I finally stopped it
applied your patch and used

CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y

and booted into the new kernel.

A few hours later the machine hung (due to nmi watchdog rebooted), so I
restarted and disabled the watchdog and while compiling a kernel with a
``more minimal'' config I got this (not sure whether this is related/the
cause .../ note that I don't use a swapfile/partition).

I would need more guidance on what to try now...

Thanks!
Soeren

swap_dup: Bad swap file entry 28c8af9d
VM: killing process cc1
Eeek! page_mapcount(page) went negative! (-1)
  page pfn = 36233
  page->flags = 40000834
  page->count = 2
  page->mapping = c1cfed14
  vma->vm_ops = run_init_process+0x3feff000/0x14
------------[ cut here ]------------
kernel BUG at mm/rmap.c:628!
invalid opcode: 0000 [#1]
Modules linked in: ipt_iprange ipt_REDIRECT capi kernelcapi capifs ipt_REJECT xt_tcpudp xt_state xt_limit ipt_LOG ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables b44 ohci1394 ieee1394 nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack lcd tda827x saa7134_dvb dvb_pll video_buf_dvb tda1004x tuner ves1820 usb_storage usblp budget_ci budget_core saa7134 compat_ioctl32 dvb_ttpci dvb_core saa7146_vv video_buf saa7146 ttpci_eeprom ir_kbd_i2c videodev v4l2_common v4l1_compat ir_common via_agp agpgart
CPU:    0
EIP:    0060:[<c0144487>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22.6 #2)
EIP is at page_remove_rmap+0xd4/0x101
eax: 00000000   ebx: c16c4660   ecx: 00000000   edx: 00000000
esi: d4570b30   edi: d6560a78   ebp: b7400000   esp: d6265eac
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process cc1 (pid: 26095, ti=d6264000 task=d67af5b0 task.ti=d6264000)
Stack: c0422e26 c1cfed14 c16c4660 b729e000 c013f5b8 36233cce 00000000 d4570b30 
       d6265f20 00000000 00000001 f4ffcb70 f483a3b8 c04f44b8 00000000 ffffffff 
       f4ffcb70 00303ff4 b7c18000 00000000 d6265f20 f4a8c510 f483a3b8 00000009 
Call Trace:
 [<c013f5b8>] unmap_vmas+0x23f/0x404
 [<c0141c09>] exit_mmap+0x5f/0xc9
 [<c011923a>] mmput+0x1b/0x5e
 [<c011cf97>] do_exit+0x1a0/0x606
 [<c01135f8>] do_page_fault+0x49c/0x518
 [<c011e340>] __do_softirq+0x35/0x75
 [<c011315c>] do_page_fault+0x0/0x518
 [<c039aada>] error_code+0x6a/0x70
 =======================
Code: c0 74 0d 8b 50 08 b8 56 2e 42 c0 e8 ac f4 fe ff 8b 46 48 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 75 2e 42 c0 e8 91 f4 fe ff <0f> 0b eb fe 8b 53 10 8b 03 83 e2 01 c1 e8 1e f7 da 83 c2 04 69 
EIP: [<c0144487>] page_remove_rmap+0xd4/0x101 SS:ESP 0068:d6265eac
Fixing recursive fault but reboot is needed!


-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
