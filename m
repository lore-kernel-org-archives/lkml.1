Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbYA1WYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbYA1WYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYA1WYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:24:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761874AbYA1WYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:24:35 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: fix "kobject_add failed for fw* with -EEXIST"
Date: Mon, 28 Jan 2008 17:24:11 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <200801281148.54017.jwilson@redhat.com> <479E24D6.4060006@s5r6.in-berlin.de>
In-Reply-To: <479E24D6.4060006@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281724.12029.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 01:54:14 pm Stefan Richter wrote:
> Jarod Wilson wrote:
> > We may have another issue there though, as when this happened to me, the
> > md layer apparently never noticed (after ~6 hours) that one of the array
> > members had disappeared -- not sure if that's firewire's fault or md's
> > though... This will presumably avoid this situation entirely, but worth
> > noting that there may still be somewhere we need to better communicate
> > status to an upper layer.
>
> I don't know how md ticks, so I have no idea what might have happened
> there.

It looks like firewire is doing the right thing, unregistering the fw* device, 
and the SCSI layer is subsequently removing the appropriate /dev/sd* nodes, 
but for whatever reason, md hasn't a clue this has happened. I can reproduce 
this particular part of the problem by bringing the array up, and then simply 
pulling the firewire cable on one of the drives in the array...

> Somewhat related:  What if
>   - we lose connection to disk "A", represented by scsi_device "a",
>   - the SCSI core sets "a" offline,
>   - we gain connection to disk "A" again (i.e. it only shortly
>     disappeared from the bus from firewire-core's and -sbp2's point
>     of view),
>   - and firewire-sbp2 adds it as scsi_device "b", even before SCSI
>     core got rid of "a"?
> No big problem for stand-alone volumes (unless it happens when the
> volume is in use), but maybe trouble for md managed volumes.

That does appear to be the case. If I reconnect the drive I disconnected, 
which was originally /dev/sdb, it comes back up as /dev/sdd now. So 
apparently, the scsi layer is at least bright enough to see that someone (md) 
is still trying to use /dev/sdb, but I'm clueless as to why md doesn't have 
any idea that /dev/sdb actually went away. :\

> To smooth such issues out, my longer term goal was to allow brief
> periods of disconnection in (firewire-)sbp2.  I.e. the SCSI core
> wouldn't notice that "A"/"a" went away, it would only notice that "a"
> wasn't accessible for a short time.  I think the Fibre Channel drivers
> already support this.  The ieee1394 driver even has a "limbo" for
> devices which went away, in order to remember them until they come back,
> but sbp2 doesn't use this feature.  (Nobody did the work to enhance sbp2
> to utilize the feature.)
>
> BTW, if you unplug and replug a FireWire disk under Mac OS X fairly
> quickly, OS X will pretend that nothing happened and let the user
> continue using the disk if he hadn't "ejected" it before the brief
> connection loss.

Certainly sounds like a feature we'd benefit from having in this particular 
case...

> Anyhow, we have a few more urgent problems to solve in firewire-sbp2's
> reconnection handling before we can think about such extras.

Very true... Perhaps I'll just file this one away a bit down the TODO list for 
now... ;)

-- 
Jarod Wilson
jwilson@redhat.com
