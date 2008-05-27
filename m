Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYE0Fwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYE0Fwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYE0Fwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:52:31 -0400
Received: from qmta09.westchester.pa.mail.comcast.net ([76.96.62.96]:57940
	"EHLO QMTA09.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754110AbYE0Fwa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:52:30 -0400
X-Authority-Analysis: v=1.0 c=1 a=MCpCiylFjwwA:10 a=1bI6uNfP4_8A:10
 a=D19gQVrFAAAA:8 a=ljdhCwAWjYUpvCMN-QoA:9 a=zfbmhX0FnVWSJadxupcA:7
 a=IDH03NcjD7Teg9abecI0OwSdUjEA:4 a=MSl-tDqOz04A:10 a=LY0hPdMaydYA:10
From: Dmitry Torokhov <dtor@insightbb.com>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Date: Tue, 27 May 2008 01:52:24 -0400
User-Agent: KMail/1.9.3
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
References: <200805162225.44284.bonbons@linux-vserver.org> <20080523044430.GA9809@anvil.corenet.prv> <20080523225714.3f0953f3@neptune.home>
In-Reply-To: <20080523225714.3f0953f3@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805270152.25744.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008 16:57, Bruno Prémont wrote:
> On Fri, 23 May 2008 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > Ah, ok, great.. I think we simply need to move dritek out of the
> > > place where you put it in so it does not interfere with our efforts
> > > to resume keyboard and mouse ;) I will see what I can do there..
> > > 
> > 
> > So what about the patch below? Does it work for you?
> > 
> > Thanks!
> 
> Hi Dmitry,
> 
> Yes, this patch works for me (in combination with
> http://lkml.org/lkml/2008/5/16/430 ), see attached boot+suspend&resume
> log.
> 
> You will eventually note the following lines during resume process:
> ...
> [  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60 -> i8042 (command) [15985]
> [  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [15985]
> [  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 0, 0) [15985]
> [  150.588965] atkbd.c: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
> [  150.588965] atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
> [  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [15985]
> [  150.609410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [15987]
> ...
> 

I see. Could you please try the patch below (in addition to the other
2 you have) and see if that 00 keycode is still reported?

Thanks! 

-- 
Dmitry

Input: atkbd - mark keyboard as disabled when suspending/unloading

This will shut off garbage that may come from KBD port during resume.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/atkbd.c |    2 ++
 1 file changed, 2 insertions(+)

Index: work/drivers/input/keyboard/atkbd.c
===================================================================
--- work.orig/drivers/input/keyboard/atkbd.c
+++ work/drivers/input/keyboard/atkbd.c
@@ -807,6 +807,8 @@ static int atkbd_activate(struct atkbd *
 static void atkbd_cleanup(struct serio *serio)
 {
 	struct atkbd *atkbd = serio_get_drvdata(serio);
+
+	atkbd_disable(atkbd);
 	ps2_command(&atkbd->ps2dev, NULL, ATKBD_CMD_RESET_BAT);
 }
 
