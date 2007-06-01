Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbXFABBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbXFABBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXFABBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:01:31 -0400
Received: from mail.suse.de ([195.135.220.2]:39068 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbXFABBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:01:31 -0400
Date: Fri, 1 Jun 2007 03:01:29 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601010129.GA15878@wotan.suse.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531231354.GR20632@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 04:13:54PM -0700, Mark Fasheh wrote:
> On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
> >  git-ocfs2.patch
> 
> Andrew, thanks for getting that back in there.
> 
> 
> mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch broke ocfs2 shared
> writable mmap. We hang on a page lock because ->page_mkwrite() is
> being called with the page already locked:
> 
> +	/*
> +	 * For consistency in subsequent calls, make the nopage_page always
> +	 * locked.
> +	 */
> +	if (unlikely(!(vma->vm_flags & VM_CAN_INVALIDATE)))
> +		lock_page(nopage_page);
> 
> It wasn't previously being called with the page lock held, intentionally.

Ah, I didn't realise you were using that yet. I expect ocfs2 is using
VM_CAN_INVALIDATE there anyway.

Hmm, this becomes easier to deal with after page_mkwrite is merged with
->fault. But for now, can we just lock the page at the do_wp_page site
as well, and change the API? All users I have seen want the page locked
there anyway...

