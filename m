Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZBIIu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZBIIu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZBIIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:50:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64191 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZBIIuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:50:17 -0500
Message-ID: <498FEE24.5030407@cn.fujitsu.com>
Date: Mon, 09 Feb 2009 16:49:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, containers@lists.osdl.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cgroup or VFS ?]  WARNING: at fs/namespace.c:636 mntput_no_expire+0xac/0xf2()
References: <49617D35.4040805@cn.fujitsu.com> <20090209004046.3ce1dde0.akpm@linux-foundation.org>
In-Reply-To: <20090209004046.3ce1dde0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc's added)
> 
> On Mon, 05 Jan 2009 11:23:33 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Thread 1:
>>   for ((; ;))
>>   {
>>       mount -t cgroup -o cpuset xxx /mnt > /dev/null 2>&1
>>       mkdir /mnt/0 > /dev/null 2>&1
>>       rmdir /mnt/0 > /dev/null 2>&1
>>       umount /mnt > /dev/null 2>&1
>>   }
>>
>> Thread 2:
>>   for ((; ;))
>>   {
>>       mount -t cpuset xxx /mnt > /dev/null 2>&1
>>       umount /mnt > /dev/null 2>&1
>>   }
>>
>> (Note: Again it is irrelevant which cgroup subsys is used.)
>>
>> After a while this showed up:
>>
>> ------------[ cut here ]------------
>> WARNING: at fs/namespace.c:636 mntput_no_expire+0xac/0xf2()
>> Hardware name: Aspire SA85
>> Modules linked in: bridge stp llc autofs4 dm_mirror dm_region_hash dm_log dm_mod r8169 parport_pc mii parport sg button sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
>> Pid: 4745, comm: umount Not tainted 2.6.28 #479
>> Call Trace:
>>  [<c042bbe3>] warn_slowpath+0x79/0x8f
>>  [<c044babf>] ? __lock_acquire+0x69a/0x700
>>  [<c04ae44e>] ? mntput_no_expire+0x79/0xf2
>>  [<c04ae481>] mntput_no_expire+0xac/0xf2
>>  [<c04ae968>] sys_umount+0x26a/0x2b1
>>  [<c04ae9c1>] sys_oldumount+0x12/0x14
>>  [<c0403251>] sysenter_do_call+0x12/0x31
>> ---[ end trace 79d0ab4bef01333f ]---
>>
>> The WARNING is: WARN_ON(atomic_read(&mnt->__mnt_writers));
> 
> OK, I'm all confused.  Here we see a WARN_ON triggered, but in
> http://lkml.org/lkml/2009/1/4/352 with the same testcase we're seeing a
> lockdep warning.
> 

They are 2 testcases with small difference ;)

case 1:
mount
cat whichever control file
umount

case 2:
mount
mkdir /cgroup/0
rmdir /cgroup/0
umount

> You refer to Arjan's "lockdep: annotate sb ->s_umount" patch - but
> that's over two years old.
> 
> And you say "The changelog said s_umount needs to be classified as
> per-sb, but actually it made it as per-filesystem." But what is the
> difference between per-sb and per-fs?
> 

a filesystem can be single-sb or multile, isn't it? that's struct super_lock
and struct file_system_type. I may be wrong here, since I don't know
much about VFS...

> More info here: http://bugzilla.kernel.org/show_bug.cgi?id=12673
> 
> This bug report seems to be all over the place.
> 
> Is it a post-2.6.28 regression, btw?
> 

I think it was introduced since cgroup was introduced. But it's hard to trigger
in real-life, though it's easy using this test case.


