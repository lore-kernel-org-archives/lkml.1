Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZDTIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZDTIEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZDTIET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:04:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:4049 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZDTIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:04:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=mRVdjVWGaVugVy3SLgNl/MKXicxiszVo3IJLO3GYQmIm7J4Tnx+DAA7KxIX1BPFh06
         9PkL9+PPCR0rLqtiHfbQySS3OnLr1wECvuhQ0qM1yNTBJBCU3eGFMQ4phdcb4WrRckX9
         SYdc0jOqDL8OTEexEcAgGWQakJvYSoMwPSx+U=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Andrew S. Johnson" <andy@asjohnson.com>
Subject: Re: TMDC Joystick no longer works in kernel 2.6.28
Date: Mon, 20 Apr 2009 01:04:09 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200901101553.40515.andy@asjohnson.com>
In-Reply-To: <200901101553.40515.andy@asjohnson.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904200104.09483.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Saturday 10 January 2009 13:53:40 Andrew S. Johnson wrote:
> Up through kernel version 2.6.27.9 I have had no problems with
> my joystick on the game port.  Now with 2.6.28, the game port
> is recognized when the gameport and ns558 modules load, but
> loading the tmdc module doesn't also automatically load joydev,
> and even loading joydev manually doesn't give me a working
> joystick.  There are no error messages in dmesg, /var/log/messages,
> or /var/log/syslog.  This is on Slackware 12.1, so I don't think
> it's a distro issue.  Do I need to do something different than
> in the past to make it work, or is there some debug I can turn
> on to give more info?
>

The patch below should help with joysticks attached to gameports;
it should appear in 2.6.30-rc3.

-- 
Dmitry

Input: gameport - fix attach driver code

The commit 6902c0bead4ce266226fc0c5b3828b850bdc884a that moved
driver registration out of kgameportd thread was incomplete and
did not add the code necessary to actually attach driver to
already registered devices, rectify that.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/gameport/gameport.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/input/gameport/gameport.c 
b/drivers/input/gameport/gameport.c
index ebf4be5..2d175b5 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -50,9 +50,8 @@ static LIST_HEAD(gameport_list);
 
 static struct bus_type gameport_bus;
 
-static void gameport_add_driver(struct gameport_driver *drv);
 static void gameport_add_port(struct gameport *gameport);
-static void gameport_destroy_port(struct gameport *gameport);
+static void gameport_attach_driver(struct gameport_driver *drv);
 static void gameport_reconnect_port(struct gameport *gameport);
 static void gameport_disconnect_port(struct gameport *gameport);
 
@@ -230,7 +229,6 @@ static void gameport_find_driver(struct gameport 
*gameport)
 
 enum gameport_event_type {
 	GAMEPORT_REGISTER_PORT,
-	GAMEPORT_REGISTER_DRIVER,
 	GAMEPORT_ATTACH_DRIVER,
 };
 
@@ -374,8 +372,8 @@ static void gameport_handle_event(void)
 				gameport_add_port(event->object);
 				break;
 
-			case GAMEPORT_REGISTER_DRIVER:
-				gameport_add_driver(event->object);
+			case GAMEPORT_ATTACH_DRIVER:
+				gameport_attach_driver(event->object);
 				break;
 
 			default:
@@ -706,14 +704,14 @@ static int gameport_driver_remove(struct device *dev)
 	return 0;
 }
 
-static void gameport_add_driver(struct gameport_driver *drv)
+static void gameport_attach_driver(struct gameport_driver *drv)
 {
 	int error;
 
-	error = driver_register(&drv->driver);
+	error = driver_attach(&drv->driver);
 	if (error)
 		printk(KERN_ERR
-			"gameport: driver_register() failed for %s, error: %d\n",
+			"gameport: driver_attach() failed for %s, error: %d\n",
 			drv->driver.name, error);
 }
 
-- 
1.6.0.6


