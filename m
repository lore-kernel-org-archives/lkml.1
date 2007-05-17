Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbXEQUFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbXEQUFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXEQUFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:05:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42545 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbXEQUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=kDzdYCMhQMmuJdoDv80aXXyWmNWQBhO6sYv9WM8D/Dw2ChGTjh0YhGxph5ErvLMm7vT0WmniWygCP7B3dShm44ttPsG+J2C8teXyJMOSjeLHXjnAsOIH0z5BuaVPpwSsUVqDRLUgRVms6rW6k0UQOv124ljpCn37pB9YgmrcXf0=
Message-ID: <464CB577.5080106@googlemail.com>
Date: Thu, 17 May 2007 22:05:11 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: xfs-masters@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B304C.5040104@googlemail.com> <20070516094133.bec04e65.akpm@linux-foundation.org> <20070517020600.GS85884050@sgi.com> <20070517084135.GA8510@lst.de>
In-Reply-To: <20070517084135.GA8510@lst.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Hellwig napisał(a):
> On Thu, May 17, 2007 at 12:06:00PM +1000, David Chinner wrote:
>>> static inline int put_page_testzero(struct page *page)
>>> {
>>> 	VM_BUG_ON(atomic_read(&page->_count) == 0);
>>> 	return atomic_dec_and_test(&page->_count);
>>> }
>> I haven't seen that one. I expect that it will be the noaddr buffer allocation
>> changes that have triggered this...
> 
> Yes.   xfs_buf_get_noaddr calls xfs_buf_free to free a buffer when
> something fails.  But this is wrong - we want to call xfs_buf_deallocate
> before we setup the page list, and if a page allocation fails we want to
> do out own freeing of just the pages we allocated and call
> _xfs_buf_free_pages.  Currently we do our own freeing _and_ call
> xfs_buf_free which leads to this double free.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-05-17 09:34:44.000000000 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2007-05-17 09:36:53.000000000 +0200
> @@ -792,8 +792,9 @@ xfs_buf_get_noaddr(
>   fail_free_mem:
>   	while (--i >= 0)
>  		__free_page(bp->b_pages[i]);
> +	_xfs_buf_free_pages(bp);
>   fail_free_buf:
> -	xfs_buf_free(bp);
> +	xfs_buf_deallocate(bp);
>   fail:
>  	return NULL;
>  }

I applied your patch and I get another oops

[  261.491499] XFS mounting filesystem loop0
[  261.501641] Ending clean XFS mount for filesystem: loop0
[  261.507698] SELinux: initialized (dev loop0, type xfs), uses xattr
[  261.567441] XFS mounting filesystem loop0
[  261.573931] allocation failed: out of vmalloc space - use vmalloc=<size> to increase size.
[  261.582935] xfs_buf_get_noaddr: failed to map pages
[  261.592478] Ending clean XFS mount for filesystem: loop0
[  261.618543] SELinux: initialized (dev loop0, type xfs), uses xattr
[  261.691563] XFS mounting filesystem loop0
[  261.698927] allocation failed: out of vmalloc space - use vmalloc=<size> to increase size.
                                  ^^^^^^^^^^^^^^^^^^^^
                                  interesting

