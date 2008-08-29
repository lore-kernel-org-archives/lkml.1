Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYH2Jj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYH2Jj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYH2Ji7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:38:59 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:63738 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYH2Ji5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:38:57 -0400
Message-ID: <4DF7C90FADA442868BA3D4C269F96DBF@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>,
       <viro@ZenIV.linux.org.uk>, <linux-ext4@vger.kernel.org>,
       <xfs@oss.sgi.com>, "Christoph Hellwig" <hch@infradead.org>,
       <axboe@kernel.dk>, <mtk.manpages@googlemail.com>,
       <linux-kernel@vger.kernel.org>
References: <20080818212819t-sato@mail.jp.nec.com> <20080821125841.a04a706f.akpm@linux-foundation.org>
In-Reply-To: <20080821125841.a04a706f.akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Fri, 29 Aug 2008 18:36:56 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:
>> --- linux-2.6.27-rc2.org/include/linux/fs.h  2008-08-06 13:49:54.000000000 +0900
>> +++ linux-2.6.27-rc2-freeze/include/linux/fs.h       2008-08-07 08:59:54.000000000 +0900
>> @@ -226,6 +226,8 @@ extern int dir_notify_enable;
>>  #define BMAP_IOCTL 1                /* obsolete - kept for compatibility */
>>  #define FIBMAP         _IO(0x00,1)  /* bmap access */
>>  #define FIGETBSZ   _IO(0x00,2)      /* get the block size used for bmap */
>> +#define FIFREEZE    _IOWR('X', 119, int)    /* Freeze */
>> +#define FITHAW              _IOWR('X', 120, int)    /* Thaw */
>
>FIFREEZE is 119, but a few lines above we have
>
>#define BLKDISCARD _IO(0x12,119)
>
>Should we be using 120 and 121 here?

As Andreas said, we need to use 'X' to keep compatibility with
XFS's freeze ioctl.

>
>>  #define     FS_IOC_GETFLAGS                 _IOR('f', 1, long)
>>  #define     FS_IOC_SETFLAGS                 _IOW('f', 2, long)
>> @@ -574,6 +576,10 @@ struct block_device {
>>       * care to not mess up bd_private for that case.
>>       */
>>      unsigned long           bd_private;
>> +    /* The counter of freeze processes */
>> +    int                     bd_freeze_count;
>> +    /* Semaphore for freeze */
>> +    struct semaphore        bd_freeze_sem;
>
>"freeze" is not an adequate description of what this protects.  I think
>it's only the modification and testing of bd_freeze_count, isn't it?
>
>If so, all this could be done more neatly by removing the lock,
>switching to atomic_t and using our (rich) atomic_t operations.
>
>otoh, perhaps it protects more than this, in which case the lock
>can/should be switched to a `struct mutex'?

bd_freeze_sem protects the following two sequences.
1. freeze_bdev()
  - Test of bd_freeze_count
  - Increment of bd_freeze_count
  - s_op->write_super_lockfs
  - Set unfreeze timer

2. thaw_bdev()
  - Test of bd_freeze_count
  - Decrement of bd_freeze_count
  - s_op->unlockfs
  - Unset unfreeze timer
Because the journal sync in ext3's write_super_lockfs might
need a long time, we should use the mutex (not atomic_t).
If bd_freeze_sem protects only the modification and
testing of bd_freeze_count, freeze_bdev() and thaw_bdev() will
run simultaneously and unexpected problem will occur. 
(For example, after we run the freeze ioctl with timeout period,
the filesystem is frozen, but the unfreeze timer isn't set.)

Cheers, Takashi
