Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYFALjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYFALjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 07:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYFALjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 07:39:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51451 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYFALjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 07:39:22 -0400
Date: Sun, 1 Jun 2008 13:40:09 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com
Cc: Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080601114008.GC16843@elf.ucw.cz>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site> <20080530204307.GA4978@ucw.cz> <Pine.LNX.4.64.0805311925190.27293@blonde.site> <20080531173950.c4f04028.akpm@linux-foundation.org> <Pine.LNX.4.64.0806010752510.24919@blonde.site> <20080601011501.199af80c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601011501.199af80c.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > All I can say so far is that I find the same as you do:
> > > > SYNC_FILE_RANGE_WRITE (after writing) takes a significant amount of time,
> > > > more than half as long as when you add in SYNC_FILE_RANGE_WAIT_AFTER too.
> > > > 
> > > > Which make the sync_file_range call pretty pointless: your usage seems
> > > > perfectly reasonable to me, but somehow we've broken its behaviour.
> > > > I'll be investigating ...
> > > 
> > > It will block on disk queue fullness - sysrq-W will tell.
> > 
> > Ah, thank you.  What a disappointment, though it's understandable.
> > Doesn't that very severely limit the usefulness of the system call?
> 
> A bit.  The request queue size is runtime tunable though.

Which /sys is that? What happens if I set the queue size to pretty
much infinity, will memory management die horribly?

> I expect major users of this system call will be applications which do
> small-sized overwrites into large files, mainly databases.  That is,
> once the application developers discover its existence.  I'm still
> getting expressions of wonder from people who I tell about the
> five-year-old fadvise().

Hey, you have one user now, its called s2disk. But for this call to be
useful, we'd need asynchronous variant... is there such thing?

Okay, I can fork and do the call from another process, but...

> > I admit the flag isn't called SYNC_FILE_RANGE_WRITE_WITHOUT_WAITING,
> > but I don't suppose Pavel and I are the only ones misled by it.
> 
> Yup, this caveat/restriction should be in the manpage.

Michael, this is something for you I guess?

And andrew, something for you:

--- 

SYNC_FILE_RANGE_WRITE may and will block. Document that.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 5db78da3d8e6fa527bfe384ded2ff7c835592fe2
tree 4c405e07be12f0a2260492fb43d19802ff7ebab1
parent 0ea376de01be797f9563c2c2464149f8f0af6329
author Pavel <pavel@amd.ucw.cz> Sun, 01 Jun 2008 13:39:25 +0200
committer Pavel <pavel@amd.ucw.cz> Sun, 01 Jun 2008 13:39:25 +0200

 fs/sync.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 228e17b..54e9f20 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -139,7 +139,8 @@ asmlinkage long sys_fdatasync(unsigned i
  * before performing the write.
  *
  * SYNC_FILE_RANGE_WRITE: initiate writeout of all those dirty pages in the
- * range which are not presently under writeback.
+ * range which are not presently under writeback. Notice that even this this
+ *  may and will block if you attempt to write more than request queue size.
  *
  * SYNC_FILE_RANGE_WAIT_AFTER: wait upon writeout of all pages in the range
  * after performing the write.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
