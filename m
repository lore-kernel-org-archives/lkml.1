Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbYLZWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbYLZWjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 17:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYLZWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 17:39:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57877 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbYLZWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 17:39:10 -0500
Date: Fri, 26 Dec 2008 23:39:08 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: SD/MMC cards: how crappy they are?
Message-ID: <20081226223908.GA2260@atrey.karlin.mff.cuni.cz>
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com> <20081202165608.GD18162@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202165608.GD18162@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> If this is your random eject out from your HP laptop problem, note
> that random ejects while the card is writing can cause corruption of
> the flash translation layer (FTL), which for some really crappy cards,
> can permanently damage them; hopefully most of those are gone from the
> market, but I wouldn't be positive about that.  The better ones will
> have some kind of journalling scheme for their FTL...
> 
> Fsck does have a force rewrite option, although it's not the default.
> You have to answer "n" to ignore error, and then yes to "force
> rewrite".  I should perhaps change that; my worry at the time was a
> transient read error tricking e2fsck into blowing away the contents of
> what was actually a good sector.  Of course, that will only help

Yes, I think that should be changed. Transient read errors are not
common, while bad blocks fixed by rewrite are quite common.
> 
> Badblocks -n will fix the problem, since it will do a non-destructive
> read/write test over the entire disk.  Patches to add an
> forced-rewrite mode to the standard r/o badblocks sweep (so we only
> write to a sector that has a read error) would be gratefully accepted.

badblocks -n took > 8hours on 32GB flash, so no, that's not usable. I
started digging into badblocks (please take a look/apply following
documentation updates, I only understood some stuff when reading the
source)... And I wish I'd known about SIGALARM before.

Question: does badblocks expect the media to be valied ext2/3/4
filesystem? It seems so...

								Pavel

Binary files e2fsprogs-1.41.3-clean/misc/badblocks and e2fsprogs-1.41.3/misc/badblocks differ
diff -ur e2fsprogs-1.41.3-clean/misc/badblocks.8 e2fsprogs-1.41.3/misc/badblocks.8
--- e2fsprogs-1.41.3-clean/misc/badblocks.8	2008-12-26 23:08:55.000000000 +0100
+++ e2fsprogs-1.41.3/misc/badblocks.8	2008-12-26 23:18:56.000000000 +0100
@@ -173,6 +173,10 @@
 read-only test is done.  This option must not be combined with the 
 .B \-w
 option, as they are mutually exclusive.
+
+This will read the block to be tested, then overwrite it with few different
+patterns, then write old data back. If something goes very wrong during the
+test (powerfail?) it may still damage the data.
 .TP
 .B \-s
 Show the progress of the scan by writing out the block numbers as they
@@ -211,6 +215,10 @@
 bad blocks. Therefore it is recommended to use it only when one wants
 to know if there are any bad blocks at all on the device, and not when
 the list of bad blocks is wanted.
+
+You can send SIGALARM to make badblocks report its progress. You can
+send SIGTERM to make badblocks terminate; it will catch the signal, clean
+up and exit.
 .SH AUTHOR
 .B badblocks
 was written by Remy Card <Remy.Card@linux.org>.  Current maintainer is

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
