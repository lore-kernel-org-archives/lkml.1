Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZCVU4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZCVU4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZCVU4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:56:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:60495 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZCVU4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
References: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
Date: Sun, 22 Mar 2009 13:56:37 -0700
Message-ID: <aca0ce8b0903221356w487dbbbdie6d5cb9a1862af57@mail.gmail.com>
Subject: Re: [PATCH next] sysfs: fix some bin_vm_ops errors
From: Eric Biederman <ebiederm@aristanetworks.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 11:33 AM, Hugh Dickins <hugh@veritas.com> wrote:
> Commit 86c9508eb1c0ce5aa07b5cf1d36b60c54efc3d7a
> "sysfs: don't block indefinitely for unmapped files" in linux-next
> crashes the PowerMac G5 when X starts up.  It's caught out by the way
> powerpc's pci_mmap of legacy_mem uses shmem_zero_setup(), substituting
> a new vma->vm_file whose private_data no longer points to the bin_buffer
> (substitution done because some versions of X crash if that mmap fails).
>
> The fix to this is straightforward: the original vm_file is fput() in
> that case, so this mmap won't block sysfs at all, so just don't switch
> over to bin_vm_ops if vm_file has changed.

That part is really weird but it looks reasonable.

> But more fixes made before realizing that was the problem:-
>
> It should not be an error if bin_page_mkwrite() finds no underlying
> page_mkwrite().

Likely.  The goal is to get the same behaviour as if mkwrite had not been
implemented.    Looking at the code clearly returning an error in
the version I am looking at does not meet the goal, and since I unmap
everything during a hot-unplug and rely on the fault handler I have
no problem with that change.

> Check that a file already mmap'ed has the same underlying vm_ops
> _before_ pointing vma->vm_ops at bin_vm_ops.

Checking that the underlying file is the same is good.  I know my original
reasoning was that using the original vm_ops would likely mess up error
handling if I used them.

> If the file being mmap'ed is a shmem/tmpfs file, don't fail the mmap
> on CONFIG_NUMA=y, just because that has a set_policy and get_policy.
> They probably won't be called, and it's not a disaster if they don't
> work on sysfs.  vm_ops->migrate?  I couldn't find any example.  Just
> delete CONFIG_NUMA tests, easy enough to add stubs later if required.

I agree about it being easy enough to add stubs later if required.  In my case
I deliberately added an error check instead so that the code would fail fast
instead of failing subtlely if anyone ever did that.  And that check appears to
have worked in your case so I would like to retain that check.

> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> I have only tested that X now starts up fine on the G5: I don't think
> I've messed up the intent of your patch, but not tested it still works.
>
>  fs/sysfs/bin.c |   18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> --- 2.6.29-rc8-next/fs/sysfs/bin.c      2009-03-20 12:41:45.000000000 +0000
> +++ linux/fs/sysfs/bin.c        2009-03-21 18:01:26.000000000 +0000
> @@ -241,9 +241,12 @@ static int bin_page_mkwrite(struct vm_ar
>        struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
>        int ret;
>
> -       if (!bb->vm_ops || !bb->vm_ops->page_mkwrite)
> +       if (!bb->vm_ops)
>                return -EINVAL;
>
> +       if (!bb->vm_ops->page_mkwrite)
> +               return 0;
> +
>        if (!sysfs_get_active_two(attr_sd))
>                return -EINVAL;
>
> @@ -287,7 +290,6 @@ static int mmap(struct file *file, struc
>        struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
>        struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
>        struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
> -       struct vm_operations_struct *vm_ops;
>        int rc;
>
>        mutex_lock(&bb->mutex);
> @@ -302,24 +304,20 @@ static int mmap(struct file *file, struc
>                goto out_put;
>
>        rc = attr->mmap(kobj, attr, vma);
> -       vm_ops = vma->vm_ops;
> -       vma->vm_ops = &bin_vm_ops;
>        if (rc)
>                goto out_put;
>
> -       rc = -EINVAL;
> -       if (bb->mmapped && bb->vm_ops != vma->vm_ops)
> +       if (vma->vm_file != file)
>                goto out_put;
>
> -#ifdef CONFIG_NUMA
>        rc = -EINVAL;
> -       if (vm_ops && ((vm_ops->set_policy || vm_ops->get_policy || vm_ops->migrate)))
> +       if (bb->mmapped && bb->vm_ops != vma->vm_ops)
>                goto out_put;
> -#endif
>
>        rc = 0;
>        bb->mmapped = 1;
> -       bb->vm_ops = vm_ops;
> +       bb->vm_ops = vma->vm_ops;
> +       vma->vm_ops = &bin_vm_ops;
>  out_put:
>        sysfs_put_active_two(attr_sd);
>  out_unlock:
>
