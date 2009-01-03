Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbZACULc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbZACULc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbZACUKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:10:50 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50297 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675AbZACUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:10:48 -0500
Date: Sat, 3 Jan 2009 13:38:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       tytso@mit.edu, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org
Subject: document ext3 requirements
Message-ID: <20090103123813.GA1512@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ext3 is only safe if storage subsystem meets certain
criteria. Document those.

Errors=remount-ro is documented as default, but superblock setting
overrides that and mkfs defaults to errors=continue... so the default
is errors=continue in practice.

readonly mount does actually write to the media in some cases. Document that.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 9dd2a3b..74a73b0 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -14,6 +14,9 @@ Options
 When mounting an ext3 filesystem, the following option are accepted:
 (*) == default
 
+ro			Note that ext3 will replay the journal (and thus write
+			to the partition) even when mounted "read only".
+
 journal=update		Update the ext3 file system's journal to the current
 			format.
 
@@ -95,6 +98,8 @@ debug			Extra debugging information is sent to syslog.
 errors=remount-ro(*)	Remount the filesystem read-only on an error.
 errors=continue		Keep going on a filesystem error.
 errors=panic		Panic and halt the machine if an error occurs.
+			(Note that default is overriden by superblock
+			setting on most systems).
 
 data_err=ignore(*)	Just print an error message if an error occurs
 			in a file data buffer in ordered mode.
@@ -188,6 +193,34 @@ mke2fs: 	create a ext3 partition with the -j flag.
 debugfs: 	ext2 and ext3 file system debugger.
 ext2online:	online (mounted) ext2 and ext3 filesystem resizer
 
+Requirements
+============
+
+Ext3 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* writes to media never fail. Even if disk returns error condition during
+  write, ext3 can't handle that correctly, because success on fsync was already
+  returned when data hit the journal.
+
+	   (Fortunately writes failing are very uncommon on disks, as they
+	   have spare sectors they use when write fails.)
+
+* either whole sector is correctly written or nothing is written during
+  powerfail.
+
+	   (Unfortuantely, none of the cheap USB/SD flash cards I seen do behave
+	   like this, and are unsuitable for ext3. Because RAM tends to fail
+	   faster than rest of system during powerfail, special hw killing
+	   DMA transfers may be neccessary. Not sure how common that problem
+	   is on generic PC machines).
+
+* either write caching is disabled, or hw can do barriers and they are enabled.
+
+	   (Note that barriers are disabled by default, use "barrier=1"
+	   mount option after making sure hw can support them). 
+
 
 References
 ==========

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
