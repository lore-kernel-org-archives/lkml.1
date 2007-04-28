Return-Path: <linux-kernel-owner+w=401wt.eu-S1161155AbXD1SRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161155AbXD1SRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163299AbXD1SQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:16:01 -0400
Received: from holomorphy.com ([66.93.40.71]:59534 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163442AbXD1SOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:14:51 -0400
Date: Sat, 28 Apr 2007 11:15:23 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] hugetlbfs: add NULL check in hugetlb_zero_setup()
Message-ID: <20070428181523.GX31925@holomorphy.com>
References: <20070428071923.GB9545@APFDCB5C> <20070428145039.GX19966@holomorphy.com> <20070428161856.GA9662@APFDCB5C> <20070428162948.GA9717@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428162948.GA9717@APFDCB5C>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 01:29:48AM +0900, Akinobu Mita wrote:
> If hugetlbfs module_init() fails, hugetlbfs_vfsmount
> is not initialized and shmget() with SHM_HUGETLB flag will
> cause NULL pointer dereference.
> Cc: William Irwin <wli@holomorphy.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Index: 2.6-mm/fs/hugetlbfs/inode.c
> ===================================================================
> --- 2.6-mm.orig/fs/hugetlbfs/inode.c
> +++ 2.6-mm/fs/hugetlbfs/inode.c
> @@ -740,6 +740,9 @@ struct file *hugetlb_zero_setup(size_t s
>  	char buf[16];
>  	static atomic_t counter;
>  
> +	if (!hugetlbfs_vfsmount)
> +		return ERR_PTR(-ENOENT);
> +
>  	if (!can_do_hugetlb_shm())
>  		return ERR_PTR(-EPERM);

Putting some thought into this, the failure to set up the vfsmount
for shm should be reported noisily, the failure to register the
filesystem should be noticed so as not to oops later in the init
function (I guess one could panic() if he wanted to), and the
attempt at kern_mount() should be conditional on SysV IPC.

I'll take this check, which should be made no matter what, and do
a patch for the init function along the lines described above if
you don't do it yourself first. I don't need the patch credits, so
feel free to grab the free patch line if you want it.

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
