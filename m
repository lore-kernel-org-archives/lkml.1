Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYIPP1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYIPP1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYIPP1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:27:30 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:45078 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155AbYIPP13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:27:29 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] vfs: added better file aio_read aio_write operations presence check
To: Manish Katiyar <mkatiyar@gmail.com>,
       Marco Stornelli <marco.stornelli@coritel.it>, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 16 Sep 2008 17:36:09 +0200
References: <bcF2N-29W-1@gated-at.bofh.it> <bcGBv-4eJ-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Kfcb3-0003ra-Q7@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manish Katiyar <mkatiyar@gmail.com> wrote:
> On Tue, Sep 16, 2008 at 2:59 PM, Marco Stornelli
>> From: Marco Stornelli <marco.stornelli@gmail.com>

>> If a filesystem in the file operations specifies for read and write
>> operations only do_sync_read and do_sync_write without init aio_read and
>> aio_write, there will be a kernel oops, because the vfs code check the
>> presence of (to read for example) read OR aio_read method, then it calls read
>> if it's pointer is not null. It's not sufficient because if the read function
>> is actually a do_sync_read, it calls aio_read but without checking the
>> presence. I think a BUG_ON check can be more useful.
> 
> Instead of doing a BUG_ON() why can't we simply fall back to the
> generic_aio functions since most of the fs tend to do so as below.

> --- a/fs/read_write.c

> -             ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
> +             if (filp->f_op->aio_read)
> +                     ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
> +             else
> +                     ret = generic_file_aio_read(&kiocb, &iov, 1, kiocb.ki_pos);

Why can't the file system registration code set filp->f_op->aio_read to
generic_file_aio_read?

