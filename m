Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZBXA36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZBXA36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZBXAW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:22:59 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:5379 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbZBXAW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:22:58 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 19:22:57 EST
Date: Mon, 23 Feb 2009 16:16:12 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Matthew Chapman <matthewc@cse.unsw.edu.au>
Cc: Alexander Hofbauer <alex@derhofbauer.at>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: ALPS input driver problem with DualPoint on Dell E6400/E6500 [patch]
Message-ID: <20090224001612.GA18077@hexapodia.org>
References: <1227638742.5353.5.camel@mobian> <20081208141438.GA30462@cse.unsw.EDU.AU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208141438.GA30462@cse.unsw.EDU.AU>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 01:14:38AM +1100, Matthew Chapman wrote:
> Hi,
> 
> Here's a patch that implements the 9-byte packet format, which solves
> the problem for me.
> 
> Matt

Matt,

Your patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=12577 for
me.  Would you consider resending it to linux-input@ with your
Signed-off-by?

Thanks,
-andy

> --- linux-2.6.27/drivers/input/mouse/alps.c	2008-12-09 00:31:48.000000000 +1100
> +++ linux-2.6.27.alps/drivers/input/mouse/alps.c	2008-12-09 01:08:09.000000000 +1100
> @@ -100,6 +100,19 @@
>  		return;
>  	}
>  
> +	if ((packet[3] & 0xf) == 0xf) {
> +		/* 9-byte packet format seen on some DualPoints */
> +		/* handle relative update and then fall through for remainder */
> +		input_report_rel(dev2, REL_X,
> +			packet[4] ? packet[4] - ((packet[3] << 4) & 0x100) : 0);
> +		input_report_rel(dev2, REL_Y,
> +			packet[5] ? ((packet[3] << 3) & 0x100) - packet[5] : 0);
> +		input_sync(dev2);
> +		packet[3] = packet[6];
> +		packet[4] = packet[7];
> +		packet[5] = packet[8];
> +	}
> +
>  	if (priv->i->flags & ALPS_OLDPROTO) {
>  		left = packet[2] & 0x10;
>  		right = packet[2] & 0x08;
> @@ -197,6 +210,21 @@
>  	if ((psmouse->packet[0] & priv->i->mask0) != priv->i->byte0)
>  		return PSMOUSE_BAD_DATA;
>  
> +	if ((psmouse->pktcnt >= 4) && ((psmouse->packet[3] & 0xf) == 0xf))
> +	{
> +		/* 9-byte packet format seen on some DualPoints */
> +		/* Bytes 7 - 9 should have 0 in the highest bit */
> +		if ((psmouse->pktcnt >= 7) && (psmouse->pktcnt <= 9) &&
> +		    (psmouse->packet[psmouse->pktcnt - 1] & 0x80))
> +			return PSMOUSE_BAD_DATA;
> +
> +		if (psmouse->pktcnt == 9) {
> +			alps_process_packet(psmouse);
> +			return PSMOUSE_FULL_PACKET;
> +		}
> +		return PSMOUSE_GOOD_DATA;
> +	}
> +
>  	/* Bytes 2 - 6 should have 0 in the highest bit */
>  	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= 6 &&
>  	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80))
> --- linux-2.6.27/drivers/input/mouse/psmouse.h	2008-10-10 09:13:53.000000000 +1100
> +++ linux-2.6.27.alps/drivers/input/mouse/psmouse.h	2008-11-06 02:32:45.000000000 +1100
> @@ -42,7 +42,7 @@
>  	struct work_struct resync_work;
>  	char *vendor;
>  	char *name;
> -	unsigned char packet[8];
> +	unsigned char packet[9];
>  	unsigned char badbyte;
>  	unsigned char pktcnt;
>  	unsigned char pktsize;

