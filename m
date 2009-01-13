Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbZAMGUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbZAMGUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZAMGTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:19:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:55604 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZAMGTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OcgWlYWa3hP8uK+8GFHS3paHGvrfn7xhiS4FO9BoT1qIxDiaES0qbkN67hOX0q5QBJ
         P93OWXvVeExREbaM68ZieeR42xQiTsPrD4A9yCFV6gZyOFVIoHKQPujv5x/YW5KeA9o3
         +BLBO82+Y0o/sp0lYBvCXKfPhsnm1ILSRjUJE=
MIME-Version: 1.0
In-Reply-To: <20090112155458.d254ac5a.akpm@linux-foundation.org>
References: <1231266334.21895.25.camel@pc1117.cambridge.arm.com>
	 <20090112155458.d254ac5a.akpm@linux-foundation.org>
Date: Tue, 13 Jan 2009 14:19:49 +0800
Message-ID: <91b13c310901122219l3d166403nf3aea016a036ec8a@mail.gmail.com>
Subject: Re: Minor kmemleak report via bdev_cache_init
From: Cheng Renquan <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 7:54 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 06 Jan 2009 18:25:34 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:


>
>> Hi Denis,
>>
>> With the commit c2acf7b908217 (fs/block_dev.c: __read_mostly improvement
>> and sb_is_blkdev_sb utilization), the bd_mnt is only local and kmemleak
>> reports the corresponding vfsmnt structure as unreferenced (together
>> with the duplicated name) since it can no longer track a valid pointer
>> to it:
>>
>> unreferenced object 0xdf813848 (size 128):
>>   comm "swapper", pid 0, jiffies 4294937384
>>   backtrace:
>>     [<c00872c0>] kmemleak_alloc+0x144/0x27c
>>     [<c00848c8>] kmem_cache_alloc+0x108/0x13c
>>     [<c009fc00>] alloc_vfsmnt+0x20/0x144
>>     [<c008bc34>] vfs_kern_mount+0x30/0xac
>>     [<c008bccc>] kern_mount_data+0x1c/0x20
>>     [<c00104a8>] bdev_cache_init+0x54/0x90
>>     [<c000fd7c>] vfs_caches_init+0xfc/0x128
>>     [<c0008984>] start_kernel+0x1f8/0x254
>> unreferenced object 0xdf8033d0 (size 32):
>>   comm "swapper", pid 0, jiffies 4294937384
>>   backtrace:
>>     [<c00872c0>] kmemleak_alloc+0x144/0x27c
>>     [<c0085e10>] __kmalloc_track_caller+0x15c/0x194
>>     [<c0071704>] kstrdup+0x3c/0x58
>>     [<c009fc5c>] alloc_vfsmnt+0x7c/0x144
>>     [<c008bc34>] vfs_kern_mount+0x30/0xac
>>     [<c008bccc>] kern_mount_data+0x1c/0x20
>>     [<c00104a8>] bdev_cache_init+0x54/0x90
>>     [<c000fd7c>] vfs_caches_init+0xfc/0x128
>>     [<c0008984>] start_kernel+0x1f8/0x254
>>
>> Can this object be freed (as below) or should I just tell kmemleak to
>> ignore it (or is it referenced and that's a kmemleak false positive)?
>>
>>
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 349a26c..78e469c 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -344,6 +344,7 @@ void __init bdev_cache_init(void)
>>       if (IS_ERR(bd_mnt))
>>               panic("Cannot create bdev pseudo-fs");
>>       blockdev_superblock = bd_mnt->mnt_sb;   /* For writeback */
>> +     free_vfsmnt(bd_mnt);
>>  }


>
> hm, yes, well, we might be able to get away with that - the kernel
> holds onto bd_mnt->mnt_sb for internal use for all time, but we don't
> directly use that vfsmount for anything after we've constructed
> blockdev_superblock.
>
> However there might well be things under blockdev_superblock which point
> back at this vfsmount - dunno, I didn't check.

I've checked that, the blockdev_superblock doesn't have a back pointer
to vfsmount indeed, and can never use vfsmount anymore, although
generally it needs more testing.

Acked-by: Cheng Renquan <crquan@gmail.com>

To Al Viro: by this checking I found more vfsmount's not used, too, in
some other kern_mount'ed vfsmount, such as pipefs, sockfs, ipc mqueue,
selinux, smackfs, besides bdevfs, in such situations also only
superblock is used, the vfsmount only used as kern_mount and never
used anymore.
So maybe we can do some more cleanup. Patches will be sent later.

-- 
Denis, Cheng Renquan (程任全), Shenzhen, China
Bob Hope  - "I grew up with six brothers. That's how I learned to
dance - waiting for the bathroom."
