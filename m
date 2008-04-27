Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbYD0EHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbYD0EHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 00:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYD0EHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 00:07:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:14317 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYD0EHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 00:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tYw7PihbABF/nPrgFKEQnW7mSb9VIe8hehObypOXVuhhRGnChstx/Hfb6knm3ELNq87D2U5ZXAd98nD+naRvTetPFJ1tuWtByRgTSqsjpMtZ02UDRxzr4uQXFwgllwK8XRpcniEhgR+NJhhjtLGaPoanKVt6oZV2hPmXAHd4qEk=
Date: Sun, 27 Apr 2008 00:07:17 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
Subject: Re: [build bug] Re: [PATCH 00/37] Input queue for 2.6.26 merge
	window
Message-ID: <20080427040717.GA29127@anvil.corenet.prv>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com> <20080426132434.GA21423@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426132434.GA21423@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, Apr 26, 2008 at 03:24:34PM +0200, Ingo Molnar wrote:
> 
> >   Input: xpad - add support for wireless xbox360 controllers
> 
> via the commit above (99de0912) a build bug sneaked in:
> 
> drivers/input/joystick/xpad.c: In function 'xpad_probe':
> drivers/input/joystick/xpad.c:865: error: 'xpad_bulk_out' undeclared (first usein this function)
> drivers/input/joystick/xpad.c:865: error: (Each undeclared identifier is reported only once
> drivers/input/joystick/xpad.c:865: error: for each function it appears in.)
> 

Oops, sorry about that. The patch below should fix this problem.

-- 
Dmitry

Input: xpad - fix build failure

If both CONFIG_JOYSTICK_XPAD_FF and CONFIG_JOYSTICK_XPAD_LEDS are unset
xpad_bulk_out is not defined and build fails. Move it out of the #ifdef
block so it is always defined.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: work/drivers/input/joystick/xpad.c
===================================================================
--- work.orig/drivers/input/joystick/xpad.c
+++ work/drivers/input/joystick/xpad.c
@@ -444,6 +444,23 @@ exit:
 		     __FUNCTION__, retval);
 }
 
+static void xpad_bulk_out(struct urb *urb)
+{
+	switch (urb->status) {
+	case 0:
+		/* success */
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		break;
+	default:
+		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+	}
+}
+
 #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 static void xpad_irq_out(struct urb *urb)
 {
@@ -475,23 +492,6 @@ exit:
 		    __FUNCTION__, retval);
 }
 
-static void xpad_bulk_out(struct urb *urb)
-{
-	switch (urb->status) {
-	case 0:
-		/* success */
-		break;
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
-		break;
-	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
-	}
-}
-
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
 {
 	struct usb_endpoint_descriptor *ep_irq_out;
