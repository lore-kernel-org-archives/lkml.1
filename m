Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYCMP4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYCMP4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYCMP42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:56:28 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:46287 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYCMP41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:56:27 -0400
X-Greylist: delayed 3456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 11:56:27 EDT
Message-ID: <47D94129.5030601@gmx.de>
Date: Thu, 13 Mar 2008 15:58:49 +0100
From: Ingo van Lil <inguin@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080226 Fedora/2.0.0.12-1.fc8 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix nested switch statements in dummy_hcd.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.2 (/)
X-Spam-Report: --- Start der SpamAssassin 3.2.4 Textanalyse (0.2 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	1.6 TVD_RCVD_IP            TVD_RCVD_IP
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 67388a68055134b384ea872eafacefb2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

this patch fixes a messed up combination of two nested switch statements
in drivers/usb/gadget/dummy_hcd.c. According to the USB spec (section
5.8.3) the maximum packet size for bulk endpoints can be 512 for
high-speed devices and 8, 16, 32 or 64 for full-speed devices. Low-speed
devices must not have bulk endpoints.

Cheers,
Ingo


Signed-off-by: Ingo van Lil <inguin@gmx.de>
---

--- linux-2.6.23.1/drivers/usb/gadget/dummy_hcd.c.orig	2008-03-13 15:45:35.000000000 +0100
+++ linux-2.6.23.1/drivers/usb/gadget/dummy_hcd.c	2008-03-13 15:45:39.000000000 +0100
@@ -363,16 +363,14 @@
  		case USB_SPEED_HIGH:
  			if (max == 512)
  				break;
-			/* conserve return statements */
-		default:
-			switch (max) {
-			case 8: case 16: case 32: case 64:
+			goto done;
+		case USB_SPEED_FULL:
+			if (max == 8 || max == 16 || max == 32 || max == 64)
  				/* we'll fake any legal size */
  				break;
-			default:
-		case USB_SPEED_LOW:
-				goto done;
-			}
+			/* save a return statement */
+		default:
+			goto done;
  		}
  		break;
  	case USB_ENDPOINT_XFER_INT:
