Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbXBWAE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbXBWAE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbXBWAE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:04:56 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:42013 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXBWAEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:04:55 -0500
Date: Thu, 22 Feb 2007 18:04:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata FUA revisited
In-reply-to: <45DE1A7C.1030500@emc.com>
To: ric@emc.com
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Dongjun Shin <d.j.shin@samsung.com>,
       Hannes Reinecke <hare@suse.de>
Message-id: <45DE2F75.2030700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no>
 <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca>
 <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca>
 <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk>
 <"45D9FE7B <45DC04DF.8040002"@gmail.com> <45DE1A7C.1030500@emc.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
>>> I think that FUA was designed for a different use case than what Linux
>>> is using barriers for currently. The advantage with FUA is when you have
>>> "before barrier", "after barrier" and "don't care" sets, where only the
>>> specific things you care about ordering are in the before/after barrier
>>> sets. Then you can do this:
>>>
>>> Issue all before barrier requests with FUA bit set
>>> Wait for all those to complete
>>> Issue all after barrier requests with FUA bit set
>>> Wait for all those to complete
> 
> A couple of issues with this would be in how to support our current 
> semantics of fsync().  Today, the flush behavior of the barrier/fsync 
> combination means that applications can have a hard promise of data on 
> platter for any file after a successful fsync command.
> 
> If I understand correctly, to get a similar semantic from a pure FUA 
> implementation would require us to tag all file IO as FUA.
> 
> I suspect that this would actually be less efficient since it would not 
> allow the drives to reorder IO's up to the point that we actually care 
> (fsync time).

I think for the fsync case a cache flush would likely still be needed, 
unless the app was only writing small amounts of data in between the 
syncs (it may be complicated to figure out when to do that, though).

> The other big user of barriers is the internal transaction of journaled 
> file systems.  It would seem that we would need to tag each write from 
> the journal with a FUA IO as well.  Again, we might actually go more 
> slowly in some cases as you mention below.
> 
> The limited queue depth of NCQ would seem to make it much harder to have 
> a win in this case...

I think the journal write case is less problematic as there are likely 
to be much fewer/smaller requests involved which would be more likely to 
fit inside the queue..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


