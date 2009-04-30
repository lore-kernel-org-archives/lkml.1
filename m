Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbZD3R3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbZD3R3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764649AbZD3RII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:08 -0400
Received: from kroah.org ([198.145.64.141]:56626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764632AbZD3RH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:45 2009
Message-Id: <20090430165745.637508470@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dtor@mail.ru>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 49/88] Input: gameport - fix attach driver code
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0090-Input-gameport-fix-attach-driver-code.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

upstream commit: 4ced8e7cb990a2c3bbf0ac7f27b35c890e7ce895

The commit 6902c0bead4ce266226fc0c5b3828b850bdc884a that moved
driver registration out of kgameportd thread was incomplete and
did not add the code necessary to actually attach driver to
already registered devices, rectify that.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/gameport/gameport.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

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
 
@@ -230,7 +229,6 @@ static void gameport_find_driver(struct 
 
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
@@ -707,14 +705,14 @@ static int gameport_driver_remove(struct
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
 


