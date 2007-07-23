Return-Path: <linux-kernel-owner+w=401wt.eu-S1764544AbXGWG6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764544AbXGWG6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760880AbXGWG5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:58370 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757813AbXGWG4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:45 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SuSE Linux
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: usb_serial_suspend(): buggy(?) code
User-Agent: KMail/1.9.7
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20070723015128.GY26212@stusta.de>
In-Reply-To: <20070723015128.GY26212@stusta.de>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 23 Jul 2007 08:58:39 +0200
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200707230858.39752.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 23 Juli 2007 schrieb Adrian Bunk:
> Commit ec22559e0b7a05283a3413bda5d177e42c950e23 added the following 
> function to drivers/usb/serial/usb-serial.c:
> 
[..]
> 
> The Coverity checker spotted the inconsequent NULL checking for "serial".
> 
> Looking at the code it also doesn't seem to have been intended to always 
> return 0.

Coverity is right. The check for NULL is wrongly done and the error
return is lost.

	Regards
		Oliver
Signed-off-by: Oliver Neukum <oneukum@suse.de>
--

--- a/drivers/usb/serial/usb-serial.c	2007-07-23 08:47:35.000000000 +0200
+++ b/drivers/usb/serial/usb-serial.c	2007-07-23 08:49:20.000000000 +0200
@@ -1077,16 +1077,17 @@ int usb_serial_suspend(struct usb_interf
 	struct usb_serial_port *port;
 	int i, r = 0;
 
-	if (serial) {
-		for (i = 0; i < serial->num_ports; ++i) {
-			port = serial->port[i];
-			if (port)
-				kill_traffic(port);
-		}
+	if (!serial) /* device has been disconnected */
+		return 0;
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (port)
+			kill_traffic(port);
 	}
 
 	if (serial->type->suspend)
-		serial->type->suspend(serial, message);
+		r = serial->type->suspend(serial, message);
 
 	return r;
 }
