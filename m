Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbZIQPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbZIQPpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZIQPpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:45:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:39569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbZIQPpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:45:30 -0400
Message-ID: <4AB2596D.10809@kernel.org>
Date: Fri, 18 Sep 2009 00:44:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Chris Webb <chris@arachsys.com>
CC: Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <20090917115728.GA13854@arachsys.com>
In-Reply-To: <20090917115728.GA13854@arachsys.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 15:44:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Chris Webb wrote:
> It's quite hard for us to do this with these machines as we have
> them managed by a third party in a datacentre to which we don't have
> physical access.  However, I could very easily get an extra 'test'
> machine built in there, generate a work load that consistently
> reproduces the problems on the six drives, and then retry with an
> array build from 5, 4, 3 and 2 drives successively, taking out the
> unused drives from chassis, to see if reducing the load on the power
> supply with a smaller array helps.

Yeap, that also should shed some light on it.

> When I try to write a test case, would it be worth me trying to
> reproduce without md in the loop, e.g. do 6-way simultaneous
> random-seek+write+sync continuously, or is it better to rely on md's
> barrier support and just do random-seek+write via md? Is there a
> standard work pattern/write size that would be particularly likely
> to provoke power overload problems on drives?

Excluding it out of the chain would be helpful but if md can reproduce
the problem reliably trying with md first would be easier.  :-)

>> So yes, an extended device timeout while updating the md superblock
>> can cause "cat /proc/mdstat" to hang for the duration of the timeout.
> 
> Thanks Neil. This implies that when we see these fifteen second
> hangs reading /proc/mdstat without write errors, there are genuinely
> successful superblock writes which are taking fifteen seconds to
> complete, presumably corresponding to flushes which complete but
> take a full 15s to do so.
>
> Would such very slow (but ultimately successful) flushes be
> consistent with the theory of power supply issues affecting the
> drives? It feels like the 30s timeouts on flush could be just a more
> severe version of the 15s very slow flushes.

Probably not.  Power problems usually don't resolve themselves with
longer timeout.  If the drive genuinely takes longer than 30s to
flush, it would be very interesting tho.  That's something people have
been worrying about but hasn't materialized yet.  The timeout is
controlled by SD_TIMEOUT in drivers/scsi/sd.h.  You might want to bump
it up to, say, 60s and see whether anything changes.

>>> Some of these timeouts also leave us with a completely dead drive,
>>> and we need to reboot the machine before it can be accessed
>>> again. (Hot plugging it out and back in again isn't sufficient to
>>> bring it back to life, so maybe a controller problem, although other
>>> drives on the same controller stay alive?) An example is [2].
>> Ports behave mostly independently and it sure is possible that one
>> port locks up while others operate fine.  I've never seen such
>> incidents reported for intel ahci's tho.  If you hot unplug and then
>> replug the drive, what does the kernel say?
> 
> We've only tried this once, and on that occasion there was nothing
> in the kernel log at all. (I actually telephoned the data centre
> engineer to ask when he was going to do it for us because I didn't
> see any messages, and it turned out he already had!)

Hmmm... that means the host port was dead.  Strange, I've never seen
intel ahci doing that.  If possible, it would be great if you can
verify it.

Thanks.

-- 
tejun
