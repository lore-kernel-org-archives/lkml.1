Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYK0M5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYK0M5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYK0M5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:57:39 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45947 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYK0M5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:57:38 -0500
Date: Thu, 27 Nov 2008 13:57:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/media/video/cx88/cx88-alsa.c: Adjust error-handling
 code
Message-ID: <Pine.LNX.4.64.0811271357100.15160@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the function cx88_audio_initdev, the value card has been created using
snd_card_new.  The other error handling code in this function frees the
value using snd_card_free.  I have thus changed the first error case to do
the same.  On the other hand, it may be that card is not sufficiently
initialized at this point to use snd_card_free, in which case something
else should be done to free the memory in the error case.

In the function snd_cx88_create the call kfree(chip) in one error case looks
suspicious, both because it is not done in the other error code, and
because chip points into the middle of the memory allocated by
snd_card_new, ie it is not itself associated with a separate kmalloc.
Therefore I have removed it.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S,S1;
position p1,p2,p3;
expression E,E1;
type T,T1;
expression *ptr != NULL;
@@

(
 if ((x@p1 = snd_card_new(...)) == NULL) S
|
 x@p1 = snd_card_new(...);
)
 ... when != snd_card_free(...,(T)x,...)
     when != if (...) { <+... snd_card_free(...,(T)x,...) ...+> }
     when != true x == NULL || ...
     when != x = E
     when != E = (T)x
     when any
(
 if (x == NULL || ...) S1
|
 if@p2 (...) {
  ... when != snd_card_free(...,(T1)x,...)
      when != if (...) { <+... snd_card_free(...,(T1)x,...) ...+> }
      when != x = E1
      when != E1 = (T1)x
(
  return \(0\|<+...x...+>\|ptr\);
|
  return@p3 ...;
)
}
)

@ script:python @
p1 << r.p1;
p3 << r.p3;
@@

print "* file: %s snd_card_new: %s return: %s" % (p1[0].file,p1[0].line,p3[0].line)

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/cx88/cx88-alsa.c           |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 06f171a..66c755c 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -742,7 +742,6 @@ static int __devinit snd_cx88_create(struct snd_card *card,
 	core = cx88_core_get(pci);
 	if (NULL == core) {
 		err = -EINVAL;
-		kfree (chip);
 		return err;
 	}
 
@@ -812,7 +811,7 @@ static int __devinit cx88_audio_initdev(struct pci_dev *pci,
 
 	err = snd_cx88_create(card, pci, &chip);
 	if (err < 0)
-		return (err);
+		goto error;
 
 	err = snd_cx88_pcm(chip, 0, "CX88 Digital");
 	if (err < 0)
