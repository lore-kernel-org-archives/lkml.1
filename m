Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbZHDTPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbZHDTPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbZHDTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:15:31 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60799 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359AbZHDTP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:15:28 -0400
Subject: Re: mnt_want_write_file() has problem?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, akpm <akpm@linuxfoundation.org>
In-Reply-To: <871vnt7vac.fsf@devron.myhome.or.jp>
References: <871vnt7vac.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 12:15:19 -0700
Message-Id: <1249413319.11056.131.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 06:36 +0900, OGAWA Hirofumi wrote:
> diff -puN fs/namespace.c~mnt_want_write-wrong-assume fs/namespace.c
> ---
> linux-2.6/fs/namespace.c~mnt_want_write-wrong-assume        2009-08-03
> 04:33:35.000000000 +0900
> +++ linux-2.6-hirofumi/fs/namespace.c   2009-08-03 04:31:34.000000000
> +0900
> @@ -316,7 +316,8 @@ EXPORT_SYMBOL_GPL(mnt_clone_write);
>   */
>  int mnt_want_write_file(struct file *file)
>  {
> -       if (!(file->f_mode & FMODE_WRITE))
> +       struct inode *inode = file->f_dentry->d_inode;
> +       if (!(file->f_mode & FMODE_WRITE) || special_file(inode->i_mode))
>                 return mnt_want_write(file->f_path.mnt);
>         else
>                 return mnt_clone_write(file->f_path.mnt);

I'm fine with this.  I'd like a debugging check in mnt_clone_write()
since this bug is easy to detect, but such a check will also cost all of
the performance gains that Nick added.  So, we can't have it
unconditionally.

-- 

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

