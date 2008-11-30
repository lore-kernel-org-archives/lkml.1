Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYK3MTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYK3MTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 07:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYK3MTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 07:19:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55201 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbYK3MTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 07:19:12 -0500
Date: Sun, 30 Nov 2008 12:19:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gregkh@suse.de, petero2@telia.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fix pktcdvd breakage from commit
	e105b8bfc769b0545b6f0f395179d1e43cbee822
Message-ID: <20081130121909.GV28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	device_create() will create a symlink in /sys/dev/char unless
the class has ->dev_kobj cleared; pktcdvd uses it to populate the
/sys/class/pktcdvd/ with per-device subdirectories.  While we do
want /sys/class/pktcdvd/pktcdvd[0-7]/dev to contain a device number,
we definitely do not want it to try and crap into /sys/dev/char; if
nothing else, device number is *block* one (and we don't want it
to crap into /sys/dev/block either - there such symlinks will be created
by add_disk() and they will point to /sys/block/pktcdvd[0-7]).

	As it is, attempt to set the damn thing up will end up with
sysfs_add_one() barfing at duplicate entries and /sys/class/pktcdvd/pktcdvd*/*/
not created at all.  The fix is trivial: clear ->dev_kobj in the class to
tell device_add() that no, we do *not* want these symlinks, TYVM...

	FWIW, all traces containing pkt_setup_dev() on kerneloops.org appear
to be from that one.  It had been around since 2.6.26; probably -stable
fodder...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index f20bf35..79981f2 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -417,6 +417,7 @@ static int pkt_sysfs_init(void)
 		printk(DRIVER_NAME": failed to create class pktcdvd\n");
 		return ret;
 	}
+	class_pktcdvd->dev_kobj = NULL;
 	return 0;
 }
 
