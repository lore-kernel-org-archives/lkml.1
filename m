Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZECQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZECQQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZECQP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:15:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:47481 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZECQPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:15:55 -0400
Date: Sun, 3 May 2009 09:13:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Willy Tarreau <w@1wt.eu>, Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
In-Reply-To: <1241366571.5596.80.camel@mulgrave.int.hansenpartnership.com>
Message-ID: <alpine.DEB.1.10.0905030904230.15782@asgard>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>  <20090501015902.ed8b56d3.akpm@linux-foundation.org>  <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com>  <20090503053557.GH570@1wt.eu> <alpine.DEB.1.10.0905022239100.15782@asgard>
  <1241360474.5596.4.camel@mulgrave.int.hansenpartnership.com>  <alpine.DEB.1.10.0905030735500.15782@asgard>  <1241361925.5596.27.camel@mulgrave.int.hansenpartnership.com>  <alpine.DEB.1.10.0905030753380.15782@asgard>  <1241363371.5596.45.camel@mulgrave.int.hansenpartnership.com>
  <alpine.DEB.1.10.0905030816090.15782@asgard>  <1241365101.5596.69.camel@mulgrave.int.hansenpartnership.com>  <alpine.DEB.1.10.0905030844070.15782@asgard> <1241366571.5596.80.camel@mulgrave.int.hansenpartnership.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, James Bottomley wrote:

> Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
> 
> On Sun, 2009-05-03 at 08:48 -0700, david@lang.hm wrote:
>> On Sun, 3 May 2009, James Bottomley wrote:
>>
>>> On Sun, 2009-05-03 at 08:22 -0700, david@lang.hm wrote:
>>>> On Sun, 3 May 2009, James Bottomley wrote:
>>>>
>
>>>>> This corruption situation isn't unique to replication ... any time you
>>>>> may potentially have allowed both sides to write to a data store, you
>>>>> get it, that's why it's the job of the HA harness to sort out whether a
>>>>> split brain happened and what to do about it *first*.
>>>>
>>>> but you can have packets sitting in the network buffers waiting to get to
>>>> the remote machine, then once the connection is reestablished those
>>>> packets will go out. no remounting needed., just connectivity restored.
>>>> (this isn't as bad as if the system tries to re-sync to the temprarily
>>>> unavailable drive by itself, but it can still corrupt things)
>>>
>>> This is an interesting thought, but not what happens.  As soon as the HA
>>> harness stops replication, which it does at the instant failure is
>>> detected, the closure of the socket kills all the in flight network
>>> data.
>>>
>>> There is an variant of this problem that occurs with device mapper
>>> queue_if_no_path (on local disks) which does exactly what you say (keeps
>>> unsaved data around in the queue forever), but that's fixed by not using
>>> queue_if_no_path for HA.  Maybe that's what you were thinking of?
>>
>> is there a mechanism in ndb that prevents it from beign mounted more than
>> once? if so then could have the same protection that DRDB has, if not it
>> is possible for it to be mounted more than once place and therefor get
>> corrupted.
>
> That's not really relevant, is it?  An ordinary disk doesn't have this
> property either.  Mediating simultaneous access is the job of the HA
> harness.  If the device does it for you, fine, the harness can make use
> of that (as long as the device gets it right) but all good HA harnesses
> sort out the usual case where the device doesn't do it.

with a local disk you can mount it multiple times, write to it from all 
the mounts, and not have any problems, because all access goes through a 
common layer.

you would have this sort of problem if you used one partition as part of 
multiple md arrays, but the md layer itself would detect and prevent this 
(because it would see both arrays), but again, in a multi-machine 
situation you don't have the common layer to do the detection.

you can rely on the HA layer to detect and prevent all of this (and 
apparently there are people doing this, I wasn't aware of it), but I've 
seen enough problems with every HA implementation I've dealt with over the 
years (both opensource and commercial), that I would be very uncomfortable 
depending on this exclusivly. having the disk replication layer detect 
this adds a significant amount of safety in my eyes.

>>> There are commercial HA products based on md/nbd, so I'd say it's also
>>> hardened for harsher environments
>>
>> which ones?
>
> SteelEye LifeKeeper.  It actually supports both drbd and md/nbd.

thanks for the info.

David Lang
