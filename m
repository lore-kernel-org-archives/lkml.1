Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYDRQqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYDRQqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYDRQqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:46:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44202 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYDRQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:46:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4808D03C.3080403@s5r6.in-berlin.de>
Date: Fri, 18 Apr 2008 18:45:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 update] firewire: insist on successive self ID complete
 events
References: <tkrat.b99824b37365e037@s5r6.in-berlin.de> <tkrat.00038248cbf40b77@s5r6.in-berlin.de> <tkrat.f63ec71babd13755@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f63ec71babd13755@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote on 2008-03-19:
> The whole topology code only works if the old and new topologies which
> are compared come from immediately successive self ID complete events.
> 
> If there happened bus resets without self ID complete events in the
> meantime, or self ID complete events with invalid selfIDs, the topology
> comparison could identify nodes wrongly, or more likely just corrupt
> kernel memory or panic right away.
> 
> We new discard all nodes of the old topology and treat all current nodes
> as new ones if the current self ID generation is not the previous one
> plus 1.
[...]
> --- linux.orig/drivers/firewire/fw-topology.c
> +++ linux/drivers/firewire/fw-topology.c
> @@ -513,6 +513,18 @@ fw_core_handle_bus_reset(struct fw_card 
>  
>  	fw_flush_transactions(card);
>  
> +	/*
> +	 * If the selfID buffer is not the immediate successor of the
> +	 * previously processed one, we cannot reliably compare the
> +	 * old and new topologies.
> +	 */
> +	if ((generation & 0xff) != ((card->generation + 1) & 0xff) &&
> +	    card->local_node != NULL) {
> +		fw_notify("skipped bus generations, destroying all nodes\n");
> +		fw_destroy_nodes(card);
> +		card->bm_retries = 0;
> +	}
> +
>  	spin_lock_irqsave(&card->lock, flags);
>  
>  	/*
> 

Some a-posteriori thoughts:

Situations like this happen quite regularly when camcorders are plugged 
in or out or switched on or off, or when bus-powered hubs are plugged 
in, and similar situations --- depending on the PHYs on the bus.

The conclusion that we have to discard the old topology data in this 
situation still stands.

However, although we have to discard node data, we should not discard 
_device_ data.  Chances are that some devices remained on the bus.  At 
least the local node's device will obviously still be there.

Destroying the device representations (and recreating them)
   - causes unnecessary terminal connection loss for userspace drivers,
   - causes unnecessary terminal connection loss to SBP-2 devices with
     the possible result of data loss,
   - will unnecessarily disturb hypothetical future kernelspace firewire
     drivers.  (There will be at least one more of those eventually, i.e.
     IP over 1394.)
   - is a regression relative to the current firewire-core and relative
     to ieee1394.

I don't think it will be hard to prevent the premature destruction of 
device representations.  I will work on it soon and am holding off 
upstream submission of the above quoted patch until I have the device 
preserving code implemented an tested.

Until then, firewire-core will keep panicking in rare border cases due 
to bogus topology comparisons.¹  But it will on the other hand not lose 
connection in the not quite uncommon situations outlined above.

¹) There is no proof yet that it does, but there are some suspicious 
reports.  And I don't remember any panics by hotplugging anymore since I 
am using the above patch myself.
-- 
Stefan Richter
-=====-==--- -=-- =--=-
http://arcgraph.de/sr/
