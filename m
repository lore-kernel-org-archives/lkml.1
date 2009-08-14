Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZHNNMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZHNNMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZHNNMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:12:23 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:33994 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZHNNMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:12:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/11] fat: cleanup fat_put_super()
References: <20090814122657.114987508@linutronix.de>
	<20090814123548.213452171@linutronix.de>
Date: Fri, 14 Aug 2009 22:12:18 +0900
In-Reply-To: <20090814123548.213452171@linutronix.de> (Thomas Gleixner's
	message of "Fri, 14 Aug 2009 12:42:44 -0000")
Message-ID: <87tz0ao7yl.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> unload_nls() can be called with a NULL pointer now. Remove the pointer
> checks and the NULLification of the pointers as the data structure
> which contains the pointers is kfree'd right away.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/fat/inode.c |   16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
>
> Index: linux-2.6-tip/fs/fat/inode.c
> ===================================================================
> --- linux-2.6-tip.orig/fs/fat/inode.c
> +++ linux-2.6-tip/fs/fat/inode.c
> @@ -470,19 +470,11 @@ static void fat_put_super(struct super_b
>  
>  	iput(sbi->fat_inode);
>  
> -	if (sbi->nls_disk) {
> -		unload_nls(sbi->nls_disk);
> -		sbi->nls_disk = NULL;
> -		sbi->options.codepage = fat_default_codepage;
> -	}
> -	if (sbi->nls_io) {
> -		unload_nls(sbi->nls_io);
> -		sbi->nls_io = NULL;
> -	}
> -	if (sbi->options.iocharset != fat_default_iocharset) {
> +	unload_nls(sbi->nls_disk);
> +	unload_nls(sbi->nls_io);

I don't object to this, however, personally I'd prefer to check NULL
explicitly, including brelse().

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
