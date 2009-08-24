Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbZHXJca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbZHXJca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZHXJc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:32:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51312 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZHXJc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:32:28 -0400
Date: Mon, 24 Aug 2009 11:31:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Rob Landley <rob@landley.net>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090824093143.GD25591@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljqn82zc.fsf@frosties.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Running journaling filesystem such as ext3 over flashdisk or degraded
RAID array is a bad idea: journaling guarantees no longer apply and
you will get data corruption on powerfail.

We can't solve it easily, but we should certainly warn the users. I
actually lost data because I did not understand these limitations...

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/filesystems/expectations.txt b/Documentation/filesystems/expectations.txt
new file mode 100644
index 0000000..80fa886
--- /dev/null
+++ b/Documentation/filesystems/expectations.txt
@@ -0,0 +1,52 @@
+Linux block-backed filesystems can only work correctly when several
+conditions are met in the block layer and below (disks, flash
+cards). Some of them are obvious ("data on media should not change
+randomly"), some are less so.
+
+Write errors not allowed (NO-WRITE-ERRORS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Writes to media never fail. Even if disk returns error condition
+during write, filesystems can't handle that correctly.
+
+	Fortunately writes failing are very uncommon on traditional 
+	spinning disks, as they have spare sectors they use when write
+	fails.
+
+Don't cause collateral damage to adjacent sectors on a failed write (NO-COLLATERALS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Unfortunately, cheap USB/SD flash cards I've seen do have this bug,
+and are thus unsuitable for all filesystems I know.
+
+	An inherent problem with using flash as a normal block device
+	is that the flash erase size is bigger than most filesystem
+	sector sizes.  So when you request a write, it may erase and
+	rewrite some 64k, 128k, or even a couple megabytes on the
+	really _big_ ones.
+
+	If you lose power in the middle of that, filesystem won't
+	notice that data in the "sectors" _around_ the one your were
+	trying to write to got trashed.
+
+	RAID-4/5/6 in degraded mode has same problem.
+
+
+Don't damage the old data on a failed write (ATOMIC-WRITES)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Either whole sector is correctly written or nothing is written during
+powerfail.
+
+	Because RAM tends to fail faster than rest of system during 
+	powerfail, special hw killing DMA transfers may be necessary;
+	otherwise, disks may write garbage during powerfail.
+	This may be quite common on generic PC machines.
+
+	Note that atomic write is very hard to guarantee for RAID-4/5/6,
+	because it needs to write both changed data, and parity, to 
+	different disks. (But it will only really show up in degraded mode).
+	UPS for RAID array should help.
+
+
+
diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 67639f9..0a9b87f 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -338,27 +339,30 @@ enough 4-character names to make up unique directory entries, so they
 have to be 8 character filenames, even then we are fairly close to
 running out of unique filenames.
 
+Requirements
+============
+
+Ext2 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* write errors not allowed (NO-WRITE-ERRORS)
+
+* don't damage the old data on a failed write (ATOMIC-WRITES)
+
+and obviously:
+
+* don't cause collateral damage to adjacent sectors on a failed write
+  (NO-COLLATERALS)
+
+(see expectations.txt; note that most/all linux block-based
+filesystems have similar expectations)
+
+* write caching is disabled. ext2 does not know how to issue barriers
+  as of 2.6.28. hdparm -W0 disables it on SATA disks.
+
 Journaling
-----------
-
-A journaling extension to the ext2 code has been developed by Stephen
-Tweedie.  It avoids the risks of metadata corruption and the need to
-wait for e2fsck to complete after a crash, without requiring a change
-to the on-disk ext2 layout.  In a nutshell, the journal is a regular
-file which stores whole metadata (and optionally data) blocks that have
-been modified, prior to writing them into the filesystem.  This means
-it is possible to add a journal to an existing ext2 filesystem without
-the need for data conversion.
-
-When changes to the filesystem (e.g. a file is renamed) they are stored in
-a transaction in the journal and can either be complete or incomplete at
-the time of a crash.  If a transaction is complete at the time of a crash
-(or in the normal case where the system does not crash), then any blocks
-in that transaction are guaranteed to represent a valid filesystem state,
-and are copied into the filesystem.  If a transaction is incomplete at
-the time of the crash, then there is no guarantee of consistency for
-the blocks in that transaction so they are discarded (which means any
-filesystem changes they represent are also lost).
+==========
 Check Documentation/filesystems/ext3.txt if you want to read more about
 ext3 and journaling.
 
diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 570f9bd..2ce82a3 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -199,6 +202,47 @@ debugfs: 	ext2 and ext3 file system debugger.
 ext2online:	online (mounted) ext2 and ext3 filesystem resizer
 
 
+Requirements
+============
+
+Ext3 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* write errors not allowed (NO-WRITE-ERRORS)
+
+* don't damage the old data on a failed write (ATOMIC-WRITES)
+
+	(Thrash may get written into sectors during powerfail.  And
+	ext3 handles this surprisingly well at least in the
+	catastrophic case of garbage getting written into the inode
+	table, since the journal replay often will "repair" the
+	garbage that was written into the filesystem metadata blocks.
+	It won't do a bit of good for the data blocks, of course
+	(unless you are using data=journal mode).  But this means that
+	in fact, ext3 is more resistant to suriving failures to the
+	first problem (powerfail while writing can damage old data on
+	a failed write) but fortunately, hard drives generally don't
+	cause collateral damage on a failed write.
+
+and obviously:
+
+* don't cause collateral damage to adjacent sectors on a failed write
+  (NO-COLLATERALS)
+
+
+(see expectations.txt; note that most/all linux block-based
+filesystems have similar expectations)
+
+* either write caching is disabled, or hw can do barriers and they are enabled.
+
+	   (Note that barriers are disabled by default, use "barrier=1"
+	   mount option after making sure hw can support them). 
+
+	   hdparm -I reports disk features. If you have "Native
+	   Command Queueing" is the feature you are looking for.
+
+
 References
 ==========
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
