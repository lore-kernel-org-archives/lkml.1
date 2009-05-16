Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZEPTQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZEPTQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 15:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZEPTQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 15:16:09 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63422 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbZEPTQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 15:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=sq47teqHErbw2IROhaVyuyooaQgNpPZjL/QwL7pvjdMkNBoTjac7BlU2p6Bixw6faS
         LTSBR1221REJujlgxK5JPP8fHvCv/KiSBKqbPYZ1haPVLCcOBUlHljIXb3IuwtW5C/+1
         AMLtft4iPB2bRXD0WEgOromjyeOC2RCm25PRY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 16 May 2009 21:16:23 +0200
Message-Id: <200905162116.23690.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ide-tape oops fix, icside regression fix and new piix cable quirk

Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 drivers/ide/icside.c   |    2 +-
 drivers/ide/ide-tape.c |    6 ------
 drivers/ide/piix.c     |    1 +
 3 files changed, 2 insertions(+), 7 deletions(-)


Alan Cox (1):
      piix: The Sony TZ90 needs the cable type hardcoding

Sergei Shtylyov (1):
      icside: register second channel of version 6 PCB

Tejun Heo (1):
      ide-tape: remove back-to-back REQUEST_SENSE detection


diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 4e16ce6..36da913 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -466,7 +466,7 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	struct ide_host *host;
 	unsigned int sel = 0;
 	int ret;
-	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
+	hw_regs_t hw[2], *hws[] = { &hw[0], &hw[1], NULL, NULL };
 	struct ide_port_info d = icside_v6_port_info;
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cb942a9..3a53e08 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -614,12 +614,6 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	if (drive->pc->c[0] == REQUEST_SENSE &&
-	    pc->c[0] == REQUEST_SENSE) {
-		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
-			"Two request sense in serial were issued\n");
-	}
-
 	if (drive->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
 		drive->failed_pc = pc;
 
diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
index 2aa6999..69860de 100644
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -263,6 +263,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
 	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
 	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
+	{ 0x27df, 0x104d, 0x900e },	/* ICH7 on Sony TZ-90 */
 	/* end marker */
 	{ 0, }
 };
