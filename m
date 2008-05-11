Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYEKMvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYEKMvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYEKMvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:51:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42954 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbYEKMvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:51:08 -0400
Date: Sun, 11 May 2008 14:51:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, ricardo@scarybox.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] sound/oss: use unsigned for loop index
Message-ID: <Pine.LNX.4.64.0805111450350.29620@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

A few more cases in the spirit of the patch "Trivial: Replacement of always
>0 ints with unsigned ints" submitted by Ricardo Martins <ricardo@scarybox.net>

The transformation was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@ // find anything that might decrement the variable
identifier i;
expression E;
position p;
@@

  int i@p;
  ...
(
  &i
|
  i--
|
  --i
|
  i-=E
|
  i+=E
)

@x disable decl_init@
identifier r.i;
expression E;
position p1 != r.p;
@@

(
  volatile int i = 0;
|
  volatile int i;
|
+ unsigned
  int i@p1 = 0;
|
+ unsigned
  int i@p1;
)
  <... when != i = E      
(
  i = 0
|
  i = 1
)
  ...>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 sound/oss/dmasound/dmasound_core.c |    2 +-
 sound/oss/msnd.c                   |    4 ++--
 sound/oss/sb_common.c              |    6 +++---
 sound/oss/waveartist.c             |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -u -p a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
--- a/sound/oss/dmasound/dmasound_core.c 2008-04-07 13:50:28.000000000 +0200
+++ b/sound/oss/dmasound/dmasound_core.c 2008-05-11 12:19:29.000000000 +0200
@@ -423,7 +423,7 @@ static int sq_allocate_buffers(struct so
 
 static void sq_release_buffers(struct sound_queue *sq)
 {
-	int i;
+	unsigned int i;
 
 	if (sq->buffers) {
 		for (i = 0; i < sq->numBufs; i++)
diff -u -p a/sound/oss/msnd.c b/sound/oss/msnd.c
--- a/sound/oss/msnd.c 2008-04-07 13:50:28.000000000 +0200
+++ b/sound/oss/msnd.c 2008-05-11 12:19:27.000000000 +0200
@@ -49,7 +49,7 @@ static int			num_devs;
 
 int msnd_register(multisound_dev_t *dev)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < MSND_MAX_DEVS; ++i)
 		if (devs[i] == NULL)
@@ -65,7 +65,7 @@ int msnd_register(multisound_dev_t *dev)
 
 void msnd_unregister(multisound_dev_t *dev)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < MSND_MAX_DEVS; ++i)
 		if (devs[i] == dev)
diff -u -p a/sound/oss/sb_common.c b/sound/oss/sb_common.c
--- a/sound/oss/sb_common.c 2008-04-16 13:28:05.000000000 +0200
+++ b/sound/oss/sb_common.c 2008-05-11 12:19:36.000000000 +0200
@@ -84,7 +84,7 @@ static sb_devc *last_sb;		/* Last sb loa
 
 int sb_dsp_command(sb_devc * devc, unsigned char val)
 {
-	int i;
+	unsigned int i;
 	unsigned long limit;
 
 	limit = jiffies + HZ / 10;	/* Timeout */
@@ -600,7 +600,7 @@ int sb_dsp_detect(struct address_info *h
 			if (sb_dsp_command(devc, 0x09))
 				if (sb_dsp_command(devc, 0x00))	/* Enter WSS mode */
 				{
-					int i;
+					unsigned int i;
 
 					/* Have some delay */
 					for (i = 0; i < 10000; i++)
@@ -1009,7 +1009,7 @@ static int smw_midi_init(sb_devc * devc,
 {
 	int mpu_base = hw_config->io_base;
 	int mp_base = mpu_base + 4;		/* Microcontroller base */
-	int i;
+	unsigned int i;
 	unsigned char control;
 
 
diff -u -p a/sound/oss/waveartist.c b/sound/oss/waveartist.c
--- a/sound/oss/waveartist.c 2008-04-16 13:28:05.000000000 +0200
+++ b/sound/oss/waveartist.c 2008-05-11 12:19:27.000000000 +0200
@@ -1212,7 +1212,7 @@ static struct mixer_operations waveartis
 static void
 waveartist_mixer_reset(wavnc_info *devc)
 {
-	int i;
+	unsigned int i;
 
 	if (debug_flg & DEBUG_MIXER)
 		printk("%s: mixer_reset\n", devc->hw.name);
@@ -1417,7 +1417,7 @@ attach_waveartist(struct address_info *h
 static void __exit unload_waveartist(struct address_info *hw)
 {
 	wavnc_info *devc = NULL;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < nr_waveartist_devs; i++)
 		if (hw->io_base == adev_info[i].hw.io_base) {
