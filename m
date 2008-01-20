Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYATEAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYATEAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 23:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYATEAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 23:00:41 -0500
Received: from sandeen.net ([209.173.210.139]:17506 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYATEAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 23:00:40 -0500
Message-ID: <4792C767.7010708@sandeen.net>
Date: Sat, 19 Jan 2008 22:00:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 oops ext3_clear_inode+0x25/0xa0
References: <1200681573.4252.5.camel@localhost>
In-Reply-To: <1200681573.4252.5.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> Dear all,
> 
> I've just got this oops (causing the machine to hang finally)...
> 
> Any ideas?
> Soeren

I've seen an awful lot of oopses out there on this path,
kswapd->shrink_icache_memory; some get a little further and oops in
ext3_discard_reservation.

A few were chalked up to bad memory, but others were not.  Do you happen
to use suspend/resume?

Thanks to kerneloops.org... :)

All code
========
   0:	12 11                	adc    (%ecx),%dl
   2:	f8                   	clc
   3:	ff 66 90             	jmp    *0xffffff90(%esi)
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	89 1c 24             	mov    %ebx,(%esp)
   c:	8d 98 60 ff ff ff    	lea    0xffffff60(%eax),%ebx
  12:	89 74 24 04          	mov    %esi,0x4(%esp)
  16:	89 c6                	mov    %eax,%esi
  18:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1c:	8b 53 70             	mov    0x70(%ebx),%edx
  1f:	8b 7b 54             	mov    0x54(%ebx),%edi
  22:	85 d2                	test   %edx,%edx
  24:	74 16                	je     0x3c
  26:	83 fa ff             	cmp    $0xffffffff,%edx
  29:	74 11                	je     0x3c
  2b:*	f0 ff 0a             	lock decl (%edx)     <-- trapping instruction

Looks like it blew up in (inlined) posix_acl_release(), I think
EXT3_I(inode)->i_acl passed to it was 66e88e66, in %edx.

I think %edi is the i_block_alloc_info, 0f01c883, which also looks
crunchy.  Use after free perhaps?

> BUG: unable to handle kernel paging request at virtual address 66e88e66

Nice symmetric number, anyway.  :)

I've seen enough of these now, something real seems to be going on but I
don't know what yet.

-Eric

> printing eip: c01fac85 *pde = 00000000 
> Oops: 0002 [#1] PREEMPT SMP 
> Modules linked in: hci_usb hidp rfcomm l2cap bluetooth tun cpufreq_stats coretemp xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 ah4 aes_generic hfsplus binfmt_misc fuse ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables eeprom applesmc hwmon input_polldev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer appletouch evdev i2c_i801 snd soundcore snd_page_alloc sky2 video intel_agp output agpgart
> 
> Pid: 205, comm: kswapd0 Not tainted (2.6.24-rc8-sonne #7)
> EIP: 0060:[<c01fac85>] EFLAGS: 00010213 CPU: 1
> EIP is at ext3_clear_inode+0x25/0xa0
> EAX: c008f0a0 EBX: c008f000 ECX: 00000000 EDX: 66e88e66
> ESI: c008f0a0 EDI: 0f01c883 EBP: 0000004d ESP: f7d29ebc
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kswapd0 (pid: 205, ti=f7d28000 task=f7fdf540 task.ti=f7d28000)
> Stack: c008f0a0 00000000 f7d29ef8 c0192d62 0000004d c008f0a0 c008f0a8 c019309a 
>        e98b9ac8 00000080 00000080 f7d29ef8 c01932ec 00000000 00000080 c008f2b0 
>        ea1bdcd8 0002d438 0000013f c04ac24c 000000d0 c0166e4c 00002e0b 00000000 
> Call Trace:
>  [<c0192d62>] clear_inode+0x62/0x140
>  [<c019309a>] dispose_list+0x1a/0xe0
>  [<c01932ec>] shrink_icache_memory+0x18c/0x250
>  [<c0166e4c>] shrink_slab+0x12c/0x1a0
>  [<c016726d>] kswapd+0x32d/0x4d0
>  [<c0142020>] autoremove_wake_function+0x0/0x40
>  [<c0127c5d>] complete+0x3d/0x60
>  [<c0166f40>] kswapd+0x0/0x4d0
>  [<c0141d52>] kthread+0x42/0x70
>  [<c0141d10>] kthread+0x0/0x70
>  [<c01050b3>] kernel_thread_helper+0x7/0x14
>  =======================
> Code: 12 11 f8 ff 66 90 83 ec 0c 89 1c 24 8d 98 60 ff ff ff 89 74 24 04 89 c6 89 7c 24 08 8b 53 70 8b 7b 54 85 d2 74 16 83 fa ff 74 11 <f0> ff 0a 0f 94 c0 84 c0 75 51 c7 43 70 ff ff ff ff 8b 53 74 85 
> EIP: [<c01fac85>] ext3_clear_inode+0x25/0xa0 SS:ESP 0068:f7d29ebc
> ---[ end trace 8dd028de7ae6e34e ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

