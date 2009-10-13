Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbZJMDZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbZJMDZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbZJMDZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:25:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:2461 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbZJMDZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=adOV2KQtVFplIvddiGB4kTl9+5jW7PWtqMTMQ9EgQJN3d7ctD3yzys7PpnknXEfy34
         2SyJVEtsQONEzrdyKJ7t5K4yonNcIpRquW6EiZ8C36FwBXiKxq0EhzMq5woIrKrYuf4t
         Liw6YSZpODxoQIBA0CXpY9gLdjBUiSRmYoYOk=
Date: Mon, 12 Oct 2009 20:24:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091013032414.GC2887@core.coreip.homeip.net>
References: <20091011162155.GA4260@Pilar.aei.mpg.de> <20091011180134.GA5197@core.coreip.homeip.net> <20091011193100.GA4410@Pilar.aei.mpg.de> <20091012090224.GB7403@core.coreip.homeip.net> <20091012100929.GA4402@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012100929.GA4402@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:09:29PM +0200, Carlos R. Mafra wrote:
> On Mon 12.Oct'09 at  2:02:24 -0700, Dmitry Torokhov wrote:
> > Still, I am curious to know why we can't simply reinitialize ALPS from
> > the get go, could you please send me a dmesg of resume done with
> > i8042.debug? Thanks!
> 
> The dmesg was too big, so I uploaded the ~5000 lines worth of syslog
> from 2.6.32-rc4 with i8042.debug info with a suspend to RAM to
> 
> http://www.aei.mpg.de/~crmafra/syslog-i8042.debug.txt
> 
> I hope this helps!

Could you please try this patch and let me know if it helps. Anotehr
i8042.dmesg would be much appreciated.

-- 
Dmitry


Input: psmouse - retry reset command if first one fails

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Sometimes mice are not ready for a command and respond with 0xfe;
failure to reset mouse can lead to losing the device to let's try
harder and repeat the command after delay.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/psmouse-base.c |   13 ++++++++++++-
 drivers/input/serio/libps2.c       |   31 +++++++++++++++++--------------
 2 files changed, 29 insertions(+), 15 deletions(-)


diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 690aed9..52ad50f 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -395,8 +395,19 @@ int psmouse_sliced_command(struct psmouse *psmouse, unsigned char command)
 int psmouse_reset(struct psmouse *psmouse)
 {
 	unsigned char param[2];
+	int error;
+
+	error = ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_RESET_BAT);
+	if (error == -EAGAIN) {
+		/*
+		 * Controller requested us to resend the command.
+		 */
+		msleep(100);
+		error = ps2_command(&psmouse->ps2dev,
+				    param, PSMOUSE_CMD_RESET_BAT);
+	}
 
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_RESET_BAT))
+	if (error)
 		return -1;
 
 	if (param[0] != PSMOUSE_RET_BAT && param[1] != PSMOUSE_RET_ID)
diff --git a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
index f3876ac..5201b0c 100644
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -39,7 +39,7 @@ MODULE_LICENSE("GPL");
 int ps2_sendbyte(struct ps2dev *ps2dev, unsigned char byte, int timeout)
 {
 	serio_pause_rx(ps2dev->serio);
-	ps2dev->nak = 1;
+	ps2dev->nak = ETIME;
 	ps2dev->flags |= PS2_FLAG_ACK;
 	serio_continue_rx(ps2dev->serio);
 
@@ -187,17 +187,17 @@ int __ps2_command(struct ps2dev *ps2dev, unsigned char *param, int command)
 	int timeout;
 	int send = (command >> 12) & 0xf;
 	int receive = (command >> 8) & 0xf;
-	int rc = -1;
+	int rc;
 	int i;
 
 	if (receive > sizeof(ps2dev->cmdbuf)) {
 		WARN_ON(1);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (send && !param) {
 		WARN_ON(1);
-		return -1;
+		return -EINVAL;
 	}
 
 	serio_pause_rx(ps2dev->serio);
@@ -213,13 +213,16 @@ int __ps2_command(struct ps2dev *ps2dev, unsigned char *param, int command)
 	 * ACKing the reset command, and so it can take a long
 	 * time before the ACK arrrives.
 	 */
-	if (ps2_sendbyte(ps2dev, command & 0xff,
-			 command == PS2_CMD_RESET_BAT ? 1000 : 200))
+	rc = ps2_sendbyte(ps2dev, command & 0xff,
+			  command == PS2_CMD_RESET_BAT ? 1000 : 200);
+	if (rc)
 		goto out;
 
-	for (i = 0; i < send; i++)
-		if (ps2_sendbyte(ps2dev, param[i], 200))
+	for (i = 0; i < send; i++) {
+		rc = ps2_sendbyte(ps2dev, param[i], 200);
+		if (rc)
 			goto out;
+	}
 
 	/*
 	 * The reset command takes a long time to execute.
@@ -240,10 +243,10 @@ int __ps2_command(struct ps2dev *ps2dev, unsigned char *param, int command)
 		for (i = 0; i < receive; i++)
 			param[i] = ps2dev->cmdbuf[(receive - 1) - i];
 
-	if (ps2dev->cmdcnt && (command != PS2_CMD_RESET_BAT || ps2dev->cmdcnt != 1))
+	if (ps2dev->cmdcnt && (command != PS2_CMD_RESET_BAT || ps2dev->cmdcnt != 1)) {
+		rc = ETIME;
 		goto out;
-
-	rc = 0;
+	}
 
  out:
 	serio_pause_rx(ps2dev->serio);
@@ -293,13 +296,13 @@ int ps2_handle_ack(struct ps2dev *ps2dev, unsigned char data)
 
 		case PS2_RET_NAK:
 			ps2dev->flags |= PS2_FLAG_NAK;
-			ps2dev->nak = PS2_RET_NAK;
+			ps2dev->nak = EAGAIN;
 			break;
 
 		case PS2_RET_ERR:
 			if (ps2dev->flags & PS2_FLAG_NAK) {
 				ps2dev->flags &= ~PS2_FLAG_NAK;
-				ps2dev->nak = PS2_RET_ERR;
+				ps2dev->nak = EIO;
 				break;
 			}
 
@@ -365,7 +368,7 @@ EXPORT_SYMBOL(ps2_handle_response);
 void ps2_cmd_aborted(struct ps2dev *ps2dev)
 {
 	if (ps2dev->flags & PS2_FLAG_ACK)
-		ps2dev->nak = 1;
+		ps2dev->nak = EIO;
 
 	if (ps2dev->flags & (PS2_FLAG_ACK | PS2_FLAG_CMD))
 		wake_up(&ps2dev->wait);
