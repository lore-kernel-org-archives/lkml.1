Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYLHOOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYLHOOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYLHOOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:14:42 -0500
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:42279 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509AbYLHOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:14:41 -0500
From: Matthew Chapman <matthewc@cse.unsw.edu.au>
To: Alexander Hofbauer <alex@derhofbauer.at>
Date: Tue, 9 Dec 2008 01:14:38 +1100
Cc: linux-kernel@vger.kernel.org
Subject: Re: ALPS input driver problem with DualPoint on Dell E6400/E6500
	[patch]
Message-ID: <20081208141438.GA30462@cse.unsw.EDU.AU>
References: <1227638742.5353.5.camel@mobian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <1227638742.5353.5.camel@mobian>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Here's a patch that implements the 9-byte packet format, which solves
the problem for me.

Matt


On Tue, Nov 25, 2008 at 07:45:42PM +0100, Alexander Hofbauer wrote:
> Hi!
> 
> > I can put together a patch, but it's a non-trivial change... I'm
> > interested in hearing whether anyone else has the same problem with
> > their E6400/E6500 or other DualPoint laptop, or has better ideas
> > regarding how to deal with this.
> 
> I'm facing the same problem here on my "Latitude E5500" and 2.6.27.7
> with no found workarounds so far ("synclient TouchpadOff=0" works until
> reset but doesn't avoid the touchpad getting reset eventually).
> 
> 
> If there was a patch to test I'd be happy to do so :-).
> 
> 
> Thank you,
> Alex



--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alps.diff"

--- linux-2.6.27/drivers/input/mouse/alps.c	2008-12-09 00:31:48.000000000 +1100
+++ linux-2.6.27.alps/drivers/input/mouse/alps.c	2008-12-09 01:08:09.000000000 +1100
@@ -100,6 +100,19 @@
 		return;
 	}
 
+	if ((packet[3] & 0xf) == 0xf) {
+		/* 9-byte packet format seen on some DualPoints */
+		/* handle relative update and then fall through for remainder */
+		input_report_rel(dev2, REL_X,
+			packet[4] ? packet[4] - ((packet[3] << 4) & 0x100) : 0);
+		input_report_rel(dev2, REL_Y,
+			packet[5] ? ((packet[3] << 3) & 0x100) - packet[5] : 0);
+		input_sync(dev2);
+		packet[3] = packet[6];
+		packet[4] = packet[7];
+		packet[5] = packet[8];
+	}
+
 	if (priv->i->flags & ALPS_OLDPROTO) {
 		left = packet[2] & 0x10;
 		right = packet[2] & 0x08;
@@ -197,6 +210,21 @@
 	if ((psmouse->packet[0] & priv->i->mask0) != priv->i->byte0)
 		return PSMOUSE_BAD_DATA;
 
+	if ((psmouse->pktcnt >= 4) && ((psmouse->packet[3] & 0xf) == 0xf))
+	{
+		/* 9-byte packet format seen on some DualPoints */
+		/* Bytes 7 - 9 should have 0 in the highest bit */
+		if ((psmouse->pktcnt >= 7) && (psmouse->pktcnt <= 9) &&
+		    (psmouse->packet[psmouse->pktcnt - 1] & 0x80))
+			return PSMOUSE_BAD_DATA;
+
+		if (psmouse->pktcnt == 9) {
+			alps_process_packet(psmouse);
+			return PSMOUSE_FULL_PACKET;
+		}
+		return PSMOUSE_GOOD_DATA;
+	}
+
 	/* Bytes 2 - 6 should have 0 in the highest bit */
 	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= 6 &&
 	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80))
--- linux-2.6.27/drivers/input/mouse/psmouse.h	2008-10-10 09:13:53.000000000 +1100
+++ linux-2.6.27.alps/drivers/input/mouse/psmouse.h	2008-11-06 02:32:45.000000000 +1100
@@ -42,7 +42,7 @@
 	struct work_struct resync_work;
 	char *vendor;
 	char *name;
-	unsigned char packet[8];
+	unsigned char packet[9];
 	unsigned char badbyte;
 	unsigned char pktcnt;
 	unsigned char pktsize;

--T4sUOijqQbZv57TR--
