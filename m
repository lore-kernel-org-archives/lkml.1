Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXB1OQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXB1OQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932641AbXB1OQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:16:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbXB1OQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:16:34 -0500
Message-ID: <45E58EB8.6030502@redhat.com>
Date: Wed, 28 Feb 2007 09:16:24 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu>
In-Reply-To: <20070227231544.519463073@szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Changes:
>  o moved check from __fput() to remove_vma(), which is more logical
>  o changed set_page_dirty() to set_page_dirty_mapping in hugetlb.c
>  o cleaned up #ifdef CONFIG_BLOCK mess
>
>
> This patch makes writing to shared memory mappings update st_ctime and
> st_mtime as defined by SUSv3:
>
>    The st_ctime and st_mtime fields of a file that is mapped with
>    MAP_SHARED and PROT_WRITE shall be marked for update at some point
>    in the interval between a write reference to the mapped region and
>    the next call to msync() with MS_ASYNC or MS_SYNC for that portion
>    of the file by any process. If there is no such call and if the
>    underlying file is modified as a result of a write reference, then
>    these fields shall be marked for update at some time after the
>    write reference.
>
> A new address_space flag is introduced: AS_CMTIME.  This is set each
> time a page is dirtied through a userspace memory mapping.  This
> includes write accesses via get_user_pages().
>
> Note, the flag is set unconditionally, even if the page is already
> dirty.  This is important, because the page might have been dirtied
> earlier by a non-mmap write.
>
> This flag is checked in msync() and munmap()/mremap(), and if set, the
> file times are updated and the flag is cleared
>
> The flag is also cleared, if the time update is triggered by a normal
> write.  This is not mandated by the standard, but seems to be a sane
> thing to do.
>
> Fixes Novell Bugzilla #206431.
>
> Inspired by Peter Staubach's patch and the resulting comments.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

These change still have the undesirable property that although the
modified pages may be flushed to stable storage, the metadata on
the file will not be updated until the application takes positive
action.  This is permissible given the current wording in the
specifications, but it would be much more desirable if sync(2),
fsync(P), or the inode being written out due to normal system
activity would also cause the metadata to be updated.

Perhaps the setting of the flag could be checked in some places
like __sync_single_inode() and do_fsync()?

    Thanx...

       ps
