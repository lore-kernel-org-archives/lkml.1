Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXEPMHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXEPMHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbXEPMH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:07:29 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:24707 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755902AbXEPMH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:07:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=AkUJAT19q8D8RkWTCkxGoSH4kmVLOst5Ink8MQ49YR7w4ua7QLP2ZdPAwZ4ARzyiIYFIUUUViaUoSs/hzs+/XAFvZkE+vqKrvh5Sudkm7z40ViP5QUDS7OTIl3OYZXImwmXCae3sS7SrIAFEf9a6enff1dKcNdCihNA3BaNydeY=  ;
X-YMail-OSG: YCxCvIAVM1l7trfkRH2tYpb3qj8AdudP8aL5qJSSGdd1dtVaGCP41JUgP4.LiNx0N1jjexvyhQ--
Message-ID: <464AF3F3.30204@yahoo.com.au>
Date: Wed, 16 May 2007 22:07:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
References: <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Implement shared-writable mmap for AFS.
> 
> The key with which to access the file is obtained from the VMA at the point
> where the PTE is made writable by the page_mkwrite() VMA op and cached in the
> affected page.
> 
> If there's an outstanding write on the page made with a different key, then
> page_mkwrite() will flush it before attaching a record of the new key.
> 
> [try #2] Only flush the page if the page is still part of the mapping (truncate
> may have discarded it).

Couple more issues...

> Signed-off-by: David Howells <dhowells@redhat.com>

> +/*
> + * notification that a previously read-only page is about to become writable
> + * - if it returns an error, the caller will deliver a bus error signal
> + *
> + * we use this to make a record of the key with which the writeback should be
> + * performed and to flush any outstanding writes made with a different key
> + *
> + * the key to be used is attached to the file pinned by the VMA
> + */
> +int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(vma->vm_file->f_mapping->host);
> +	struct key *key = vma->vm_file->private_data;
> +	int ret;
> +
> +	_enter("{{%x:%u},%x},{%lx}",
> +	       vnode->fid.vid, vnode->fid.vnode, key_serial(key), page->index);
> +
> +	lock_page(page);
> +	if (page->mapping == vma->vm_file->f_mapping)
> +		ret = afs_prepare_write(vma->vm_file, page, 0, 0);

I would strongly suggest you used (0, PAGE_CACHE_SIZE) for the range, and
have your nopage function DTRT.

Minor issue: you can just check for `if (!page->mapping)` for truncation,
which is the usual signal to tell the reader you're checking for truncate.
Then you can remove the comment...


> +	else
> +		ret = 0; /* seems truncate interfered - let the caller deal
> +			  * with it (presumably the PTE changed too) */

Rather than add this (not always correct) comment about the VM workings, I'd
just add a directive in the page_mkwrite API documentation that the filesystem
is to return 0 if the page has been truncated.


> +	unlock_page(page);
> +
> +	_leave(" = %d", ret);
> +	return ret;
> +}

-- 
SUSE Labs, Novell Inc.
