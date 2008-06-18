Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbYFRJTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbYFRJTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYFRJTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:19:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43419 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYFRJTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:19:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4858D304.80907@s5r6.in-berlin.de>
Date: Wed, 18 Jun 2008 11:19:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFT patch, regression fix] firewire: deadline for PHY config
 transmission
References: <tkrat.230a7a03785f244f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.230a7a03785f244f@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> I briefly tested the patch with 7 different working controllers and the
> packet callback seems to complete() always before the arbitrarily
> chosen timeout of 10ms plus rounding.
...
>  void fw_send_phy_config(struct fw_card *card,
>  			int node_id, int generation, int gap_count)
>  {
> -	struct fw_phy_packet p;
> +	struct fw_phy_packet *p;
> +	long timeout = DIV_ROUND_UP(HZ, 100);
>  	u32 data = PHY_IDENTIFIER(PHY_PACKET_CONFIG) |
...
> +	card->driver->send_request(card, &p->packet);
> +	timeout = wait_for_completion_timeout(&p->done, timeout);
> +	kref_put(&p->kref, phy_packet_release);
>  
> -	card->driver->send_request(card, &p.packet);
> -	wait_for_completion(&p.done);
> +	/* will leak p if the callback is never executed */
> +	WARN_ON(timeout == 0);
>  }

The warning triggered on a VT6307 after cold boot.  I will retry later 
today with HZ/10.
-- 
Stefan Richter
-=====-==--- -==- =--=-
http://arcgraph.de/sr/
