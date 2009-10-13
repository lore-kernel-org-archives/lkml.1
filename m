Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZJMMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZJMMEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZJMMEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:04:36 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:37579 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZJMMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:04:35 -0400
Date: Tue, 13 Oct 2009 14:03:54 +0200
From: Herbert Poetzl <herbert@13thfloor.at>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: vatsa@in.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20091013120354.GF24787@MAIL.13thfloor.at>
Mail-Followup-To: Pavel Emelyanov <xemul@openvz.org>, vatsa@in.ibm.com,
	Bharata B Rao <bharata@linux.vnet.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Avi Kivity <avi@redhat.com>, Chris Friesen <cfriesen@nortel.com>,
	Paul Menage <menage@google.com>, Mike Waychison <mikew@google.com>
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com> <4AD466E5.4010206@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD466E5.4010206@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:39:17PM +0400, Pavel Emelyanov wrote:
> > IMO Pavel's requirement can be met with a hard limit of 25%
> > 
> > 	2 CPU of 1GHz = (1/2 x 4) (1/2 x 2) GHz CPUs
> > 		      = 1/4 x 4 2GHz CPU
> > 		      = 25% of (4 2GHz CPU)
> > 
> > IOW by hard-limiting a container thread to run just 0.5sec every
> > sec on a 2GHz cpu, it is effectively making progress at the rate of
> > 1GHz?

> So, any suggestions on this? I'm not against the patches themselves.
> I'm just trying to tell, that setting a cpulimit with 2 numbers is
> not a good way to go (at least a clean explanation of how to calculate
> them should go with the patches).

as I already stated, it seems perfectly fine for me (to have
two values, period and runtime), IMHO it is quite natural to 
understand and it allows (to some degree) to control the
scheduling behaviour by controlling the multiplicator (i.e.
use 1s/0.5s vs 100ms/50ms) ...

we already incorporated the patch (for testing) in our
current release, and it seems to work fine and do what we
need/want (see http://linux-vserver.org/util-vserver:Cgroups)

> I propose to first collect what *can* be done. I see the following
> possibilities:

> 1) two times (as it is now) - I believe this is inconvenient.
> 2) the amount in percents (like 50%) - this is how it works in
>    OpenVZ and customers are quite happy with it. It's better than
>    two numbers, since you need to specify only one clean number.

can be trivially mapped to the two values, by chosing a
fixed multiplicative base (let's say '1s' to simplify :) 

  with 50%, you get 1s/0.5s
  with 20%, you get 1s/0.2s
  with  5%, you get 1s/0.05s

well, you get the idea :)

> 3) virtual cpu power in M/GHz - I don't agree with Balbir that
>    this is difficult for administrator. This is better than two
>    numbers and better that the percentage, since the amount of
>    cpu time got by a container will not change after migrating to
>    a more powerful CPU.

I think this is completely artificial, and adds a lot
of silly cornercases, like e.g. cpu speed changes (think
SpeedStep and friends) and doesn't help the administration
in any way ... nevertheless, it should also be trivial to
map to the two values if you do the following:

  Host CPU = 4.5GHz
  Desired Guest CPU = 2.0Ghz

  2.0/4.5 = 0.44' -> 44% -> 1s/0.44s

> Thoughts?

so once again, 'we' (Linux-VServer) are perfectly happy
with the current status, the only difference to what we
used to have is that we calculated the period and runtime
in jiffies not micro seconds, and called them interval
and rate (which is as simple to map as the percentage
OpenVZ uses)

best,
Herbert

> > - vatsa
> > 
