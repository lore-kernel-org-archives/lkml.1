Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYE0KUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYE0KUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYE0KUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:20:42 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:63940 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYE0KUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:20:40 -0400
Message-Id: <7654D29B4EC648FD8E32AB331941F941@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>, <dm-devel@redhat.com>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20080522175020t-sato@mail.jp.nec.com> <20080525193211.GA24328@infradead.org>
In-Reply-To: <20080525193211.GA24328@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Tue, 27 May 2008 19:20:11 +0900
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

>> +    if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
>> +        return ERR_PTR(-EBUSY);
>> +
>> +    sb = get_super_without_lock(bdev);
>> +
>> +    /* If super_block has been already frozen, return. */
>> +    if (sb && sb->s_frozen != SB_UNFROZEN) {
>> +        put_super(sb);
>> +       clear_bit(BD_FREEZE_OP, &bdev->bd_state);
>> +       return sb;
>> +    }
>
> The BD_FREEZE_OP flag in the block_device already prevents multiple
> freezes for a singe block device, so there is no need for this
> additional check and the get_super_without_lock helper.

I think the above check is needed because BD_FREEZE_OP is used to
guarantee that the following two operations are done atomically.
1. Check if the filesystem has already been frozen.
   (sb->s_frozen != SB_UNFROZEN)
2. Do the filesystem specific freeze operation
   (write_super_lockfs)

The freeze operation can be done again for the frozen filesystem
unless the filesystem is checked.
And if write_super_lockfs doesn't consider that the filesystem
has already been frozen, a problem might occur.

>>  down(&bdev->bd_mount_sem);
> 
> And with that flag bd_mount_sem is also obsolete for preventing the
> multiple freeze operations.  

bd_mount_sem is needed because it is used to guarantee that the freeze
operation never run while mounting (get_sb_bdev()).

> We still need investigate what
> synchronization we need vs unmount which also takes bd_mount_sem without
> every having document what it exactly protects.

And s_umount (semaphore) is acquired in get_user() (called by freeze_bdev())
to guarantee that unmount never run while the filesystem is frozen.

Cheers, Takashi
