Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYCMUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYCMUmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYCMUmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:42:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33065 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYCMUmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:42:02 -0400
Subject: fix for boot-time mnt_want_write() bug
From: Dave Hansen <haveblue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <200803130021.m2D0LlFm005300@www262.sakura.ne.jp>
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
	 <1205291010.9828.60.camel@nimitz.home.sr71.net>
	 <20080311202212.9fe1e5c1.akpm@linux-foundation.org>
	 <1205313918.8514.215.camel@twins> <20080312165218.GB613@parisc-linux.org>
	 <200803130021.m2D0LlFm005300@www262.sakura.ne.jp>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 13:41:55 -0700
Message-Id: <1205440916.4971.58.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Andrew, please pull this patch into your trees.

First of all, this is a hard bug to trigger.  I think it requires page
alloc (or slab) debugging.  It also requires that a vfsmnt has been
freed and its memory not been mapped as something else.  It must also
have had a recent mnt_writer at the time of its __mntput().  The area
where the vfsmnt was must fault when accessed.

The problem occurs when we unmount and __mntput() a vfsmount.  We go
find any cpu_writers for that mount and clear the cpu_writer->count to
zero.  That is supposed to mean that no one will ever go try and
coalesce the cpu_writer->count int to the mnt->__mnt_writers.  Buuuuuut,
that isn't quite what happens.  We only check in __clear_mnt_count() for
a NULL mount:

void __clear_mnt_count(mnt, cpu_writer)
{
 	if (!cpu_writer->mnt)
 		return;
 	atomic_add(cpu_writer->count, &cpu_writer->mnt->__mnt_writers);
 	cpu_writer->count = 0;
}

and we go ahead and dereference the mnt (which may be invalid here).  If
it *WAS* invalid, the cpu_writer->count is always 0, and we don't
actually do anything in practice to the invalid memory location except
access it.  Adding a 0 doesn't _hurt_ anything, even if there is
something else in the memory.  That's why we didn't notice this before.
Miklos, you were very right to get nervous about this area in your
review.

Either one of the hunks in the patch would have fixed Tetsuo's oops.
But, let's include both for completeness.  They're both operating on hot
cachelines at the time so it shouldn't really impact anything.

---

 linux-2.6.git-dave/fs/namespace.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/namespace.c~robind-oops-fix-bootup-1 fs/namespace.c
--- linux-2.6.git/fs/namespace.c~robind-oops-fix-bootup-1	2008-03-13 13:26:08.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2008-03-13 13:26:08.000000000 -0700
@@ -186,6 +186,12 @@ static inline void __clear_mnt_count(str
 {
 	if (!cpu_writer->mnt)
 		return;
+	/*
+	 * This is in case anyone ever leaves an invalid,
+	 * old ->mnt and a count of 0.
+	 */
+	if (!cpu_writer->count)
+		return;
 	atomic_add(cpu_writer->count, &cpu_writer->mnt->__mnt_writers);
 	cpu_writer->count = 0;
 }
@@ -577,6 +583,12 @@ static inline void __mntput(struct vfsmo
 		spin_lock(&cpu_writer->lock);
 		atomic_add(cpu_writer->count, &mnt->__mnt_writers);
 		cpu_writer->count = 0;
+		/*
+		 * Might as well do this so that no one
+		 * ever sees the pointer and expects
+		 * it to be valid.
+		 */
+		cpu_writer->mnt = NULL;
 		spin_unlock(&cpu_writer->lock);
 	}
 	/*
_


-- Dave

