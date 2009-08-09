Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZHIX1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZHIX1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZHIX1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:27:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:34642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZHIX1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vtkfpIu8TEIisHYc1FjC1QDq44dhHVnElE+bVk+lA0sbQhHl9J8KperRB6ZuWVXRDI
         Q/d/ffe2fYUe4bern5e9LRJFLHpAWXxBi1pqpPgNHMXjcDkRoWS5cm24JS7haraMCCIb
         pPvytxtlb5K7bjUCib3PqxhnrzQSM4B787WLM=
Date: Mon, 10 Aug 2009 01:27:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH] kill-the-bkl/reiserfs: fix early readdir offset increment
Message-ID: <20090809232735.GC6089@nowhere>
References: <20090731174642.GA6539@nowhere> <20090801081141.GA18036@basil.fritz.box> <20090801155335.GA4836@nowhere> <20090802142100.GA21160@elte.hu> <adatz0po5cn.fsf@cisco.com> <20090803132659.GC3570@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803132659.GC3570@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 09:26:59AM -0400, Chris Mason wrote:
> Definitely, the cost of the rare bug is much higher.  The good news is
> that reiserfs tends to pile its races into a few spots.  Most of them
> can be found with a 12 hour run of the namesys stress.sh program and a
> lot of memory pressure.  I'd compile with preemption on and you'll have
> a good test on any SMP machine.
> 
> http://oss.oracle.com/~mason/stress.sh
> 
> stress.sh just copies a source directory into the test filesystem, then
> reads it  back and deletes it in a loop.  I'd run with 50 procs and
> enough memory  pressure for the box to lightly swap (booting w/mem= is a
> fine way to make memory pressure).  This way you make sure to hammer on
> the metadata writeback paths, which is where all of the difficult races
> come in.
> 
> Testing with an fsx-linux process running at the same time will make
> sure all of the mmap/truncate paths are working correctly as well.
> 
> -chris
> 


Running this script has unearthed a bug introduced in my last commit.
This is fixed in the patch below.
Thanks for this script, I'm now running it very often, only on PREEMPT UP
for now.

---
>From a22c48509ca7b54206c0616141278e5561f119ef Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 10 Aug 2009 00:53:45 +0200
Subject: [PATCH] kill-the-bkl/reiserfs: fix early readdir offset increment

The previous commit:
"kill-the-bkl/reiserfs: release the lock only for first entry in readdir"
brought a bug which increments the readdir offset even if we failed to
copy a directory entry through filldir.

Then if we are in the end of the user buffer, there are chances that
getdents() will be subsequently called with a new buffer to continue
fetching the directory. At this time the directory entry offset will
be wrong because it has omitted the previous entry that failed to copy.

We need to increment the directory offset after fetching an entry, not
before.

This fixes weird bugs in which a directory seems not empty whereas
it is.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
---
 fs/reiserfs/dir.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index d6fb8d3..d4477eb 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -195,12 +195,6 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 				*pos = d_off;
 				d_ino = deh_objectid(deh);
 
-				/*
-				 * next entry should be looked for with such
-				 * offset
-				 */
-				next_pos = deh_offset(deh) + 1;
-
 				if (first_entry) {
 					int fillret;
 
@@ -221,11 +215,18 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 
 					if (item_moved(&tmp_ih, &path_to_entry))
 						goto research;
-					continue;
-				}
-				if (filldir(dirent, d_name, d_reclen, d_off,
-					    d_ino, DT_UNKNOWN) < 0)
+				} else {
+					if (filldir(dirent, d_name, d_reclen,
+						  d_off, d_ino, DT_UNKNOWN) < 0)
 						goto end;
+				}
+
+				/*
+				 * next entry should be looked for with such
+				 * offset
+				 */
+				next_pos = deh_offset(deh) + 1;
+
 			}	/* for */
 		}
 
-- 
1.6.2.3


You can find this patch and the other in this series in the following git
tree:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

Thanks.

