Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXBFEiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXBFEiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 23:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXBFEiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 23:38:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48645 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXBFEiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 23:38:06 -0500
Date: Mon, 5 Feb 2007 20:37:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kai" <epimetreus@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Neil Brown <neilb@suse.de>
Subject: Re: Bio device too big | kernel BUG at mm/filemap.c:537!
Message-Id: <20070205203750.7be7f772.akpm@linux-foundation.org>
In-Reply-To: <1170734919.15636.1173102761@webmail.messagingengine.com>
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Feb 2007 20:08:39 -0800 "Kai" <epimetreus@fastmail.fm> wrote:

> I booted up the new kernel version, 2.6.20; I pretty much copied over my
> .config that worked in 2.6.19.2, that has worked correctly since that
> version came out... I looked through the menuconfig to see if any new
> options had been added, but I'm pretty sure I didn't change anything,
> and got this error message shortly after booting:
> 
> bio too big device hdg1 (184 > 128)
> ------------[ cut here ]------------
> kernel BUG at mm/filemap.c:537!
> invalid opcode: 0000 [#1]
> Modules linked in: iptable_filter ip_tables x_tables snd_seq_dummy
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
> snd_mixer_oss nvidia_agp agpgart
> CPU:    0
> EIP:    0060:[<c012dc66>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.20 #1)
> EIP is at unlock_page+0xd/0x22
> eax: 00000000   ebx: c1714a20   ecx: 00000000   edx: c1714a20
> esi: c199c45c   edi: 00000001   ebp: 1422bf48   esp: f7c8df18
> ds: 007b   es: 007b   ss: 0068
> Process md0_raid5 (pid: 901, ti=f7c8c000 task=f7c50050 task.ti=f7c8c000)
> Stack: c1997920 c016363c c1bca460 c1997920 c1bca460 c0315af2 f7c8df4c
> f7c8df50
>        c1bca460 00000000 00000000 1422bf48 0a115f48 00000002 00000000
>        c1bca460
>        00000002 f7faf600 fffffffc c0315b92 f7ee6c20 7fffffff f7c8df8c
>        c031f877
> Call Trace:
>  [<c016363c>] mpage_end_io_read+0x4c/0x5e
>  [<c0315af2>] retry_aligned_read+0x108/0x13a
>  [<c0315b92>] raid5d+0x6e/0xcc
>  [<c031f877>] md_thread+0xdc/0xf2
>  [<c0122465>] autoremove_wake_function+0x0/0x33
>  [<c0110a90>] __wake_up_common+0x35/0x4f
>  [<c0122465>] autoremove_wake_function+0x0/0x33
>  [<c031f79b>] md_thread+0x0/0xf2
>  [<c01221b8>] kthread+0x72/0x97
>  [<c0122146>] kthread+0x0/0x97
>  [<c0103a7b>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: 73 ff ff ff b9 a4 d6 12 c0 89 fa c7 04 24 02 00 00 00 e8 87 77 27
> 00 83 c4 44 5b 5e 5f c3 53 89 c3 0f ba 30 00 19 c0 85 c0 75 04 <0f> 0b
> eb fe 89 d8 e8 41 ff ff ff 89$
> EIP: [<c012dc66>] unlock_page+0xd/0x22 SS:ESP 0068:f7c8df18
> 
> The devices it seems to be complaining about are /dev/hdg and /dev/hde,
> which are physically attached to the PCI0680 Ultra ATA-133 Host
> Controller listed in lspci.txt.
> Both drives are 160 GB Western Digital HDDs... don't remember the
> precise model, but I can find out if necessary.
> 

You hit two bugs.  It seems that raid5 is submitting BIOs which are larger
than the device can accept.  In response someone (probably the block layer)
caused a page to come unlocked twice, possibly by running bi_end_io twice
against the same BIO.
