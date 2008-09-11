Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYIKK7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYIKK7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYIKK6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:58:53 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65459 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbYIKK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:58:52 -0400
Message-ID: <85FB1C9FF587411A99FF66E76008D2A6@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>,
       <viro@ZenIV.linux.org.uk>, <linux-ext4@vger.kernel.org>,
       <xfs@oss.sgi.com>, "Christoph Hellwig" <hch@infradead.org>,
       <axboe@kernel.dk>, <mtk.manpages@googlemail.com>,
       <linux-kernel@vger.kernel.org>
References: <20080818212819t-sato@mail.jp.nec.com> <48C012F3.3000408@redhat.com>
In-Reply-To: <48C012F3.3000408@redhat.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Thu, 11 Sep 2008 19:58:08 +0900
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

Eric Sandeen:
>> +static int ioctl_freeze(struct file *filp)
>> +{
>> +     struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
>> +
>> +     if (!capable(CAP_SYS_ADMIN))
>> +         return -EPERM;
>> +
>> +     /* If filesystem doesn't support freeze feature, return. */
>> +     if (sb->s_op->write_super_lockfs == NULL)
>> +         return -EOPNOTSUPP;
>> +
>> +     /* If a regular file or a directory isn't specified, return. */
>> +     if (sb->s_bdev == NULL)
>> +         return -EINVAL;
>> +
>> +     /* Freeze */
>> +     sb = freeze_bdev(sb->s_bdev);
>> +     if (IS_ERR(sb))
>> +         return PTR_ERR(sb);
>> +     return 0;
>> +}
>
> Not a problem with your patch exactly, but I was just wondering; you
> check here whether the sb returned from freeze_bdev is an ERR_PTR (as
> does lock_fs()) - but, freeze_bdev never returns an error, does it?
> ->write_super_lockfs is a void...
>
> It really seems that at least we should be able to handle IO errors on
> the freeze request, and tell the user "No, your filesystem was not
> frozen..."?
>
> Maybe I'll whip up a patch to see about propagating freeze errors up
> from the filesystems that implement it, unless I'm missing some reason
> not to do so...?

Right.
We should handle an IO error which occurs in write_super_lockfs.
I will change the write_super_lockfs's type to "int" so that it can return an error.
And I will consider returning an error of ext3_write_super_lockfs because
journal_flush() in ext3_write_super_lockfs() doesn't handle an IO error.

> Also, should this be checking for a NULL returned from freeze_bdev as
> well?  I guess this should never happen if we have a file open on which
> we are calling the ioctl ...

I think ioctl_freeze doesn't need to check NULL because it never happen
as you said.

Cheers, Takashi
