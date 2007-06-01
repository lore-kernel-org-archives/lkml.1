Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbXFAFU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbXFAFU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbXFAFUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:20:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36273 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbXFAFUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:20:51 -0400
Date: Thu, 31 May 2007 22:20:39 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601052039.GU20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com> <20070601010129.GA15878@wotan.suse.de> <20070601012440.GS20632@ca-server1.us.oracle.com> <20070601013402.GB28585@wotan.suse.de> <20070601014517.GT20632@ca-server1.us.oracle.com> <20070601015349.GC28585@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601015349.GC28585@wotan.suse.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 03:53:49AM +0200, Nick Piggin wrote:
> On Thu, May 31, 2007 at 06:45:17PM -0700, Mark Fasheh wrote:
> > On Fri, Jun 01, 2007 at 03:34:02AM +0200, Nick Piggin wrote:
> > > > Here's a nasty idea... Would it be valid for ->page_mkwrite to unlock the
> > > > page, so long as it's returned in a locked state? Though, do we even need
> > > > the page lock that early? It seemed to me that you were adding it for
> > > > consistency reasons (I could be wrong though).
> > > 
> > > You could do that, but you'd have to probably check that it is
> > > within i_size after you relock it, I think... yeah, that might
> > > be the best thing for ocfs to do for now.

Ok. So how about the attached patch? It's a bit different than discussed,
but I think it's much cleaner because it preserves the current behavior of
the callback and keeps that bit of page locking inside core code. Not tested
as of yet, but I can run it tommorrow.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

From: Mark Fasheh <mark.fasheh@oracle.com>

[PATCH] Release page lock before calling ->page_mkwrite

__do_fault() was calling ->page_mkwrite() with the page lock held, which
violates the locking rules for that callback. Release and retake the page
lock around the callback to avoid deadlocking file systems which manually
take it.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 mm/memory.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7221618..491cc27 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2378,11 +2378,14 @@ static int __do_fault(struct mm_struct *
 			 * address space wants to know that the page is about
 			 * to become writable
 			 */
-			if (vma->vm_ops->page_mkwrite &&
-			    vma->vm_ops->page_mkwrite(vma, page) < 0) {
-				fdata.type = VM_FAULT_SIGBUS;
-				anon = 1; /* no anon but release faulted_page */
-				goto out;
+			if (vma->vm_ops->page_mkwrite) {
+				unlock_page(page);
+				if (vma->vm_ops->page_mkwrite(vma, page) < 0) {
+					fdata.type = VM_FAULT_SIGBUS;
+					anon = 1; /* no anon but release faulted_page */
+					goto out_unlocked;
+				}
+				lock_page(page);
 			}
 		}
 
@@ -2434,6 +2437,7 @@ static int __do_fault(struct mm_struct *
 
 out:
 	unlock_page(faulted_page);
+out_unlocked:
 	if (anon)
 		page_cache_release(faulted_page);
 	else if (dirty_page) {
-- 
1.4.2.3

