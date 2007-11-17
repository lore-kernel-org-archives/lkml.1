Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXKQNgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXKQNgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 08:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXKQNgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 08:36:13 -0500
Received: from ns.suse.de ([195.135.220.2]:53818 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXKQNgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 08:36:12 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Dane Mutters <dmutters@gmail.com>,
       Martin Olsson <mnemo@minimum.se>, linux-kernel@vger.kernel.org
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
From: Andi Kleen <andi@firstfloor.org>
References: <473E815F.30900@minimum.se>
	<20071116213137.6efe3f9e@the-village.bc.nu>
	<473E9290.3040006@minimum.se> <1195281942.15929.5.camel@Orchestrator>
	<1195285481.3059.12.camel@twins>
	<20071117103922.12f3823b@the-village.bc.nu>
Date: Sat, 17 Nov 2007 14:36:10 +0100
In-Reply-To: <20071117103922.12f3823b@the-village.bc.nu> (Alan Cox's message of "Sat\, 17 Nov 2007 10\:39\:22 +0000")
Message-ID: <p737ikhat9x.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> > I would like to see something done about this, with Ubuntu as popular as
>> > it is, even as a server in some cases.  Is there a way that in the
>> > future, one could simply download a package or click a box or something
>> > and have a limit set, like the links suggest?  That would make things
>> > just "that much" more convenient for system administrators (and might
>> > help them/us to remember to set these limits, too...).
>> 
>> If you don't know which limits to set and need a package for them, your
>> job title should not be system administrator.
>
> Thats a very arrogant viewpoint. I don't have to be a TV engineer to use
> my television.
>
> Distributions should be providing sensible defaults out of the box. The
> kernel already provides them the mechanisms.

If you mean ulimits -- the current ulimits are not very useful imho.   Or 
at least not for handling the general resource resumption problem. They
work in some limited circumstances for well known special purpose workloads,
but not more. 

I don't know why people here always claiming they are (have they ever
tried to use them on your desktop in general?).

The equation to limit resources is something like:

MAX_PROCESSES_PER_UID*(MAX_MEM_PER_PROCESS+MAX_FD_PER_PROCESS+...)=TOTAL_RESOURCES_UID

To get an effective limit you either need MAX_PROCESSES or MAX_MEM to unusable
low numbers breaking a lot of applications. And you cannot generally predict 
in advance if the workload will need high MAX_MEM or high MAX_PROCESSES
or a combination of both.

That is why distributions usually don't set them. Or at least not for
in a setup to protect the system fully because that is not possible.

e.g. SUSE supports a optional default limit that sets the max memory
per process to below the available memory, but the user can still
easily circumvent that by starting multiple processes.

And I'm not really talking about a general bean counter for all kernel
objects here, just the "ordinary easy resources" like processes and virtual
memory.

Pretty much all the per process limits would need to be per uid to be really
useful in general. I'm hoping that we'll get some of that out of the recent
container work. e.g. if there was a "max mem per uid" then you could actually
set it to a sensible value. Even better than max mem per uid would be probably
"max total memory used as fraction of the system" or something like that --
that would also handle things like memory hotplug etc. well. Probably
would also need to be separated into swap space and real memory; at least
as long as the Linux swap algorithms are so slow.

Regarding the fork bomb problem: 

the uid cgroup scheduler that went in recently should already help a little,
although to be really effective against fork bombs for a desktop user you
would probably need multiple cgroups per uid (so e.g. that the window
manager is also protected against other processes running on the same
uid and you can then still kill the nasty processes from it).

That is why I didn't like hardcoding the uid in the scheduler too much.

-Andi
