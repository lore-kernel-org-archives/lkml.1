Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbZBIIlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbZBIIlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZBIIle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:41:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbZBIIld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:41:33 -0500
Date: Mon, 9 Feb 2009 00:40:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, containers@lists.osdl.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cgroup or VFS ?]  WARNING: at fs/namespace.c:636
 mntput_no_expire+0xac/0xf2()
Message-Id: <20090209004046.3ce1dde0.akpm@linux-foundation.org>
In-Reply-To: <49617D35.4040805@cn.fujitsu.com>
References: <49617D35.4040805@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Mon, 05 Jan 2009 11:23:33 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Thread 1:
>   for ((; ;))
>   {
>       mount -t cgroup -o cpuset xxx /mnt > /dev/null 2>&1
>       mkdir /mnt/0 > /dev/null 2>&1
>       rmdir /mnt/0 > /dev/null 2>&1
>       umount /mnt > /dev/null 2>&1
>   }
> 
> Thread 2:
>   for ((; ;))
>   {
>       mount -t cpuset xxx /mnt > /dev/null 2>&1
>       umount /mnt > /dev/null 2>&1
>   }
> 
> (Note: Again it is irrelevant which cgroup subsys is used.)
> 
> After a while this showed up:
> 
> ------------[ cut here ]------------
> WARNING: at fs/namespace.c:636 mntput_no_expire+0xac/0xf2()
> Hardware name: Aspire SA85
> Modules linked in: bridge stp llc autofs4 dm_mirror dm_region_hash dm_log dm_mod r8169 parport_pc mii parport sg button sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
> Pid: 4745, comm: umount Not tainted 2.6.28 #479
> Call Trace:
>  [<c042bbe3>] warn_slowpath+0x79/0x8f
>  [<c044babf>] ? __lock_acquire+0x69a/0x700
>  [<c04ae44e>] ? mntput_no_expire+0x79/0xf2
>  [<c04ae481>] mntput_no_expire+0xac/0xf2
>  [<c04ae968>] sys_umount+0x26a/0x2b1
>  [<c04ae9c1>] sys_oldumount+0x12/0x14
>  [<c0403251>] sysenter_do_call+0x12/0x31
> ---[ end trace 79d0ab4bef01333f ]---
> 
> The WARNING is: WARN_ON(atomic_read(&mnt->__mnt_writers));

OK, I'm all confused.  Here we see a WARN_ON triggered, but in
http://lkml.org/lkml/2009/1/4/352 with the same testcase we're seeing a
lockdep warning.

You refer to Arjan's "lockdep: annotate sb ->s_umount" patch - but
that's over two years old.

And you say "The changelog said s_umount needs to be classified as
per-sb, but actually it made it as per-filesystem." But what is the
difference between per-sb and per-fs?

More info here: http://bugzilla.kernel.org/show_bug.cgi?id=12673

This bug report seems to be all over the place.

Is it a post-2.6.28 regression, btw?
