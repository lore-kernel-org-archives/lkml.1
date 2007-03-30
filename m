Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXC3WOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXC3WOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXC3WOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:14:14 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54782 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbXC3WON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:14:13 -0400
Date: Fri, 30 Mar 2007 15:13:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>, David Howells <dhowells@redhat.com>
Cc: Brian Pomerantz <bapper@piratehaven.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fix page leak during core dump
Message-Id: <20070330151353.95cd56ed.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703302250050.28059@blonde.wat.veritas.com>
References: <20070329203913.GA5190@skull.piratehaven.org>
	<20070330134359.ec6d95bc.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703302250050.28059@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 23:01:45 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Fri, 30 Mar 2007, Andrew Morton wrote:
> > On Thu, 29 Mar 2007 13:39:13 -0700
> > Brian Pomerantz <bapper@piratehaven.org> wrote:
> > 
> > > When the dump cannot occur most likely because of a full file system
> > > and the page to be written is the zero page, the call to
> > > page_cache_release() is missed.
> > > 
> > > Signed-off-by: Brian Pomerantz <bapper@mvista.com>
> > > 
> > > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > > index a2fceba..9cc4f0a 100644
> > > --- a/fs/binfmt_elf.c
> > > +++ b/fs/binfmt_elf.c
> > > @@ -1704,7 +1704,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
> > >  				DUMP_SEEK(PAGE_SIZE);
> > >  			} else {
> > >  				if (page == ZERO_PAGE(addr)) {
> > > -					DUMP_SEEK(PAGE_SIZE);
> > > +					if (!dump_seek(file, PAGE_SIZE)) {
> > > +						page_cache_release(page);
> > > +						goto end_coredump;
> > > +					}
> > 
> > Oh for gawds sake I wish we could be rid of those idiotic macros :(
> > 
> > This patch looks OK to me, although a refcount leak on the ZERO_PAGE is
> > special, because that page is PageReserved().
> > 
> > It used to be the case that we'd ignore attempts to change the refcount on
> > reserved pages (or at least on the ZERO_PAGE), but we changed that, so we
> > now actually refcount the ZERO_PAGE.  (I think, from a quick read of the
> > code.  This contradicts my memory of how it works).
> > 
> > So I expect the net effect here is that a sufficiently determined attacker
> > can overflow the ZERO_PAGE's refcount, thus causing it to be "freed".  The
> > page allocator won't actually free the page due to PG_Reserved, but it'll
> > all become very noisy.
> > 
> > Nick, Hugh: agree?
> 
> I think so - lots of "Bad page state" messages as the count bounces
> around the 0 mark, but not actually freed.  But when CONFIG_DEBUG_VM
> you'll get BUG_ONs.  And I can't swear bad things won't happen some-
> where once the count wraps to negative.  Easier to fix than work out
> the consequences.
> 
> (Of course, Nick is right now proposing a patch to take us back the
> other way, back to not accounting the ZERO_PAGE: so the fix needs
> to go in, then he'll need to reverse that again in his patch.)

OK.

> Doesn't fs/binfmt_elf_fdpic.c need the same fix?  It looks slightly
> different there, but I think when you look closer there's exactly
> the same issue?

Think so.  David, does it look OK?

<would anyone be interested in hearing my opinion on the DUMP_SEEK macro
again?>


From: Brian Pomerantz <bapper@piratehaven.org>

When the dump cannot occur most likely because of a full file system and
the page to be written is the zero page, the call to page_cache_release()
is missed.

Signed-off-by: Brian Pomerantz <bapper@mvista.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    5 ++++-
 fs/binfmt_elf_fdpic.c |    6 ++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~fix-page-leak-during-core-dump fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-page-leak-during-core-dump
+++ a/fs/binfmt_elf.c
@@ -1704,7 +1704,10 @@ static int elf_core_dump(long signr, str
 				DUMP_SEEK(PAGE_SIZE);
 			} else {
 				if (page == ZERO_PAGE(addr)) {
-					DUMP_SEEK(PAGE_SIZE);
+					if (!dump_seek(file, PAGE_SIZE)) {
+						page_cache_release(page);
+						goto end_coredump;
+					}
 				} else {
 					void *kaddr;
 					flush_cache_page(vma, addr,
diff -puN fs/binfmt_elf_fdpic.c~fix-page-leak-during-core-dump fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fix-page-leak-during-core-dump
+++ a/fs/binfmt_elf_fdpic.c
@@ -1480,8 +1480,10 @@ static int elf_fdpic_dump_segments(struc
 				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 			}
 			else if (page == ZERO_PAGE(addr)) {
-				DUMP_SEEK(file->f_pos + PAGE_SIZE);
-				page_cache_release(page);
+				if (!dump_seek(file, file->f_pos + PAGE_SIZE)) {
+					page_cache_release(page);
+					return 0;
+				}
 			}
 			else {
 				void *kaddr;
_

