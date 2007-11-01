Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbXKAPPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbXKAPPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXKAPPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:15:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbXKAPPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:15:43 -0400
Date: Thu, 1 Nov 2007 08:14:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
In-Reply-To: <20071101023758.GA30613@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0711010809171.3342@woody.linux-foundation.org>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
 <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
 <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
 <20071031225541.GA28552@wotan.suse.de> <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org>
 <20071101023758.GA30613@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Nov 2007, Nick Piggin wrote:

> On Wed, Oct 31, 2007 at 04:08:21PM -0700, Linus Torvalds wrote:
> > 
> > We made much bigger changes to ptrace support when we disallowed writing 
> > to read-only shared memory areas (we used to do the magic per-page COW 
> > thing).
> 
> Really? No, we still do that magic COW thing which creates anonymous
> pages in MAP_SHARED vmas, don't we?

No, we don't. I'm pretty sure. It didn't work with the VM cleanups, since 
the MAP_SHARED vma's won't be on the anonymous list any more, and cannot 
be swapped out.

So now, if you try to write to a read-only shared page through ptrace, 
you'll get "Unable to access".

Of course, I didn't really look closely, so maybe I just don't remember 
things right..

> > access_vm_pages() (things like core-dumping comes to mind - although I 
> > think we don't dump pure file mappings at all, do we?) it would certainly 
> > be good to run any such tests on the current -git tree...
> 
> We do for MAP_SHARED|MAP_ANONYMOUS, by the looks.

Well, as we should. There's no way for a debugger to get those pages back. 
So that all looks sane.

> -			vm_flags |= VM_SHARED | VM_MAYSHARE;
> -			if (!(file->f_mode & FMODE_WRITE))
> -				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
> +			vm_flags |= VM_MAYSHARE;
> +			if (file->f_mode & FMODE_WRITE)
> +				vm_flags |= VM_SHARED;
> +			if (!(vm_flags & VM_WRITE))
> +				vm_flags &= ~VM_MAYWRITE;

This looks totally bogus. What was the intent of this patch?

The VM_MAYWRITE flag is *not* supposed to track the VM_WRITE flag: that 
would defeat the whole purpose of it! The whole point of that flag is to 
say whether mprotect() could turn it into a VM_WRITE mapping, and it 
depends on the file mode, not VM_WRITE!

>  			vm_flags |= VM_SHARED | VM_MAYSHARE;
> +			if (!(vm_flags & VM_WRITE))
> +				vm_flags &= ~VM_MAYWRITE;

More apparent bogosities.

		Linus
