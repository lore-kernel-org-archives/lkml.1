Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbXH3WxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbXH3WxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbXH3WxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:53:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:35190 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbXH3WxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aQFbSq+XB9W+WRxvD+dlB1FqJJ1RmB2xiQgltkvh7is4NmdYcRcrNw0InkERqGKlC3wX0qxO02tVziW2U+Yv1ix2Ai2XbVyQz9qouCl8/j3edUNK9LXYPycy8s0NBsCgu2nI0WnUR8+QOBaVECDWu+DKxIr76TRF8TRuqfv/HM8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH] input: Silence 'unused variable' warning in iforce joystick driver
Date: Fri, 31 Aug 2007 00:50:03 +0200
User-Agent: KMail/1.9.7
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@ucw.cz>,
       Johann Deneux <johann.deneux@gmail.com>, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
References: <200708310013.12347.jesper.juhl@gmail.com> <alpine.LFD.0.999.0708310422200.31519@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708310422200.31519@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708310050.03786.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/2007, Satyam Sharma <satyam@infradead.org> wrote:
...
> 
> Hmm, would this not still give a warning when JOYSTICK_IFORCE_USB=y?

Arrgh, I messed that one up real good...  Thank you for your keen eye Satyam :-)


> [ I didn't know mixing code and declarations (not at top of statement
>   block) was accepted style in the kernel ... ]
> 
It's not the common case, but this is certainly not the only place in the kernel where we do it.


> IMHO either you should at least wrap that case inside a {} of its
> own (so that the int status; is at top of a statement block), or else,

Yeah, I should...

> preferably, just add "__maybe_unused" to the first declaration that you
> removed just now.
> 

Here's an updated patch that actually works as intended.



In the iforce driver we currently get this warning

  drivers/input/joystick/iforce/iforce-packets.c: In function 'iforce_get_id_packet':
  drivers/input/joystick/iforce/iforce-packets.c:249: warning: unused variable 'status'

if CONFIG_JOYSTICK_IFORCE_USB is not defined.

The warning is easy to avoid by simply moving the variable inside
the only case in the switch that actually use it.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/input/joystick/iforce/iforce-packets.c b/drivers/input/joystick/iforce/iforce-packets.c
index 3154ccd..2731057 100644
--- a/drivers/input/joystick/iforce/iforce-packets.c
+++ b/drivers/input/joystick/iforce/iforce-packets.c
@@ -246,13 +246,12 @@ void iforce_process_packet(struct iforce *iforce, u16 cmd, unsigned char *data)
 
 int iforce_get_id_packet(struct iforce *iforce, char *packet)
 {
-	int status;
-
 	switch (iforce->bus) {
 
-	case IFORCE_USB:
-
+	case IFORCE_USB: {
 #ifdef CONFIG_JOYSTICK_IFORCE_USB
+		int status;
+
 		iforce->cr.bRequest = packet[0];
 		iforce->ctrl->dev = iforce->usbdev;
 
@@ -270,6 +269,7 @@ int iforce_get_id_packet(struct iforce *iforce, char *packet)
 			usb_unlink_urb(iforce->ctrl);
 			return -1;
 		}
+	}
 #else
 		dbg("iforce_get_id_packet: iforce->bus = USB!");
 #endif


