Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYAGSZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYAGSZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 13:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYAGSZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 13:25:08 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50137 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbYAGSZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 13:25:06 -0500
Message-ID: <47826E63.9070008@cs.wisc.edu>
Date: Mon, 07 Jan 2008 12:24:35 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Multipath failover handling (Was: Re: 2.6.24-rc3-mm1)
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <47462F3C.3040700@googlemail.com>	 <20071122201250.f957e280.akpm@linux-foundation.org>	 <47466B5D.90607@googlemail.com>	 <20071126221509.8f437b61.akpm@linux-foundation.org>	 <1197390783.3812.19.camel@localhost.localdomain> <47624649.3040209@suse.de>	 <1197642405.3154.71.camel@localhost.localdomain> <478231B7.7080508@suse.de> <1199728667.3126.32.camel@localhost.localdomain>
In-Reply-To: <1199728667.3126.32.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>>> However, there's still devloss_tmo to consider ... even in
>>> multipath, I don't think you want to signal path failure until
>>> devloss_tmo has fired otherwise you'll get too many transient up/down
>>> events which damage performance if the array has an expensive failover
>>> model.
>>>
>> Yes. But currently we have a very high failover latency as we always have
>> to wait for the requeued commands to time-out.
>> Hence we're damaging performance on arrays with inexpensive failover.
> 
> If it's a either/or choice between the two that's showing our current
> approach to multi-path is broken.
> 
>>> The other problem is what to do with in-flight commands at the time the
>>> link went down.  With your current patch, they're still stuck until they
>>> time out ... surely there needs to be some type of recovery mechanism
>>> for these?
>>>
>> Well, the in-flight commands are owned by the HBA driver, which should
>> have the proper code to terminate / return those commands with the
>> appriopriate codes. They will then be rescheduled and will be caught
>> like 'normal' IO requests.
> 
> But my point is that if a driver goes blocked, those commands will be
> forced to wait the blocked timeout anyway, so your proposed patch does
> nothing to improve the case for dm anyway ... you only avoid commands
> stuck when a device goes blocked if by chance its request queue was
> empty.


How about my patches to use new transport error values and make the 
iscsi and fc behave the same.

The problem I think Hannes and I are both trying to solve is this:

1. We do not want to wait for dev_loss_tmo seconds for failover.

2. The FC drivers can hook into fast_io_fail_tmo related callouts and 
with that set that tmo to a very low value like a couple of seconds if 
they are using multipath, so failovers are fast. However, there is a bug 
with where when the fast_io_fail_tmo fires requests that made it to the 
driver get failed and returned to the multipath layer, but commands in 
the blocked request queue are stuck in there until dev_loss_tmo fires.

With my patches here (need to be rediffed and for FC I need to handle 
JamesS's comments about not using a new field for the fast_fail_timeout 
state bit):

http://marc.info/?l=linux-scsi&m=117399843216280&w=2
http://marc.info/?l=linux-scsi&m=117399544112073&w=2
http://marc.info/?l=linux-scsi&m=117399844316771&w=2
http://marc.info/?l=linux-scsi&m=117400203324693&w=2
http://marc.info/?l=linux-scsi&m=117400203324690&w=2

For FC we can use the fast_io_fail_tmo for fast failovers, and commands 
will not get stuck in a blocked queue for dev_loss_tmo seconds because 
when the fast_io_fail_tmo fires the target's queues are unblocked and 
fc_remote_port_chkready() ready kicks in (iSCSI does the same with the 
patches in the links). And with the patches if multipath-tools is 
sending its path testing IO it will get a DID_TRANSPORT_* error code 
that it can use to make a decent path failing decision with.
