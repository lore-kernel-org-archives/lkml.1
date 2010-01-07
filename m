Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693Ab0AGVXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0AGVXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509Ab0AGVXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:23:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0AGVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:23:33 -0500
Message-ID: <4B4650CA.4010703@redhat.com>
Date: Thu, 07 Jan 2010 16:23:22 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
References: <1262896174.2659.3.camel@localhost> <87zl4pmxzp.fsf@basil.nowhere.org>
In-Reply-To: <87zl4pmxzp.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Hi Linus,
>>
>> Please pull from the "bugfixes" branch of the repository at
>>
>>    git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git bugfixes
>>
>> This will update the following files through the appended changesets.
> 
> How about the mmap lock order inversion patch?
> 
> That problem is still there and hits immediately after mounting root 
> with a lockdep warning on any lockdep enabled NFS root kernel.
> 

It seems to me that NFS must do some sort of validation at
this point.  This is one of the last points where the NFS
client can do validation for mmap'd files.

Simply crossing our fingers probably won't be sufficient.  :-)

I think that the file system must have a way to do validation
and page invalidation during mmap.  Perhaps we can reorder
things or add another entry point which is invoked after the
page mapping is set up which would give the file system to
check to ensure that the page cache is filled with valid data.

		ps

> -Andi
> 
> ---
> 
> NFS: don't revalidate in mmap
> 
> nfs_revalidate_mapping takes i_mutex, but mmap already has mmap_sem
> hold and taking i_mutex inside mmap_sem is not allowed by the VFS.
> 
> So don't revalidate on mmap time and trust it has been already done.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  fs/nfs/file.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> Index: linux-2.6.32-ak/fs/nfs/file.c
> ===================================================================
> --- linux-2.6.32-ak.orig/fs/nfs/file.c
> +++ linux-2.6.32-ak/fs/nfs/file.c
> @@ -297,14 +297,9 @@ nfs_file_mmap(struct file * file, struct
>  	dprintk("NFS: mmap(%s/%s)\n",
>  		dentry->d_parent->d_name.name, dentry->d_name.name);
>  
> -	/* Note: generic_file_mmap() returns ENOSYS on nommu systems
> -	 *       so we call that before revalidating the mapping
> -	 */
>  	status = generic_file_mmap(file, vma);
> -	if (!status) {
> +	if (!status)
>  		vma->vm_ops = &nfs_file_vm_ops;
> -		status = nfs_revalidate_mapping(inode, file->f_mapping);
> -	}
>  	return status;
>  }
>  
> 
> 

