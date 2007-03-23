Return-Path: <linux-kernel-owner+w=401wt.eu-S2992610AbXCWWsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992610AbXCWWsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992611AbXCWWsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:48:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:31249 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992610AbXCWWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GSgHK0cmTz5eUV2RMJ8ls2pOuGskUrJmLGbe5sg2pxTThOg3rr8myEvU1DS6/0dV00zn4ulxRQ0Sdo0Z/Ezgulj1dvlRTFS633hY3BSXNYEx3+tBc7YGw/008NRsf+FQ+tw732yvua3yLdPomVDU/+hAHVRqIsChxM7QE8sXrL4=
Message-ID: <29495f1d0703231548k377e3f8ds5f2ae529c34e4380@mail.gmail.com>
Date: Fri, 23 Mar 2007 15:48:05 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Ken Chen" <kenchen@google.com>
Subject: Re: [patch 1/2] hugetlb: add resv argument to hugetlb_file_setup
Cc: "Adam Litke" <agl@us.ibm.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Ken Chen <kenchen@google.com> wrote:
> rename hugetlb_zero_setup() to hugetlb_file_setup() to better match
> function name convention like shmem implementation.  Also add an
> argument to the function to indicate whether file setup should reserve
> hugetlb page upfront or not.
>
> Signed-off-by: Ken Chen <kenchen@google.com>
>
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 8c718a3..981886f 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -734,7 +734,7 @@ static int can_do_hugetlb_shm(void)
>                         can_do_mlock());
>  }
>
> -struct file *hugetlb_zero_setup(size_t size)
> +struct file *hugetlb_file_setup(size_t size, int resv)
>  {
>         int error = -ENOMEM;
>         struct file *file;
> @@ -771,7 +771,7 @@ struct file *hugetlb_zero_setup(size_t s
>                 goto out_file;
>
>         error = -ENOMEM;
> -       if (hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
> +       if (resv && hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
>                 goto out_inode;
>
>         d_instantiate(dentry, inode);
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 3f3e7a6..55cccd8 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -163,7 +163,7 @@ static inline struct hugetlbfs_sb_info *
>
>  extern const struct file_operations hugetlbfs_file_operations;
>  extern struct vm_operations_struct hugetlb_vm_ops;
> -struct file *hugetlb_zero_setup(size_t);
> +struct file *hugetlb_file_setup(size_t, int);
>  int hugetlb_get_quota(struct address_space *mapping);
>  void hugetlb_put_quota(struct address_space *mapping);
>
> @@ -185,7 +185,7 @@ #else /* !CONFIG_HUGETLBFS */
>
>  #define is_file_hugepages(file)                0
>  #define set_file_hugepages(file)       BUG()
> -#define hugetlb_zero_setup(size)       ERR_PTR(-ENOSYS)
> +#define hugetlb_file_setup(size, resv) ERR_PTR(-ENOSYS)
>
>  #endif /* !CONFIG_HUGETLBFS */
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 4fefbad..c64643f 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -366,7 +366,7 @@ static int newseg (struct ipc_namespace
>
>         if (shmflg & SHM_HUGETLB) {
>                 /* hugetlb_zero_setup takes care of mlock user accounting */
> -               file = hugetlb_zero_setup(size);
> +               file = hugetlb_file_setup(size, 1);

Comment needs updating too.

Thanks,
Nish
