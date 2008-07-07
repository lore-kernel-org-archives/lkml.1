Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYGGRtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYGGRtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYGGRtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:49:40 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51365 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYGGRtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:49:39 -0400
Date: Mon, 7 Jul 2008 18:48:51 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: carsteno@de.ibm.com
cc: Nick Piggin <nickpiggin@yahoo.com.au>, benh@kernel.crashing.org,
       Zan Lynx <zlynx@acm.org>, Ryan Hope <rmh3093@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
In-Reply-To: <487239BE.8070505@de.ibm.com>
Message-ID: <Pine.LNX.4.64.0807071846400.32514@blonde.site>
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
 <486E4FD8.4010102@acm.org> <Pine.LNX.4.64.0807042112130.16912@blonde.site>
 <200807071806.11630.nickpiggin@yahoo.com.au> <487239BE.8070505@de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Carsten Otte wrote:
> Nick Piggin wrote:
> > I think we need a similar fix for s390 too. If so, then it really should
> > get into 2.6.26, but this late in the release, I hope an s390 maintainer
> > might be able to test and verify the fix?
> 
> I've done my best to combine mprotect, mmap and munmap a MAP_PRIVATE mapping
> on a xip file system. The system runs stable with and without this patch.
> Could someone please enlighten me on how to reproduce the problem so that I
> can verify the fix?

Though it would be more obvious to use a MAP_SHARED mapping, we had that
earlier thread in which it emerged that you're not using shared writable
xip mappings, IIRC.  So, sticking to MAP_PRIVATE, I'd expect the following
sequence

ptr = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, xip_fd, 0);
var = *ptr;
mprotect(ptr, PAGE_SIZE, PROT_NONE);
munmap(ptr, PAGE_SIZE);

to do a put_page on a non-existent struct page derived from the pfn:
perhaps corrupting other memory without being noticed?  Or if
you have CONFIG_DEBUG_VM=y (that would be a good move), to hit
vm_normal_page's VM_BUG_ON(!pfn_valid(pte_pfn(pte))) before that.

(I think you can just as well use PROT_READ|PROT_WRITE rather than
PROT_NONE there, but in principle mprotect could optimize away that
pte modification - though I think it goes ahead and does it anyway.)

Hugh
