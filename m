Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbZIPXs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbZIPXs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760499AbZIPXs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:48:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:47761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbZIPXsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:48:55 -0400
Message-ID: <4AB17905.90606@kernel.org>
Date: Thu, 17 Sep 2009 08:47:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Chris Webb <chris@arachsys.com>
CC: Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <20090916222842.GB16053@arachsys.com>
In-Reply-To: <20090916222842.GB16053@arachsys.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 23:47:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Chris Webb wrote:
> Hi Tejun. Thanks for following up to this. We've done some more
> experimentation over the last couple of days based on your
> suggestions and thoughts.
> 
> Tejun Heo <tj@kernel.org> writes:
>> Seriously, it's most likely a hardware malfunction although I can't tell
>> where the problem is with the given data.  Get the hardware fixed.
> 
> We know this isn't caused by a single faulty piece of hardware,
> because we have a cluster of identical machines and all have shown
> this behaviour. This doesn't mean that there isn't a hardware
> problem, but if there is one, it's a design problem or firmware bug
> affecting all of our hosts.

If it's multiple machines, it's much less likely to be faulty drives,
but if the machines are configured mostly identically, hardware
problems can't be ruled out either.

> There have also been a few reports of problems which look very
> similar in this thread from people with somewhat different hardware
> and drives to ours.

I wouldn't connect the reported cases too eagerly at this point.  Too
many different causes end up showing similar symptoms especially with
timeouts.

>> The aboves are IDENTIFY.  Who's issuing IDENTIFY regularly?  It isn't
>> from the regular IO paths or md.  It's probably being issued via SG_IO
>> from userland.  These failures don't affect normal operation.
> [...]
>> Oooh, another possibility is the above continuous IDENTIFY tries.
>> Doing things like that generally isn't a good idea because vendors
>> don't expect IDENTIFY to be mixed regularly with normal IOs and
>> firmwares aren't tested against that.  Even smart commands sometimes
>> cause problems.  So, finding out the thing which is obsessed with the
>> identity of the drive and stopping it might help.
> 
> We tracked this down to some (excessively frequent!) monitoring we
> were doing using smartctl. Things were improved considerably by
> stopping smartd and disabling all callers of smartctl, although it
> doesn't appear to have been a cure. The frequency of these timeouts
> during resync seems to have gone from about once every two hours to
> about once a day, which means we've been able to complete some
> resyncs whereas we were unable to before.

That's interesting.  One important side effect of issuing IDENTIFY is
that they will serialize command streams as they are not NCQ commands
and thus could change command patterns significantly.

> What we still see are (fewer) 'frozen' exceptions leading to a drive
> reset and an 'end_request: I/O error', such as [1]. The drive is
> then promptly kicked out of the raid array.

That's flush timeout and md is right to kick the drive out.

> Some of these timeouts also leave us with a completely dead drive,
> and we need to reboot the machine before it can be accessed
> again. (Hot plugging it out and back in again isn't sufficient to
> bring it back to life, so maybe a controller problem, although other
> drives on the same controller stay alive?) An example is [2].

Ports behave mostly independently and it sure is possible that one
port locks up while others operate fine.  I've never seen such
incidents reported for intel ahci's tho.  If you hot unplug and then
replug the drive, what does the kernel say?

> There are two more symptoms we are seeing on the same which may be
> connected, or may be separate bugs in their own right:
> 
>   - 'cat /proc/mdstat' sometimes hangs before returning during normal
>     operation, although most of the time it is fine. We have seen hangs of
>     up to 15-20 seconds during resync. Might this be a less severe example
>     of the lock-up which causes a timeout and reset after 30 seconds?
> 
>   - We've also had a few occasions of O_SYNC writes to raid arrays (from
>     qemu-kvm via LVM2) completely deadlocking against resync writes when the
>     maximum md resync speed is set sufficiently high, even where the minimum
>     md resync speed is set to zero (although this certainly helps). However,
>     I suspect this is an unrelated issue as I've seen this on other hardware
>     running other kernel configs.

I think these two will be best answered by Neil Brown.  Neil?

> For reference, we're using the ahci driver and deadline IO scheduler with the
> default tuning parameters, our motherboards are SuperMicro X7DBN (Intel ESB2
> SATA 3.0Gbps Controller) and we have six 750GB Seagate ST3750523AS drives
> attached to each motherboard. Also, since first reporting this, I've managed
> to reproduce the problem whilst running Linux 2.6.29.6, 2.6.30.5 and the
> newly released 2.6.31.
> 
> What do you think are our next steps in tracking this one down should be? My
> only ideas are:
> 
>   - We could experiment with NCQ settings. I've already briefly
>     changed /sys/block/sd*/device/queue_depth down from 31 to 1. It
>     didn't seem to stop delays in getting back info from
>     /proc/mdstat, so put it back up again fearing that the
>     performance hit would make the problem worse, but perhaps I
>     should leave it off for a more extended period to verify that we
>     still get timeouts long enough to leave slots without it?
> 
>   - We could try replacing the drives that are currently kicked out
>     of one of the arrays with drives from another manufacturer to
>     see if the drive model is implicated. Is the drive or the
>     controller a more likely problem?

The most common cause for FLUSH timeout has been power related issues.
This problem becomes more pronounced in RAID configurations because
FLUSHes end up being issued to all drives in the array simultaneously
causing concurrent power spikes from the drives.  When proper barrier
was introduced to md earlier this year, I got two separate reports
where brief voltage drops caused by simultaneous FLUSHes led to drives
powering off briefly and losing data in its buffer leading to data
corruption.  People always think their PSUs are good because they are
rated high wattage and bear hefty price tag but many people reporting
problems which end up being diagnosed as power problem have these
fancy PSUs.

So, if your machines share the same configuration, the first thing
I'll do would be to prepare a separate PSU, power it up and connect
half of the drives including what used to be the offending one to it
and see whether the failure pattern changes.

Thanks.

-- 
tejun
