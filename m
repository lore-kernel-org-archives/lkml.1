Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYLEONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYLEONM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYLEOM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:12:57 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59622 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYLEOM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:12:56 -0500
Date: Fri, 5 Dec 2008 14:12:31 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@linux-foundation.org, bfields@fieldses.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from fh_to_dentry()/fh_to_parent()
 [ver #2]
In-Reply-To: <20081205133014.14725.79974.stgit@warthog.procyon.org.uk>
Message-ID: <Pine.LNX.4.64.0812051407130.25248@blonde.anvils>
References: <20081205133014.14725.79974.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, David Howells wrote:
> Returning NULL from fh_to_dentry() and fh_to_parent() is not permitted, so
> return -ESTALE instead.  exportfs_decode_fh() does not check for NULL, but
> will try to dereference it as IS_ERR() does not check for it.
> 
> The generic_fh_to_dentry() and generic_fh_to_parent() functions also no longer
> return NULL, but return -ESTALE instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: J. Bruce Fields <bfields@citi.umich.edu>

I think it's still wrong in shmem_fh_to_dentry(): you've fixed
the early return, but there'd be another return NULL if !inode?

Hugh

> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2055,7 +2055,7 @@ static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
>  	inum = (inum << 32) | fid->raw[1];
>  
>  	if (fh_len < 3)
> -		return NULL;
> +		return ERR_PTR(-ESTALE);
>  
>  	inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
>  			shmem_match, fid->raw);
> 
