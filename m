Return-Path: <linux-kernel-owner+w=401wt.eu-S1423444AbXD3SF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423444AbXD3SF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423401AbXD3SF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:05:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:14068 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423444AbXD3SFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n8nWSQeJo86Nq3os4O8ua72TrK25+EtGJDlJ8E1GDtCB0JgmyEX1Pn/5gbT1AnmcLzNAP5g+DuRZMi91GQCrLOysdTVAVfljo2xl0vinUCDieRFpzYCLjxPLeN8UYjzD33MN4A4KwVVpjmNnVnoesk97ayFXkTTyTEUJbkkiEjw=
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
From: Jon Burgess <jburgess777@googlemail.com>
To: Gregoire Favre <Gregoire.Favre@gmail.com>
Cc: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
In-Reply-To: <20070430165232.GA6754@gmail.com>
References: <20070427111047.GB10284@gmail.com>
	 <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
	 <1177711220.26292.20.camel@localhost.localdomain>
	 <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com>
	 <1177780652.7152.14.camel@localhost.localdomain>
	 <1177791277.5170.11.camel@localhost.localdomain>
	 <20070430165232.GA6754@gmail.com>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 19:05:16 +0100
Message-Id: <1177956316.4752.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 18:52 +0200, Gregoire Favre wrote:
> On Sat, Apr 28, 2007 at 09:14:37PM +0100, Jon Burgess wrote:
> 
> > While the above patch works, it seems the underlying causes is that
> > vmalloc_32() is providing memory above 4Gb on x86-64 which is not what
> > the driver expects. This same issue came up a few weeks ago with regards
> > to DRM on radeon http://lkml.org/lkml/2007/4/1/257
> > 
> > Andi Kleen included a patch to ensure vmalloc_32() returns memory <4Gb
> > in a patch which is currently in -mm
> >  http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/x86_64-mm-vmalloc-32.patch
> > 
> > With this patch applied the current driver appears to work OK. 
> > 
> > Attached is a smaller patch against v4l-dvb which just adds the missing
> > pci_unmap_sg() call.
> 
> I was using 2.6.20.1 with the x86_64-mm-vmalloc-32.patch and you small
> patch : working but not perftctly stable.
> 
> So I compiled 2.6.21-rc7-mm2 and at boot I got a problem :
> 
> ksymoops dmesg-2.6.21-rc7-mm2-4Gb.txt 
> ksymoops 2.4.11 on x86_64 2.6.21-rc7-mm2.  Options used
>      -V (default)
>      -k /proc/ksyms (default)
>      -l /proc/modules (default)
>      -o /lib/modules/2.6.21-rc7-mm2/ (default)
>      -m /usr/src/linux/System.map (default)
> 
> Warning: You did not tell me where to find symbol information.  I will
> assume that the log matches the kernel and modules that are running
> right now and I'll use the default options above for symbol resolution.
> If the current kernel and/or modules do not match the log, you can get
> more accurate output by telling me the kernel version and where to find
> map, modules, ksyms etc.  ksymoops -h explains the options.
> 
> Error (regular_file): read_ksyms stat /proc/ksyms failed
> ksymoops: No such file or directory
> No modules in ksyms, skipping objects
> No ksyms, skipping lsmod
> SGI XFS with large block/inode numbers, no debug enabled
> ehci_hcd 0000:00:1a.7: debug port 1
> ehci_hcd 0000:00:1d.7: debug port 1
> kernel BUG at mm/slab.c:2766!
> CPU 1 
> Pid: 6616, comm: cx88[0] dvb Tainted: P       2.6.21-rc7-mm2 #1
> RIP: 0010:[<ffffffff802608e5>]  [<ffffffff802608e5>] cache_alloc_refill+0x495/0x560
> Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
> RSP: 0000:ffff8101045dfd50  EFLAGS: 00010002
> RAX: 0000000000000000 RBX: 000000000000003c RCX: 0000000000000000
> RDX: ffff81010006a400 RSI: 0000000000000004 RDI: ffff81010001c180
> RBP: ffff81010006a400 R08: 00000000ffffffff R09: 0000000000000004
> R10: 0000000000000020 R11: 0000000000000001 R12: ffff81010001e2c0
> R13: ffff81010001c140 R14: 0000000000000000 R15: ffff81010000b000
> FS:  0000000000000000(0000) GS:ffff810100027540(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00002aaab0a9ea18 CR3: 0000000000201000 CR4: 00000000000006e0
> Stack:  0000000000021024 0000000000000000 ffff81010001c180 ffff810100054060
>  ffffc20000000004 0000000000000286 0000000000000030 ffff810102b83140
>  0000000000006000 0000000000000004 ffff81010241c0e0 ffffffff802c95b8
> Call Trace:
>  [<ffffffff802c95b8>] __kmalloc+0x68/0x70
>  [<ffffffff802c19e7>] __vmalloc_area_node+0x157/0x1a0
>  [<ffffffff880bc8a0>] :video_buf:videobuf_dma_init_kernel+0x50/0xd0
>  [<ffffffff880bcdbe>] :video_buf:videobuf_iolock+0xbe/0xf0
>  [<ffffffff880fc07e>] :cx8802:cx8802_buf_prepare+0xde/0x130
>  [<ffffffff880bc0c7>] :video_buf:videobuf_read_start+0xc7/0x170
>  [<ffffffff880c23b0>] :video_buf_dvb:videobuf_dvb_thread+0x0/0x190
>  [<ffffffff880c23e9>] :video_buf_dvb:videobuf_dvb_thread+0x39/0x190
>  [<ffffffff880c23b0>] :video_buf_dvb:videobuf_dvb_thread+0x0/0x190
>  [<ffffffff802342eb>] kthread+0x4b/0x80
>  [<ffffffff802622a8>] child_rip+0xa/0x12
>  [<ffffffff802342a0>] kthread+0x0/0x80
>  [<ffffffff8026229e>] child_rip+0x0/0x12
> Code: 0f 0b eb fe 0f 0b eb fe 41 8b 44 24 30 a8 01 0f 84 ed fd ff 
> 
> 
> >>RIP; ffffffff802608e5 <cache_alloc_refill+495/560>   <=====
> 
> >>RDX; ffff81010006a400 <phys_startup_64+ffff8100ffe6a400/ffffffff80000000>
> >>RDI; ffff81010001c180 <phys_startup_64+ffff8100ffe1c180/ffffffff80000000>
> >>RBP; ffff81010006a400 <phys_startup_64+ffff8100ffe6a400/ffffffff80000000>
> >>R08; 00000000ffffffff <phys_startup_64+ffdfffff/ffffffff80000000>
> >>R12; ffff81010001e2c0 <phys_startup_64+ffff8100ffe1e2c0/ffffffff80000000>
> >>R13; ffff81010001c140 <phys_startup_64+ffff8100ffe1c140/ffffffff80000000>
> >>R15; ffff81010000b000 <phys_startup_64+ffff8100ffe0b000/ffffffff80000000>
> 
> Trace; ffffffff802c95b8 <__kmalloc+68/70>
> Trace; ffffffff802c19e7 <__vmalloc_area_node+157/1a0>
> Trace; ffffffff880bc8a0 <_end+79f1b1c/7ef3527c>
> Trace; ffffffff880bcdbe <_end+79f203a/7ef3527c>
> Trace; ffffffff880fc07e <_end+7a312fa/7ef3527c>
> Trace; ffffffff880bc0c7 <_end+79f1343/7ef3527c>
> Trace; ffffffff880c23b0 <_end+79f762c/7ef3527c>
> Trace; ffffffff880c23e9 <_end+79f7665/7ef3527c>
> Trace; ffffffff880c23b0 <_end+79f762c/7ef3527c>
> Trace; ffffffff802342eb <kthread+4b/80>
> Trace; ffffffff802622a8 <child_rip+a/12>
> Trace; ffffffff802342a0 <kthread+0/80>
> Trace; ffffffff8026229e <child_rip+0/12>
> 
> Code;  ffffffff802608e5 <cache_alloc_refill+495/560>
> 0000000000000000 <_RIP>:
> Code;  ffffffff802608e5 <cache_alloc_refill+495/560>   <=====
>    0:   0f 0b                     ud2a      <=====
> Code;  ffffffff802608e7 <cache_alloc_refill+497/560>
>    2:   eb fe                     jmp    2 <_RIP+0x2>
> Code;  ffffffff802608e9 <cache_alloc_refill+499/560>
>    4:   0f 0b                     ud2a   
> Code;  ffffffff802608eb <cache_alloc_refill+49b/560>
>    6:   eb fe                     jmp    6 <_RIP+0x6>
> Code;  ffffffff802608ed <cache_alloc_refill+49d/560>
>    8:   41 8b 44 24 30            mov    0x30(%r12),%eax
> Code;  ffffffff802608f2 <cache_alloc_refill+4a2/560>
>    d:   a8 01                     test   $0x1,%al
> Code;  ffffffff802608f4 <cache_alloc_refill+4a4/560>
>    f:   0f 84 ed fd ff 00         je     fffe02 <_RIP+0xfffe02>
> 
> 
> 1 warning and 1 error issued.  Results may not be reliable.
> 
> I can't compil hg source with your patch for this kernel :
> 
> make -C /lib/modules/2.6.21-rc7-mm2/build SUBDIRS=/usr/src/CVS/v4l-dvb/v4l  modules
> make[1]: Entering directory `/usr/src/linux-2.6.21-rc7-mm2'
>   CC [M]  /usr/src/CVS/v4l-dvb/v4l/dvb_net.o
> /usr/src/CVS/v4l-dvb/v4l/dvb_net.c: In function 'dvb_net_eth_type_trans':
> /usr/src/CVS/v4l-dvb/v4l/dvb_net.c:186: error: 'struct sk_buff' has no member named 'mac'
> /usr/src/CVS/v4l-dvb/v4l/dvb_net.c: In function 'dvb_net_ule':
> /usr/src/CVS/v4l-dvb/v4l/dvb_net.c:625: warning: cast to pointer from integer of different size
> /usr/src/CVS/v4l-dvb/v4l/dvb_net.c:626: warning: cast to pointer from integer of different size
> /usr/src/CVS/v4l-dvb/v4l/dvb_net.c:627: warning: cast to pointer from integer of different size
> /usr/src/CVS/v4l-dvb/v4l/dvb_net.c:628: warning: cast to pointer from integer of different size
> make[2]: *** [/usr/src/CVS/v4l-dvb/v4l/dvb_net.o] Error 1
> make[1]: *** [_module_/usr/src/CVS/v4l-dvb/v4l] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.21-rc7-mm2'
> make: *** [default] Error 2
> 
> What kernel (with which patches) are you using ?
> 
> Thank,

I'm currently using 2.6.21 + x86_64-mm-vmalloc-32.patch with the v4l-dvb
drivers. I need to use the v4l-dvb tree in order to get the IR remote
working reliably. This combination compiles and works OK for me.

My hardware is different to yours. My Nova-T card has a saa7146 chip but
your card appears to be one of the newer cx88 based ones.

I'd suggest that you stick with 2.6.21 or 2.6.21.1 instead of the -mm
kernels since these are generally less stable then the main tree.

	Jon


