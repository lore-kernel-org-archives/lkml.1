Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYCaQFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYCaQFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYCaQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:04:52 -0400
Received: from mga06.intel.com ([134.134.136.21]:46359 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbYCaQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:04:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,583,1199692800"; 
   d="scan'208,223";a="363443819"
Message-ID: <47F10971.4070804@linux.intel.com>
Date: Mon, 31 Mar 2008 08:55:29 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Bug in es1968 driver
Content-Type: multipart/mixed;
 boundary="------------050501060503080008080207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050501060503080008080207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

www.kerneloops.org has found a bug in the es1968 driver (as one of the more popular issues):

static unsigned short snd_es1968_ac97_read(struct snd_ac97 *ac97, unsigned short reg)
{
         u16 data = 0;
         struct es1968 *chip = ac97->private_data;
         unsigned long flags;

         snd_es1968_ac97_wait(chip);

         spin_lock_irqsave(&chip->ac97_lock, flags);
         outb(reg | 0x80, chip->io_port + ESM_AC97_INDEX);
         /*msleep(1);*/

         if (! snd_es1968_ac97_wait(chip)) {
                 data = inw(chip->io_port + ESM_AC97_DATA);
                 /*msleep(1);*/
         }
         spin_unlock_irqrestore(&chip->ac97_lock, flags);

         return data;
}

in this file, snd_es1968_ac97_wait() is a sleeping function... which conveniently gets called
while the ac97_lock spinlock is held....

patch below (and attached in case thunderbird decides to pee all over it):


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] Fix sleep-while-holding-lock bug in es1968

snd_es1968_ac97_read() calls snd_es1968_ac97_wait() first outside a locked area,
and later, while holding a lock.
snd_es1968_ac97_wait() has a polling loop with a cond_resched() inside it.. which
sleeps, so the second call is invalid.

This patch adds a version of the wait function that just pure polls. While this
is not very elegant in principle, it's very likely the easiest thing to do here,
we already checked if the chip was ready (while yielding) just before, so it is
very unlikely to take a long time here.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  sound/pci/es1968.c |   14 +++++++++++++-
  1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 25ccfce..71d459d 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -617,6 +617,18 @@ static int snd_es1968_ac97_wait(struct es1968 *chip)
  	return 1; /* timeout */
  }

+static int snd_es1968_ac97_wait_poll(struct es1968 *chip)
+{
+	int timeout = 100000;
+
+	while (timeout-- > 0) {
+		if (!(inb(chip->io_port + ESM_AC97_INDEX) & 1))
+			return 0;
+	}
+	snd_printd("es1968: ac97 timeout\n");
+	return 1; /* timeout */
+}
+
  static void snd_es1968_ac97_write(struct snd_ac97 *ac97, unsigned short reg, unsigned short val)
  {
  	struct es1968 *chip = ac97->private_data;
@@ -645,7 +657,7 @@ static unsigned short snd_es1968_ac97_read(struct snd_ac97 *ac97, unsigned short
  	outb(reg | 0x80, chip->io_port + ESM_AC97_INDEX);
  	/*msleep(1);*/

-	if (! snd_es1968_ac97_wait(chip)) {
+	if (! snd_es1968_ac97_wait_poll(chip)) {
  		data = inw(chip->io_port + ESM_AC97_DATA);
  		/*msleep(1);*/
  	}
-- 
1.5.4.4




--------------050501060503080008080207
Content-Type: text/x-patch;
 name="0001-Fix-sleep-while-holding-lock-bug-in-es1968.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Fix-sleep-while-holding-lock-bug-in-es1968.patch"

>From 1ab58fbe99320e4d842c7e6ccc6db76c286f1902 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 31 Mar 2008 05:20:58 -0700
Subject: [PATCH] Fix sleep-while-holding-lock bug in es1968

snd_es1968_ac97_read() calls snd_es1968_ac97_wait() first outside a locked area,
and later, while holding a lock.
snd_es1968_ac97_wait() has a polling loop with a cond_resched() inside it.. which
sleeps, so the second call is invalid.

This patch adds a version of the wait function that just pure polls. While this
is not very elegant in principle, it's very likely the easiest thing to do here,
we already checked if the chip was ready (while yielding) just before, so it is
very unlikely to take a long time here.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 sound/pci/es1968.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 25ccfce..71d459d 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -617,6 +617,18 @@ static int snd_es1968_ac97_wait(struct es1968 *chip)
 	return 1; /* timeout */
 }
 
+static int snd_es1968_ac97_wait_poll(struct es1968 *chip)
+{
+	int timeout = 100000;
+
+	while (timeout-- > 0) {
+		if (!(inb(chip->io_port + ESM_AC97_INDEX) & 1))
+			return 0;
+	}
+	snd_printd("es1968: ac97 timeout\n");
+	return 1; /* timeout */
+}
+
 static void snd_es1968_ac97_write(struct snd_ac97 *ac97, unsigned short reg, unsigned short val)
 {
 	struct es1968 *chip = ac97->private_data;
@@ -645,7 +657,7 @@ static unsigned short snd_es1968_ac97_read(struct snd_ac97 *ac97, unsigned short
 	outb(reg | 0x80, chip->io_port + ESM_AC97_INDEX);
 	/*msleep(1);*/
 
-	if (! snd_es1968_ac97_wait(chip)) {
+	if (! snd_es1968_ac97_wait_poll(chip)) {
 		data = inw(chip->io_port + ESM_AC97_DATA);
 		/*msleep(1);*/
 	}
-- 
1.5.4.4


--------------050501060503080008080207--
