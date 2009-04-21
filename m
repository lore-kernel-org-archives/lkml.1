Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZDUFMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZDUFMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZDUFLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:11:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48761 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZDUFLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:11:51 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] check for frozen filesystems in the mmap path
Cc: kosaki.motohiro@jp.fujitsu.com,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49E7C323.9040805@redhat.com>
References: <49E7C323.9040805@redhat.com>
Message-Id: <20090421140045.F125.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 14:11:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c
> +++ linux-2.6/mm/memory.c
> @@ -1944,6 +1944,7 @@ static int do_wp_page(struct mm_struct *
>  		 * read-only shared pages can get COWed by
>  		 * get_user_pages(.write=1, .force=1).
>  		 */
> +		vfs_check_frozen(old_page->mapping->host->i_sb, SB_FREEZE_WRITE);
>  		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
>  			struct vm_fault vmf;
>  			int tmp;

it seems strage.

1. it seems to have a race

	CPU0				CPU1
	----------------------------------------------------
	do_wp_page
	 vfs_check_frozen
					ioctl_fsfreeze
					  freeze_bdev
					    __fsync_super
        process touch mem

vfs_check_frozen only wait to unfreeze, but not prevent new
new freeze request starting.


2. this logic kill multi thread application.

this logic mean mmap_sem grabbing until unfreeze.
it mean othrer thread in the same process can't page-fault although
it don't touch frozen-sb.
it seems strange.




