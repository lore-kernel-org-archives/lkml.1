Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbXCZDTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbXCZDTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 23:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbXCZDTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 23:19:46 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:5070 "EHLO
	asav15.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465AbXCZDTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 23:19:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAAvYBkZKhRO4dGdsb2JhbACPYAE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Fix sudden warps in mousedev
Date: Sun, 25 Mar 2007 23:19:38 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
References: <20070324001610.724a820a.zaitcev@redhat.com> <200703250134.03416.dtor@insightbb.com> <20070325111930.f6428509.zaitcev@redhat.com>
In-Reply-To: <20070325111930.f6428509.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703252319.39676.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007 14:19, Pete Zaitcev wrote:
> On Sun, 25 Mar 2007 01:34:02 -0400, Dmitry Torokhov <dtor@insightbb.com> wrote:
> 
> > > +                * Without this, a touchpad may report an unchanged position,
> > > +                * then a sync. The input_event() eats the position report, but
> > > +                * lets the sync through. We increment pkt_count and leave 
> > > +                * a stale position in the ring. If a future reference to fx(2)
> > > +                * hits the stale position, a large dx is reported, and the
> > > +                * pointer warps across the screen.
> > > +                */
> > > +               dev = mousedev->handle.dev;
> > > +               fx(0) = dev->abs[ABS_X];
> > > +               fy(0) = dev->abs[ABS_Y];
> > 
> > I do not like input hanlders poking into input devices... Can't we just
> > reset pkt_count at the beginning of the touch to get rid of stale data?
> 
> The pkt_count is zero at the moment of assignment above.

Riiight... Of course you are right...

I tried to reproduce warping on console but could not for some reason. Could you
please try the patch below and tell me if it fixes the problem for you?

-- 
Dmitry

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mousedev.c |   51 +++++++++++++++++++++++------------------------
 1 files changed, 26 insertions(+), 25 deletions(-)

Index: work/drivers/input/mousedev.c
===================================================================
--- work.orig/drivers/input/mousedev.c
+++ work/drivers/input/mousedev.c
@@ -124,32 +124,33 @@ static void mousedev_touchpad_event(stru
 	int size, tmp;
 	enum { FRACTION_DENOM = 128 };
 
-	if (mousedev->touch) {
-		size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
-		if (size == 0)
-			size = 256 * 2;
-
-		switch (code) {
-			case ABS_X:
-				fx(0) = value;
-				if (mousedev->pkt_count >= 2) {
-					tmp = ((value - fx(2)) * (256 * FRACTION_DENOM)) / size;
-					tmp += mousedev->frac_dx;
-					mousedev->packet.dx = tmp / FRACTION_DENOM;
-					mousedev->frac_dx = tmp - mousedev->packet.dx * FRACTION_DENOM;
-				}
-				break;
+	switch (code) {
+		case ABS_X:
+			fx(0) = value;
+			if (mousedev->touch && mousedev->pkt_count >= 2) {
+				size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
+				if (size == 0)
+					size = 256 * 2;
+				tmp = ((value - fx(2)) * (256 * FRACTION_DENOM)) / size;
+				tmp += mousedev->frac_dx;
+				mousedev->packet.dx = tmp / FRACTION_DENOM;
+				mousedev->frac_dx = tmp - mousedev->packet.dx * FRACTION_DENOM;
+			}
+			break;
 
-			case ABS_Y:
-				fy(0) = value;
-				if (mousedev->pkt_count >= 2) {
-					tmp = -((value - fy(2)) * (256 * FRACTION_DENOM)) / size;
-					tmp += mousedev->frac_dy;
-					mousedev->packet.dy = tmp / FRACTION_DENOM;
-					mousedev->frac_dy = tmp - mousedev->packet.dy * FRACTION_DENOM;
-				}
-				break;
-		}
+		case ABS_Y:
+			fy(0) = value;
+			if (mousedev->touch && mousedev->pkt_count >= 2) {
+				/* use X size to keep the same scale */
+				size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
+				if (size == 0)
+					size = 256 * 2;
+				tmp = -((value - fy(2)) * (256 * FRACTION_DENOM)) / size;
+				tmp += mousedev->frac_dy;
+				mousedev->packet.dy = tmp / FRACTION_DENOM;
+				mousedev->frac_dy = tmp - mousedev->packet.dy * FRACTION_DENOM;
+			}
+			break;
 	}
 }
 
