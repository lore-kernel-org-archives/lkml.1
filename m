Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbZDWIA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbZDWIA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbZDWHgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:36:52 -0400
Received: from sous-sol.org ([216.99.217.87]:47512 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757642AbZDWHgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:36:51 -0400
Message-Id: <20090423073043.020447940@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 091/100] Input: gameport - fix attach driver code
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=input-gameport-fix-attach-driver-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

upstream commit: 4ced8e7cb990a2c3bbf0ac7f27b35c890e7ce895

The commit 6902c0bead4ce266226fc0c5b3828b850bdc884a that moved
driver registration out of kgameportd thread was incomplete and
did not add the code necessary to actually attach driver to
already registered devices, rectify that.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
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
@@ -706,14 +704,14 @@ static int gameport_driver_remove(struct
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
 

