Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYLOKXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYLOKXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYLOKXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:23:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56150 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYLOKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:23:16 -0500
Date: Mon, 15 Dec 2008 11:24:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Chris Friesen <cfriesen@nortel.com>,
       mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Cc: Andrew Morton <akpm@osdl.org>
Subject: [patch] Re: writing file to disk: not as easy as it looks
Message-ID: <20081215102450.GA9064@elf.ucw.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu> <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203050709.GL20858@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Heck, if you have a hiccup while writing an inode table block out to
> > > disk (for example a power failure at just the wrong time), so the
> > > memory (which is more voltage sensitive than hard drives) DMA's
> > > garbage which gets written to the inode table, you could lose a large
> > > number of adjacent inodes when garbage gets splatted over the inode
> > > table.
> > 
> > Ok, "memory failed before disk" is ... bad hardware.
> 
> It's PC class hardware.  Live with it.  Back when SGI made their own
> hardware, they noticed this problem, and so they wired up their SGI
> machines with powerfail interrupts, and extra big capacitors in
> their

Seems like bad hardware is very common indeed. Anyway, I guess it
would be fair to document what ext3 expects from disk subsystem for
safe operation. Does that summary sound correct/fair?

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 9dd2a3b..3855fbd 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -188,6 +188,34 @@ mke2fs: 	create a ext3 partition with th
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
+	   (Unfortuantely, all the cheap USB/SD flash cards I seen do behave
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
