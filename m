Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZJBCAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZJBCAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbZJBCAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:00:00 -0400
Received: from kroah.org ([198.145.64.141]:32925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbZJBBcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:08 2009
Message-Id: <20091002012408.133960162@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wolfgang Muees <wolfgang.mues@auerswald.de>,
       <linux-mmc@vger.kernel.org>
Subject: [016/136] mmc_spi: fail gracefully if host or card do not support the switch command
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=mmc_spi-fail-gracefully-if-host-or-card-do-not-support-the-switch-command.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

commit d08ebeddfb3293fa4bdfca9c610daf1e8ec8b233 upstream.

Some time ago, I have send a patch to the mmc_spi subsystem changing the
error codes.  This was after a discussion with Pierre about using EINVAL
only for non-recoverable errors.  This patch was accepted as

http://git.kernel.org/linus/fdd858db7113ca64132de390188d7ca00701013d

Unfortunately, several weeks later, I realized that this patch has opened
a little can of worms because there are SD cards on the market which

a) claim that they support the switch command
AND
b) refuse to execute this command if operating in SPI mode.

So, such a card would get unusuable in an embedded linux system in SPI
mode, because the init sequence terminates with an error.

This patch adds the missing error codes to the caller of the switch
command and restores the old behaviour to fail gracefully if these
commands can not execute.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/mmc.c |   10 +++++-----
 drivers/mmc/core/sd.c  |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -180,11 +180,11 @@ static int mmc_read_ext_csd(struct mmc_c
 
 	err = mmc_send_ext_csd(card, ext_csd);
 	if (err) {
-		/*
-		 * We all hosts that cannot perform the command
-		 * to fail more gracefully
-		 */
-		if (err != -EINVAL)
+		/* If the host or the card can't do the switch,
+		 * fail more gracefully. */
+		if ((err != -EINVAL)
+		 && (err != -ENOSYS)
+		 && (err != -EFAULT))
 			goto out;
 
 		/*
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -210,11 +210,11 @@ static int mmc_read_switch(struct mmc_ca
 
 	err = mmc_sd_switch(card, 0, 0, 1, status);
 	if (err) {
-		/*
-		 * We all hosts that cannot perform the command
-		 * to fail more gracefully
-		 */
-		if (err != -EINVAL)
+		/* If the host or the card can't do the switch,
+		 * fail more gracefully. */
+		if ((err != -EINVAL)
+		 && (err != -ENOSYS)
+		 && (err != -EFAULT))
 			goto out;
 
 		printk(KERN_WARNING "%s: problem reading switch "


