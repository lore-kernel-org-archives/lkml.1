Return-Path: <linux-kernel-owner+w=401wt.eu-S1767203AbXCILmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767203AbXCILmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767206AbXCILmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:42:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767203AbXCILma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:42:30 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070309073711.7105B180063@magilla.sf.frob.com> 
References: <20070309073711.7105B180063@magilla.sf.frob.com> 
To: Roland McGrath <roland@redhat.com>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] utrace: nommu fixup support utrace 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 09 Mar 2007 11:41:44 +0000
Message-ID: <29185.1173440504@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Roland McGrath <roland@redhat.com> wrote:

> What I meant to suggest is that I would start from a safety point of view
> with get_user_pages/access_process_vm refusing to do force&&write to
> MAP_PRIVATE pages that are in fact being shared (ETXTBSY or something).

That's a good idea.  The other possibility I've thought of is maintaining a
list of the changes made to such a region and deapplying them / reapplying
them as the processes get scheduled.  That's probably fine as long as it's
just a few breakpoints and it's a single-CPU system.

But this is irrelevant as it doesn't address the sharing-prevention issue.

> (When it's not being shared, it should do whatever is necessary to make sure
> that page is known dirty and not hand it out for later mappings.)

NOMMU doesn't with pages at this level, but deals with regions of memory
instead.  A mapping may be part of a page, a whole page, or several pages.
NOMMU private file mmap() allocates using kmalloc(), so if you allocate a
1-byte buffer, that's all you're guaranteed to get.

As it happens, when the code sees PT_PTRACED, the VMA is marked as being
unshareable by the simple expedient of turning off VM_MAYSHARE, meaning that it
neither shares with already existing mappings, nor will it be shareable by
mappings that have yet to be made - even within the same process.

> Then you can go about trying to make the safe (no sharing) case come about
> when you want it.

Which brings us back to the if-statement you objected to.  Its presence is
still required so as to prevent sharing of the executable and loader, and this
seems a good a way to do it as any as far as I can see.  Remember that it has
be controlled by something that can be set before the binfmt load_binary() op
runs.

David
