Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXB1RW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXB1RW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933244AbXB1RW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:22:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933236AbXB1RWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:22:55 -0500
Message-ID: <45E5BA2E.8060003@redhat.com>
Date: Wed, 28 Feb 2007 12:21:50 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com> <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> These change still have the undesirable property that although the
>> modified pages may be flushed to stable storage, the metadata on
>> the file will not be updated until the application takes positive
>> action.  This is permissible given the current wording in the
>> specifications, but it would be much more desirable if sync(2),
>> fsync(P), or the inode being written out due to normal system
>> activity would also cause the metadata to be updated.
>>
>> Perhaps the setting of the flag could be checked in some places
>> like __sync_single_inode() and do_fsync()?
>>     
>
> I don't see the point in updating the timestamp from these functions.
>
> The file isn't _modified_ by sync() or fsync().  Just as it's not
> modified by stat().
>
> sync() and fsync() do cache->disk, while the file itself stays the
> same.
>
> OTOH msync(MS_ASYNC) does memory->file, which is a conceptually file
> modifying operation.  OK, msync(MS_ASYNC) is actually a no-op on
> 2.6.18+, but that's purely an implementation detail and no application
> should be relying on it.
>
> Before 2.6.18 sync() or fsync() acually didn't flush data written
> through a shared mapping to disk, only msync(MS_SYNC), because the
> dirty state was only available in the page tables, not in the page or
> the inode.

While these entry points do not actually modify the file itself,
as was pointed out, they are handy points at which the kernel gains
control and could actually notice that the contents of the file are
no longer the same as they were, ie. modified.

 From the operating system viewpoint, this is where the semantics of
modification to file contents via mmap differs from the semantics of
modification to file contents via write(2).

It is desirable for the file times to be updated as quickly as
possible after the actual modification has occurred.  However, this
can only happen when the kernel has a chance to gain control and
either look or notice that a page has been modified.

---

A better design for all of this would be to update the file times
and mark the inode as needing to be written out when a page fault
is taken for a page which either does not exist or needs to be made
writable and that page is part of an appropriate style mapping.

       ps
