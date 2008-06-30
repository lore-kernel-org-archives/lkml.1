Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYF3POE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYF3POE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYF3PNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:13:55 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:44673 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYF3PNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=w99vDx21xU5BieA32zfxJFzkH0Zvd0ln9GWMNZpIaczL65USdemCNMdij6sdOczer6
         JCSfKmID/mAjMCpSHtK4cVGHtf8ikr6iL5OpiIrQarHT2tHMItc+igHx6u/G7kcaQwkr
         QT/bmezr4vurMX4Tor6kNe77/PQOZkcyNR4Fk=
Date: Mon, 30 Jun 2008 11:13:50 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] Input updates for 2.6.26-rc8
Message-ID: <20080630151349.GA19527@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a new keycode
definition and changes to force-feedback core locking that bring it in
sync with the recent locking changes in the input core. While these
locking changes have not been exposed in 'next' I feel they should make
into 2.6.26, because right now FF is simply broken - input_event takes a
spinlock and then calls input_ff_event that tries to take a mutex.

Changelog:
---------

Bastien Nocera (1):
      Input: add KEY_MEDIA_REPEAT definition

Dmitry Torokhov (1):
      Input: fix locking in force-feedback core


Diffstat:
--------

 drivers/input/ff-core.c |   17 +++++++++++------
 include/linux/input.h   |    2 +-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index eebc724..4c01464 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -166,8 +166,10 @@ int input_ff_upload(struct input_dev *dev, struct ff_effect *effect,
 	if (ret)
 		goto out;
 
+	spin_lock_irq(&dev->event_lock);
 	ff->effects[id] = *effect;
 	ff->effect_owners[id] = file;
+	spin_unlock_irq(&dev->event_lock);
 
  out:
 	mutex_unlock(&ff->mutex);
@@ -189,16 +191,22 @@ static int erase_effect(struct input_dev *dev, int effect_id,
 	if (error)
 		return error;
 
+	spin_lock_irq(&dev->event_lock);
 	ff->playback(dev, effect_id, 0);
+	ff->effect_owners[effect_id] = NULL;
+	spin_unlock_irq(&dev->event_lock);
 
 	if (ff->erase) {
 		error = ff->erase(dev, effect_id);
-		if (error)
+		if (error) {
+			spin_lock_irq(&dev->event_lock);
+			ff->effect_owners[effect_id] = file;
+			spin_unlock_irq(&dev->event_lock);
+
 			return error;
+		}
 	}
 
-	ff->effect_owners[effect_id] = NULL;
-
 	return 0;
 }
 
@@ -263,8 +271,6 @@ int input_ff_event(struct input_dev *dev, unsigned int type,
 	if (type != EV_FF)
 		return 0;
 
-	mutex_lock(&ff->mutex);
-
 	switch (code) {
 	case FF_GAIN:
 		if (!test_bit(FF_GAIN, dev->ffbit) || value > 0xffff)
@@ -286,7 +292,6 @@ int input_ff_event(struct input_dev *dev, unsigned int type,
 		break;
 	}
 
-	mutex_unlock(&ff->mutex);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(input_ff_event);
diff --git a/include/linux/input.h b/include/linux/input.h
index e075c4b..d150c57 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -534,8 +534,8 @@ struct input_absinfo {
 
 #define KEY_FRAMEBACK		0x1b4	/* Consumer - transport controls */
 #define KEY_FRAMEFORWARD	0x1b5
-
 #define KEY_CONTEXT_MENU	0x1b6	/* GenDesc - system context menu */
+#define KEY_MEDIA_REPEAT	0x1b7	/* Consumer - transport control */
 
 #define KEY_DEL_EOL		0x1c0
 #define KEY_DEL_EOS		0x1c1


-- 
Dmitry
