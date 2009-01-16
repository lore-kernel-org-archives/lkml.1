Return-Path: <linux-kernel-owner+w=401wt.eu-S1761746AbZAPDtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761746AbZAPDtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZAPDtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:49:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbZAPDti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:49:38 -0500
Message-ID: <497003CC.8030503@redhat.com>
Date: Thu, 15 Jan 2009 21:49:32 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
References: <496EB639.6090800@redhat.com> <20090115162031.a512232b.akpm@linux-foundation.org>
In-Reply-To: <20090115162031.a512232b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 14 Jan 2009 22:06:17 -0600
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> Now that the filesystem freeze operation has been elevated
>> to the VFS, and is just an ioctl away, some sort of safety net
>> for unintentionally frozen root filesystems may be in order.
>>
>> The timeout thaw originally proposed did not get merged, but
>> perhaps something like this would be useful in emergencies.
>>
>> This doesn't have to piggyback on the existing emergency sync
>> sysrq, but it seems like a reasonable, simple addition to me.
>>
>> I've tested this on a non-root fs with multiple (nested) freezers,
>> as well as on a system rendered unresponsive due to a frozen
>> root fs.
> 
> Worried.
> 
> Under what operational scenarios is ths feature actually needed/used?

Well, if you freeze root and do some things that require IO there, you
can get stuck pretty easily

(hacked xfs_io to call the ioctl here)

[root@inode io]# ./xfs_io -r -x -F -c "freeze" /
[root@inode io]# ls
^Z
^C
<tap tap.. uhoh>

>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Index: linux-2.6/drivers/char/sysrq.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/char/sysrq.c
>> +++ linux-2.6/drivers/char/sysrq.c
>> @@ -151,6 +151,7 @@ static struct sysrq_key_op sysrq_reboot_
>>  
>>  static void sysrq_handle_sync(int key, struct tty_struct *tty)
>>  {
>> +	emergency_thaw();
>>  	emergency_sync();
>>  }
> 
> Kind of weird.   The thaw will happen after/during the sync().

oh, hrm.  Maybe I didn't think enough about how it's handed off to
pdflush; I could rearrange if that makes sense?  Or maybe handing to
pdflush is wrong, it was just so convenient....

> I guess that if the sync is blocked on a frozen fs then things will
> sort themselves out.
> 
> otoh, if all the pdflush threads are blocked on frozen filesystems
> (possible?) then the emergency_thaw() simply won't do anything.

Hm, maybe possible... I'll have to think about that.

Thanks,
-Eric

>> ===================================================================
>> --- linux-2.6.orig/fs/buffer.c
>> +++ linux-2.6/fs/buffer.c
>> @@ -258,6 +258,29 @@ struct super_block *freeze_bdev(struct b
>>  }
>>  EXPORT_SYMBOL(freeze_bdev);
>>  
>> +void do_thaw(unsigned long unused)
>> +{
>> +	struct super_block *sb;
>> +	char b[BDEVNAME_SIZE];
>> +
>> +	list_for_each_entry(sb, &super_blocks, s_list) {
>> +		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
>> +			printk(KERN_WARNING "Emergency Thaw on %s\n",
>> +			       bdevname(sb->s_bdev, b));
> 
> hm, I made the args to bdevname() backwards.  Bad me.
> 
>> +	}
>> +	printk(KERN_WARNING "Emergency Thaw complete\n");
>> +}
> 

