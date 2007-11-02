Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXKBWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXKBWS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbXKBWST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:18:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59044 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbXKBWST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:18:19 -0400
X-Greylist: delayed 4045 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 18:18:18 EDT
Date: Fri, 2 Nov 2007 22:10:50 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@suse.cz
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Use list_for_each_entry instead of list_for_each in sound/oss
 drivers.
Message-ID: <Pine.LNX.4.64.0711022207140.489@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Combine list_for_each and list_entry into list_for_each_entry.

An excerpt of the semantic patch implementing these changes is as follows:

@ra@
type T,T1;
identifier I, x;
expression E, E1, E2;
iterator list_for_each_entry;
@@

   <... when != _Y(I)
- list_for_each(_X(I),E1)
+ list_for_each_entry(x,E1,E2)
   {
       ... when != \(_Y(I)\|_X(I)\|x=E\)
 	  when != T1 x;
-     x = list_entry(_X(I),T,E2);
       ... when != \(_Y(I)\|_X(I)\|x=E\)
   }
   ...>

@@
type T;
identifier I;
expression E1, E2;
@@

- struct list_head *I;
+ T *I;
   <+... when != _Y(I)
- list_for_each(_X(I),E1)
+ list_for_each_entry(I,E1,E2)
   {
       <+... when != _Y(I)
-     list_entry(_X(I),T,E2)
+     I
       ...+>
   }
   ...+>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/sound/oss/ac97_codec.c b/sound/oss/ac97_codec.c
--- a/sound/oss/ac97_codec.c 2007-06-02 22:32:47.000000000 +0200
+++ b/sound/oss/ac97_codec.c 2007-11-02 07:27:37.000000000 +0100
@@ -815,7 +815,6 @@ int ac97_probe_codec(struct ac97_codec *
  	int i;
  	char cidbuf[CODEC_ID_BUFSZ];
  	u16 f;
-	struct list_head *l;
  	struct ac97_driver *d;

  	/* wait for codec-ready state */
@@ -891,8 +890,7 @@ int ac97_probe_codec(struct ac97_codec *
  	mutex_lock(&codec_mutex);
  	list_add(&codec->list, &codecs);

-	list_for_each(l, &codec_drivers) {
-		d = list_entry(l, struct ac97_driver, list);
+	list_for_each_entry(d, &codec_drivers, list) {
  		if ((codec->model ^ d->codec_id) & d->codec_mask)
  			continue;
  		if(d->probe(codec, d) == 0)
@@ -1400,14 +1398,12 @@ EXPORT_SYMBOL(ac97_set_adc_rate);

  static int swap_headphone(int remove_master)
  {
-	struct list_head *l;
  	struct ac97_codec *c;

  	if (remove_master) {
  		mutex_lock(&codec_mutex);
-		list_for_each(l, &codecs)
+		list_for_each_entry(c, &codecs, list)
  		{
-			c = list_entry(l, struct ac97_codec, list);
  			if (supported_mixer(c, SOUND_MIXER_PHONEOUT))
  				c->supported_mixers &= ~SOUND_MASK_PHONEOUT;
  		}
diff -u -p -b -B a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
--- a/sound/oss/swarm_cs4297a.c 2007-06-02 22:32:47.000000000 +0200
+++ b/sound/oss/swarm_cs4297a.c 2007-11-02 07:27:46.000000000 +0100
@@ -1532,14 +1532,12 @@ static int cs4297a_open_mixdev(struct in
  {
  	int minor = iminor(inode);
  	struct cs4297a_state *s=NULL;
-	struct list_head *entry;

  	CS_DBGOUT(CS_FUNCTION | CS_OPEN, 4,
  		  printk(KERN_INFO "cs4297a: cs4297a_open_mixdev()+\n"));

-	list_for_each(entry, &cs4297a_devs)
+	list_for_each_entry(s, &cs4297a_devs, list)
  	{
-		s = list_entry(entry, struct cs4297a_state, list);
  		if(s->dev_mixer == minor)
  			break;
  	}
