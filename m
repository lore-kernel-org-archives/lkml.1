Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbXEPAcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbXEPAcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbXEPAcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:32:25 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:32092 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759439AbXEPAcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:32:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=mbgQ+W+TFKxLW/xnYTOSiVbSVIcyymtlE0miqn9IGz3DxFPSr01rwLRfj4QUu6P06v9PPhXAV01GFCu+nHyra5v8fiJHs5wtXFVmCouHbaffEuqh6EkmsMg8+Sl7WWG+UjFrpPM3vhNR2HNkkKWN6STOQoeNCZ1XZ9I3wr7GzSg=  ;
X-YMail-OSG: Cm9Fs6sVM1lTPBA.SG8ez5t3rWQJLnPJTAVtyeZy4C7UxXcH8c.A6n7TUyKSjWPakZei3IEN.w--
Message-ID: <464A5113.5080907@yahoo.com.au>
Date: Wed, 16 May 2007 10:32:19 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com> <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
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

Good, will be nice to get a page_mkwrite() user in the tree.



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
> +	ret = afs_prepare_write(vma->vm_file, page, 0, 0);
> +	unlock_page(page);
> +
> +	_leave(" = %d", ret);
> +	return ret;
> +}

By the looks of afs_prepare_write, it is going to go bang when the page
gets truncated before lock_page.

Checking page->mapping after lock_page should do the trick.

-- 
SUSE Labs, Novell Inc.
