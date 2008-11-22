Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYKVRky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYKVRky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759220AbYKVRg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:36:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58484 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918AbYKVRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:36:55 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 22/32] tricky one: hisax sections
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de
Message-Id: <E1L3wPe-0006a0-Le@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:36:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) hisax_init_pcmcia() needs to be defined only if we have
CONFIG_HOTPLUG (no PCMCIA support otherwise) and can be declared
__devinit.

b) HiSax_inithardware() can go __init

c) hisax_register() is passing to checkcard() full-blown hisax_cs_setup_card():
	checkcard(i, id, NULL, hisax_d_if->owner, hisax_cs_setup_card);
The problem with it is that
	* hisax_cs_setup_card() is __devinit
	* hisax_register() is not
	* hisax_cs_setup_card() is a switch from hell, calling a lot
of setup_some_weirdcard() depending on card->typ.  _These_ are also
__devinit.
However, in hisax_register() we have card->typ equal to ISDN_CTYPE_DYNAMIC,
which reduces hisax_cs_setup_card() to "nevermind all that crap, just do
nothing and return 2".  So we add a trimmed-down callback doing just that
and passed to checkcard() by hisax_register().  _This_ is non-init (we
can stand the impact on .text size).

Voila - no section warnings from drivers/isdn

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/isdn/hisax/config.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1213,7 +1213,7 @@ static void HiSax_shiftcards(int idx)
 		memcpy(&cards[i], &cards[i + 1], sizeof(cards[i]));
 }
 
-static int HiSax_inithardware(int *busy_flag)
+static int __init HiSax_inithardware(int *busy_flag)
 {
 	int foundcards = 0;
 	int i = 0;
@@ -1542,7 +1542,9 @@ static void __exit HiSax_exit(void)
 	printk(KERN_INFO "HiSax module removed\n");
 }
 
-int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
+#ifdef CONFIG_HOTPLUG
+
+int __devinit hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
 {
 	u_char ids[16];
 	int ret = -1;
@@ -1563,6 +1565,8 @@ error:
 }
 
 EXPORT_SYMBOL(hisax_init_pcmcia);
+#endif
+
 EXPORT_SYMBOL(HiSax_closecard);
 
 #include "hisax_if.h"
@@ -1580,6 +1584,11 @@ static void hisax_bc_close(struct BCState *bcs);
 static void hisax_bh(struct work_struct *work);
 static void EChannel_proc_rcv(struct hisax_d_if *d_if);
 
+static int hisax_setup_card_dynamic(struct IsdnCard *card)
+{
+	return 2;
+}
+
 int hisax_register(struct hisax_d_if *hisax_d_if, struct hisax_b_if *b_if[],
 		   char *name, int protocol)
 {
@@ -1599,7 +1608,8 @@ int hisax_register(struct hisax_d_if *hisax_d_if, struct hisax_b_if *b_if[],
 	cards[i].protocol = protocol;
 	sprintf(id, "%s%d", name, i);
 	nrcards++;
-	retval = checkcard(i, id, NULL, hisax_d_if->owner, hisax_cs_setup_card);
+	retval = checkcard(i, id, NULL, hisax_d_if->owner,
+				hisax_setup_card_dynamic);
 	if (retval == 0) { // yuck
 		cards[i].typ = 0;
 		nrcards--;
