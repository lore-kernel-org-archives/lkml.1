Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbZJMDD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbZJMDD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758782AbZJMDD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:03:59 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:50074 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbZJMDD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KFLkkd8jfoGCGcRWeNqtBlGw+EsJAvjjIsANf8U4Y5grnVUU43HD01X6qXza0ja0Tt
         SYsHcCK5NpzKn6rmTvxYFnEcRgosQKTUKnumaLT3cNRgnV3ErIqFrG+V/TdQBwnBVkSZ
         8wbKSIngTcJFXiN42bXlvkeNGrzX1Dej1Xgl0=
Date: Mon, 12 Oct 2009 20:03:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org
Subject: Re: Regression?: keyboard state/LED inconsistency in
	2.6.32-rc1/2,3,4
Message-ID: <20091013030314.GA2887@core.coreip.homeip.net>
References: <200910121118.29415.mitov@issp.bas.bg> <20091012083015.GA11483@suse.cz> <20091012085708.GA7403@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012085708.GA7403@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 01:57:08AM -0700, Dmitry Torokhov wrote:
> On Mon, Oct 12, 2009 at 10:30:15AM +0200, Vojtech Pavlik wrote:
> > On Mon, Oct 12, 2009 at 11:18:28AM +0300, Marin Mitov wrote:
> > > Hello,
> > > 
> > > I'm testing 2.6.32-rc1/2,3,4 and I'm using 2.6.31.3.
> > > There is a difference in keyboard/LED behavior.
> > > If in BIOS NumLock is set on, when the kernel starts
> > > it puts NumLock off and the LED state is off in 2.6.31.3
> > > (which is consistent), but in 2.6.32-rc1/2,3,4 the LED
> > > stays on (and this is not consistent with keyboard's state).
> > > 
> > > Comparing drivers/input/keyboard/atkbd.c (I'm using it)
> > > in 2.6.31.3 and 2.6.32-rc1/2,3,4 among others changes I
> > > found the following lines (see the patch bellow) deleted,
> > > so I propose either to add them again (this will restore 
> > > keyboard/LED consistency) or revert the patch that has 
> > > deleted them.
> > 
> > Oh, wow, those lines are quite clearly needed, I wonder why they got
> > deleted, and I'm too lazy to find the commit comment ...
> > 
> 
> Hmm, it appears I deleted a bit too much.. At some point I was thinking
> the input core would reset LEDs and repeat rate on newly created device
> but it was wrong idea. Unfortunately I was careless in applying atkbd
> patch removing resume support (which should be handled by the input
> core)...
> 

Could you please try the patch below and let me know if it fixes
things?

Thanks!

-- 
Dmitry


Input: atkbd - restore resetting LED state at startup

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Fix breakage caused by commit 9605fb48e1998935a5ee70c965f90ad1ac023add
While the input core indeed takes care of restoring led state and
typematic settings upon resume the driver still need to initialize
them properly when registering a new device

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/atkbd.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)


diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 4709e15..03d961f 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -770,6 +770,30 @@ static int atkbd_select_set(struct atkbd *atkbd, int target_set, int allow_extra
 	return 3;
 }
 
+static int atkbd_reset_state(struct atkbd *atkbd)
+{
+        struct ps2dev *ps2dev = &atkbd->ps2dev;
+	unsigned char param[1];
+
+	/*
+	 * Set the LEDs to a predefined state (all off).
+	 */
+
+	param[0] = 0;
+	if (ps2_command(ps2dev, param, ATKBD_CMD_SETLEDS))
+		return -1;
+
+	/*
+	 * Set autorepeat to fastest possible.
+	 */
+
+	param[0] = 0;
+	if (ps2_command(ps2dev, param, ATKBD_CMD_SETREP))
+		return -1;
+
+	return 0;
+}
+
 static int atkbd_activate(struct atkbd *atkbd)
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
@@ -1087,6 +1111,7 @@ static int atkbd_connect(struct serio *serio, struct serio_driver *drv)
 		}
 
 		atkbd->set = atkbd_select_set(atkbd, atkbd_set, atkbd_extra);
+		atkbd_reset_state(atkbd);
 		atkbd_activate(atkbd);
 
 	} else {
@@ -1267,6 +1292,7 @@ static ssize_t atkbd_set_extra(struct atkbd *atkbd, const char *buf, size_t coun
 
 		atkbd->dev = new_dev;
 		atkbd->set = atkbd_select_set(atkbd, atkbd->set, value);
+		atkbd_reset_state(atkbd);
 		atkbd_activate(atkbd);
 		atkbd_set_keycode_table(atkbd);
 		atkbd_set_device_attrs(atkbd);
