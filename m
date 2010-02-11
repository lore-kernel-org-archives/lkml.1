Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0BKJb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:31:57 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34108 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0BKJb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:31:56 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B7344A4.1030607@kernel.org> (message from Tejun Heo on Thu, 11
	Feb 2010 08:43:32 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org>
Message-Id: <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 10:31:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Tejun Heo wrote:
> > If there's a pattern there, we might make the sharing/non-sharing
> > automated, and greatly simplify the interface.
> 
> Isn't the interface pretty simple as it is?

On one hand it's simple, on the other it has pretty weird limitations,
considering that server side mmap shouldn't be mandatory.  But of
course if server side mmap isn't used, then the SHMLBA limitation is
not necessary anymore so the implementation could choose an arbitrary
"offset".

My biggest gripe with the kernel API is that we shouldn't be calling
that thing in fuse_mmap_out an offset at all, because it's not and
it's confusing (like making you set vma->vm_pgoff to that value, which
is bogus).  Adding a separate "page_id" or whatever would make me
happy.

And if the server wants to mmap /dev/fuse then it can do that and send
the result in "dev_offset", to make it clear that it's a different
offset from the one the client used on the mmap.  And it can even use
that value as page_id, if it wants to or it can use a different
page_id.

Does that sound reasonable?

>  If we want to make it
> easier for API users by imposing limits, I think the correct layer to
> do that would be at the library level.

Hmm, might do that.  High level library users definitely shouldn't be
having to mess around with SHMLBA.

Thanks,
Miklos
