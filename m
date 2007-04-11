Return-Path: <linux-kernel-owner+w=401wt.eu-S1030314AbXDKWQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbXDKWQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXDKWQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:16:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:56668 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030314AbXDKWQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=mho/5w5tuSbg51K8/ciBgF3t9akdq+3569M58AyknvGhjVyedwYaZMG9CtuLVcqSF3BSvM1SKH8/OyLjZrhYKm8Q0YDL43xw6EQZ4GN/m/mCW27ZRJEfskCGQ9+kyfGgeLeiannYRzd3zybQmTx2eUXDUy71vb80cdNbLR8/m04=
Message-ID: <461D5DE3.1050300@googlemail.com>
Date: Thu, 12 Apr 2007 00:14:59 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-04-11-02-24.tar.gz uploaded
References: <200704110926.l3B9Qe3D000895@shell0.pdx.osdl.net>	<461D22E5.9030705@googlemail.com> <20070411121515.56425c23.akpm@linux-foundation.org>
In-Reply-To: <20070411121515.56425c23.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Wed, 11 Apr 2007 20:03:17 +0200
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> akpm@linux-foundation.org napisa__(a):
>>> The mm snapshot broken-out-2007-04-11-02-24.tar.gz has been uploaded to
>>>
>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-11-02-24.tar.gz
>>>
>>> It contains the following patches against 2.6.21-rc6:
>>>
>> After a few seconds of running test_mount_fs.sh
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/test_mount_fs.sh
>> I get this
>>
>> [11083.747512] Filesystem "loop4": Disabling barriers, not supported by the underlying device
>> [11083.759050] XFS mounting filesystem loop4
>> [11083.763769] Slab corruption: xfs_buf start=cce14938, len=272
>> [11083.769986] Redzone: 0x5a2cf071/0x5a2cf071.
>> [11083.774575] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
>> [11083.781146] 0b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6c 6b 6b 6b
>> [11083.787988] Prev obj: start=cce1481c, len=272
>> [11083.792488] Redzone: 0x5a2cf071/0x5a2cf071.
>> [11083.796828] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
>> [11083.803131] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> [11083.810392] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> [11083.817677] Next obj: start=cce14a54, len=272
>> [11083.822146] Redzone: 0x5a2cf071/0x5a2cf071.
>> [11083.826415] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
>> [11083.832784] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> [11083.839403] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> [11083.852797] Ending clean XFS mount for filesystem: loop4
>> [11083.865789] SELinux: initialized (dev loop4, type xfs), uses xattr
>>
> 
> It does appear that someone (probably XFS) has done a use-after-free.
> 
> One way in which you perhaps catch this is to do:
> 
> --- a/fs/xfs/linux-2.6/xfs_buf.h~a
> +++ a/fs/xfs/linux-2.6/xfs_buf.h
> @@ -151,6 +151,7 @@ typedef struct xfs_buf {
>  #ifdef XFS_BUF_LOCK_TRACKING
>  	int			b_last_holder;
>  #endif
> +	char crap[1024];
>  } xfs_buf_t;
>  
> 
> and to then compile with CONFIG_DEBUG_PAGEALLOC.  The enlarged xfs_buf will
> then get unmap-when-freed treatment and hopefully you'll get a nice oops
> from the instruction which is corrupting that memory.  

[ 1053.655367] BUG: unable to handle kernel paging request at virtual address d6871b50
[ 1053.663214]  printing eip:
[ 1053.665971] fdd91dfe
[ 1053.668207] *pde = 0005b067
[ 1053.671088] *pte = 16871000
[ 1053.673948] Oops: 0000 [#1]
[ 1053.676795] PREEMPT SMP DEBUG_PAGEALLOC
[ 1053.680793] last sysfs file: devices/platform/w83627hf.656/temp2_input
[ 1053.687460] Modules linked in: jfs nls_base xfs reiserfs ext4dev jbd2 ext2 loop ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event evdev snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc intel_agp i2c_i801 agpgart ide_cd cdrom rtc unix
[ 1053.744461] CPU:    1
[ 1053.744462] EIP:    0060:[<fdd91dfe>]    Not tainted VLI
[ 1053.744465] EFLAGS: 00010292   (2.6.21-rc6-mm1-1 #2)
[ 1053.757285] EIP is at xlog_iodone+0x99/0xbb [xfs]
[ 1053.762069] eax: 00000000   ebx: d6871ae8   ecx: c04a396c   edx: 00000000
[ 1053.769002] esi: d6871ae8   edi: d0f7def8   ebp: d0fa5f30   esp: d0fa5f18
[ 1053.775912] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[ 1053.781842] Process xfslogd/1 (pid: 3642, ti=d0fa4000 task=cac7f5a0 task.ti=d0fa4000)
[ 1053.789660] Stack: c01339fc d0f36130 db641df8 d6871ae8 d0f3611c d6871b84 d0fa5f40 fddab492 
[ 1053.798450]        dd2439ad d6871b88 d0fa5f70 c0133a26 c9c39db0 d0f36144 d0fa5f70 c01372d8 
[ 1053.807213]        00000000 00000000 fddab477 d0f3611c d0f85d70 00000000 d0fa5fb0 c0134469 
[ 1053.815902] Call Trace:
[ 1053.818721]  [<fddab492>] xfs_buf_iodone_work+0x1b/0x3e [xfs]
[ 1053.824830]  [<c0133a26>] run_workqueue+0x8e/0x15a
[ 1053.829766]  [<c0134469>] worker_thread+0x108/0x116
[ 1053.834793]  [<c013707c>] kthread+0xb5/0xe1
[ 1053.839129]  [<c0104eb3>] kernel_thread_helper+0x7/0x10
[ 1053.844539]  =======================
[ 1053.848172] INFO: lockdep is turned off.
[ 1053.852201] Code: 46 4c db fd ba 02 00 00 00 e8 61 fc 01 00 ba 02 00 00 00 eb 0f 8a 47 78 83 e0 80 3c 01 19 d2 f7 d2 83 e2 02 89 f8 e8 99 f7 ff ff <f6> 46 68 10 75 14 f0 ff 86 bc 00 00 00 7f 0b 8d 86 bc 00 00 00 
[ 1053.872927] EIP: [<fdd91dfe>] xlog_iodone+0x99/0xbb [xfs] SS:ESP 0068:d0fa5f18


> 
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/serialconsole.log
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/mm-config
>>
>> BTW. I wonder when this bug will be fixed
>> [11050.534896] =============================================
>> [11050.541883] [ INFO: possible recursive locking detected ]
>> [11050.547425] 2.6.21-rc6-mm1-1 #1
>> [11050.550630] ---------------------------------------------
>> [11050.556142] umount/3359 is trying to acquire lock:
>> [11050.561060]  (&(&ip->i_lock)->mr_lock){----}, at: [<fdd8729a>] xfs_ilock+0x4d/0x6e [xfs]
>> [11050.569565] 
>> [11050.569567] but task is already holding lock:
>> [11050.575487]  (&(&ip->i_lock)->mr_lock){----}, at: [<fdd8729a>] xfs_ilock+0x4d/0x6e [xfs]
> 
> An xfs thing.

Yes, I know. This is a known bug since at least 05-Jul-2006.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
