Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZADW7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZADW7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZADW65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:58:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45402 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZADW64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:58:56 -0500
Date: Mon, 5 Jan 2009 00:00:53 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: [patch] Re: document ext3 requirements
Message-ID: <20090104230053.GG1913@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net> <20090104220634.GD22958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104220634.GD22958@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 17:06:34, Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 01:49:49PM -0600, Rob Landley wrote:
> > 
> > Want to document the granularity issues with flash, while you're at it?
> > 
> > An inherent problem with using flash as a normal block device is that the 
> > flash erase size is bigger than most filesystem sector sizes.  So when you 
> > request a write, it may erase and rewrite the next 64k, 128k, or even a couple 
> > megabytes on the really _big_ ones.
> > 
> > If you lose power in the middle of that, ext3 won't notice that data in the 
> > "sectors" _after_ the one your were trying to write to got trashed.
> 
> True enough, although the newer SSD's will have this problem addressed
> (although at least initially, they are **far** more costly than the
> el-cheapo 32GB SD cards you can find at the checkout counter at Fry's
> alongside battery-powered shavers and trashy ipod speakers).
> 
> I will stress again, that most of this doesn't belong in
> Documentation/filesystems/ext3.txt, as most of this is *not*
> ext3-specific.

Agreed... So what about this one?

---

Document linux filesystem expectations. Ext3 can't handle write errors
of any kind, and can't handle non-atomic sector writes. Other
filesystems are probably even worse...

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/filesystems/expectations.txt b/Documentation/filesystems/expectations.txt
new file mode 100644
index 0000000..7817a9c
--- /dev/null
+++ b/Documentation/filesystems/expectations.txt
@@ -0,0 +1,44 @@
+Linux filesystems can only work correctly when several conditions are
+met in the block layer and below (disks, flash cards). Some of them
+are obvious ("data on media should not change randomly"), some are
+less so.
+
+Write errors not allowed (NO-WRITE-ERRORS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Writes to media never fail. Even if disk returns error condition
+during write, filesystems can't handle that correctly, because success
+on fsync was already returned when data hit the journal.
+
+	Fortunately writes failing are very uncommon on traditional 
+	spinning disks, as they have spare sectors they use when write
+	fails.
+
+Sector writes are atomic (ATOMIC-SECTORS)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Either whole sector is correctly written or nothing is written during
+powerfail.
+
+	Unfortuantely, none of the cheap USB/SD flash cards I seen do 
+	behave like this, and are unsuitable for all linux filesystems 
+	I know. 
+
+		An inherent problem with using flash as a normal block
+		device is that the flash erase size is bigger than
+		most filesystem sector sizes.  So when you request a
+		write, it may erase and rewrite the next 64k, 128k, or
+		even a couple megabytes on the really _big_ ones.
+
+		If you lose power in the middle of that, filesystem
+		won't notice that data in the "sectors" _after_ the
+		one your were trying to write to got trashed.
+
+	Because RAM tends to fail faster than rest of system during 
+	powerfail, special hw killing DMA transfers may be neccessary;
+	otherwise, disks may write garbage during powerfail.
+	Not sure how common that problem is on generic PC machines.
+
+
+
+
diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 9dd2a3b..8cb64b0 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -188,6 +197,25 @@ mke2fs: 	create a ext3 partition with th
 debugfs: 	ext2 and ext3 file system debugger.
 ext2online:	online (mounted) ext2 and ext3 filesystem resizer
 
+Requirements
+============
+
+Ext3 expects disk/storage subsystem to behave sanely. On sanely
+behaving disk subsystem, data that have been successfully synced will
+stay on the disk. Sane means:
+
+* write errors not allowed
+
+* sector writes are atomic
+
+(see expectations.txt; note that most/all linux filesystems have similar
+expectations)
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
