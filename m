Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbXFAWBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbXFAWBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXFAWBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:01:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51858 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbXFAWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:01:32 -0400
Date: Fri, 1 Jun 2007 15:01:18 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601220117.GW20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com> <20070601010129.GA15878@wotan.suse.de> <20070601012440.GS20632@ca-server1.us.oracle.com> <20070601013402.GB28585@wotan.suse.de> <20070601014517.GT20632@ca-server1.us.oracle.com> <20070601015349.GC28585@wotan.suse.de> <20070601052039.GU20632@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601052039.GU20632@ca-server1.us.oracle.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:20:39PM -0700, Mark Fasheh wrote:
> Ok. So how about the attached patch? It's a bit different than discussed,
> but I think it's much cleaner because it preserves the current behavior of
> the callback and keeps that bit of page locking inside core code. Not tested
> as of yet, but I can run it tommorrow.

Ok - this patch seems to check out fine in testing - no more deadlocking.

Andrew, if this is ok with you I'd really like to see that fix in -mm. Ocfs2
shared write mmap will instantly deadlock without it.

>From reading Nick's description of the problem in
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch I think we're
pretty safe (as I noted before) because Ocfs2 re-checks the mapping under
lock to protect against trucate races. That's been an "unwritten"
requirement of page_mkwrite() anyway.

Speaking of requirements, attached is my sad attempt at documenting the API.
I know it might be merged into ->fault at some point, but we really ought to
have _something_ in the meantime.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com


From: Mark Fasheh <mark.fasheh@oracle.com>

[PATCH] Document ->page_mkwrite() locking

There seems to be very little documentation about this callback in general.
The locking in particular is a bit tricky, so it's worth having this in
writing.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

---

 Documentation/filesystems/Locking |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

2320eadfa34199c779638edbdbb6c491df09c49b
diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 970c8ec..91ec4b4 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -512,13 +512,22 @@ prototypes:
 	void (*close)(struct vm_area_struct*);
 	struct page *(*fault)(struct vm_area_struct*, struct fault_data *);
 	struct page *(*nopage)(struct vm_area_struct*, unsigned long, int *);
+	int (*page_mkwrite)(struct vm_area_struct *, struct page *);
 
 locking rules:
-		BKL	mmap_sem
+		BKL	mmap_sem	PageLocked(page)
 open:		no	yes
 close:		no	yes
 fault:		no	yes
 nopage:		no	yes
+page_mkwrite:	no	yes		no
+
+	->page_mkwrite() is called when a previously read-only page is
+about to become writeable. The file system is responsible for
+protecting against truncate races. Once appropriate action has been
+taking to lock out truncate, the page range should be verified to be
+within i_size. The page mapping should also be checked that it is not
+NULL.
 
 ================================================================================
 			Dubious stuff
-- 
1.3.3

