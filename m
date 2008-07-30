Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbYGaAL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbYGaAL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762156AbYGaAKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:10:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:38401 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762154AbYGaAKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:10:32 -0400
Date: Wed, 30 Jul 2008 16:58:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [patch 19/62] USB: fix usb serial pm counter decrement for
	disconnected interfaces
Message-ID: <20080730235828.GS12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-usb-serial-pm-counter-decrement-for-disconnected-interfaces.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Oliver Neukum <oliver@neukum.org>

commit 62ad296b6ca78bd123864c138814c0a597873693 upstream

usb serial decrements the pm counter even if an interface has been
disconnected. If it was a logical disconnect the interface may belong
already to another driver. This patch introduces a check for disconnected
interfaces.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -283,7 +283,10 @@ static void serial_close(struct tty_stru
 	}
 
 	if (port->open_count == 0) {
-		usb_autopm_put_interface(port->serial->interface);
+		mutex_lock(&port->serial->disc_mutex);
+		if (!port->serial->disconnected)
+			usb_autopm_put_interface(port->serial->interface);
+		mutex_unlock(&port->serial->disc_mutex);
 		module_put(port->serial->type->driver.owner);
 	}
 

-- 