[  261.724829] xfs_buf_get_noaddr: failed to map pages
[  261.734049] Ending clean XFS mount for filesystem: loop0
[  261.741069] SELinux: initialized (dev loop0, type xfs), uses xattr
[  261.978728] XFS mounting filesystem loop0
[  262.205863] xfs_buf_get_noaddr: failed to map pages
[  262.212523] Ending clean XFS mount for filesystem: loop0
[  262.218084] SELinux: initialized (dev loop0, type xfs), uses xattr
[..]
[  265.842566] xfs_buf_get_noaddr: failed to map pages
[  265.848267] xfs_buf_get_noaddr: failed to map pages
[  265.856480] Ending clean XFS mount for filesystem: loop0
[  265.862260] SELinux: initialized (dev loop0, type xfs), uses xattr
[  265.921288] XFS mounting filesystem loop0
[  265.927123] xfs_buf_get_noaddr: failed to map pages
[  265.932575] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  265.942886]  printing eip:
[  265.945665] fdc8e82a
[  265.948818] *pde = 00000000
[  265.952378] Oops: 0002 [#1]
[  265.955241] PREEMPT SMP 
[  265.957868] Modules linked in: xfs loop ipt_MASQUERADE iptable_nat nf_nat autofs4 af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev intel_agp agpgart snd_timer snd soundcore snd_page_alloc i2c_i801 ide_cd cdrom rtc unix
[  266.007064] CPU:    0
[  266.007065] EIP:    0060:[<fdc8e82a>]    Not tainted VLI
[  266.007066] EFLAGS: 00010246   (2.6.22-rc1-mm1 #5)
[  266.019641] EIP is at xfs_buf_cond_lock+0x8/0x1f [xfs]
[  266.024853] eax: 00000000   ebx: ce3e9100   ecx: 00000000   edx: 00000001
[  266.031768] esi: ccf8b628   edi: ccf8b5d8   ebp: d04beb20   esp: d04beb20
[  266.038692] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  266.044615] Process mount (pid: 7206, ti=d04be000 task=cdcb74f0 task.ti=d04be000)
[  266.052090] Stack: d04beb60 fdc75a12 00000005 fdc99174 00080020 00000000 ccf72c70 c992e5b0 
[  266.060680]        ccf8b6f0 00000007 c0875244 00000000 d04beb70 00080020 00000000 c992e5b0 
[  266.069247]        d04beb90 fdc75cd1 00080020 00000000 00002580 fdc8ccda c992e5f0 c992e5b0 
[  266.077866] Call Trace:
[  266.080611]  [<fdc75a12>] xlog_alloc_log+0x1b9/0x2cd [xfs]
[  266.086286]  [<fdc75cd1>] xfs_log_mount+0x6b/0xf1 [xfs]
[  266.091688]  [<fdc7ec47>] xfs_mountfs+0x959/0xc4a [xfs]
[  266.097097]  [<fdc714f6>] xfs_ioinit+0x26/0x2c [xfs]
[  266.102240]  [<fdc85692>] xfs_mount+0x2e5/0x358 [xfs]
[  266.107474]  [<fdc95b72>] vfs_mount+0x1a/0x1e [xfs]
[  266.112563]  [<fdc95a2c>] xfs_fs_fill_super+0x76/0x1a2 [xfs]
[  266.118433]  [<c0185987>] get_sb_bdev+0x105/0x143
[  266.123260]  [<fdc94d63>] xfs_fs_get_sb+0x21/0x27 [xfs]
[  266.128709]  [<c0185509>] vfs_kern_mount+0x81/0xf1
[  266.133589]  [<c0199b59>] do_mount+0x716/0x80d
[  266.138145]  [<c0199cd0>] sys_mount+0x80/0xb5
[  266.142595]  [<c01041d0>] syscall_call+0x7/0xb
[  266.147170]  [<b7fe6410>] 0xb7fe6410
[  266.150822]  =======================
[  266.154445] INFO: lockdep is turned off.
[  266.158411] Code: be 20 00 00 00 89 f2 29 c2 83 c8 ff 88 d1 d3 e0 29 de 89 f1 d3 e8 5b 5e 5d c3 55 89 e5 90 ff 40 7c 5d c3 55 89 e5 89 c1 31 c0 90 <ff> 09 79 07 8d 01 e8 d7 17 6c c2 83 f8 01 19 c0 f7 d0 83 e0 f0 
[  266.178534] EIP: [<fdc8e82a>] xfs_buf_cond_lock+0x8/0x1f [xfs] SS:ESP 0068:d04beb20
[  266.347522] XFS: Filesystem loop1 has duplicate UUID - can't mount
[  266.415823] XFS: Filesystem loop1 has duplicate UUID - can't mount
[  266.477997] XFS: Filesystem loop1 has duplicate UUID - can't mount
[  266.541940] XFS: Filesystem loop1 has duplicate UUID - can't mount

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/mm-dmesg3
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
