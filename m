Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYL2Qef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYL2Qef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYL2Qe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:34:26 -0500
Received: from mail.lang.hm ([64.81.33.126]:35309 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYL2Qe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:34:26 -0500
Date: Mon, 29 Dec 2008 09:36:11 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Oleg Nesterov <oleg@redhat.com>
cc: Scott James Remnant <scott@canonical.com>,
       Roland McGrath <roland@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Notify init when processes are reparented to it
In-Reply-To: <20081229155735.GA6906@redhat.com>
Message-ID: <alpine.DEB.1.10.0812290930550.15026@asgard.lang.hm>
References: <1230378128.7026.50.camel@quest> <20081227114452.GA2919@zelda.netsplit.com> <20081228092024.GA21673@redhat.com> <20081228220122.62940FC278@magilla.sf.frob.com> <1230551457.4664.0.camel@wing-commander> <20081229132305.GA31210@redhat.com>
 <1230564071.4664.8.camel@wing-commander> <20081229155735.GA6906@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, Oleg Nesterov wrote:

> On 12/29, Scott James Remnant wrote:
>>
>> On Mon, 2008-12-29 at 14:23 +0100, Oleg Nesterov wrote:
>>
>>>> We want to be able to supervise daemons.
>>>
>>> What do you mean?
>>>
>>>> Later on, 1002 will die and init will receive SIGCHLD for it.
>>>>
>>>> Unfortunately neither the 1001 or 1002 processes are known to init, even
>>>> though they are original children of the process it spawned (1000), for
>>>> init to be notified about them - this has been forgotten.
>>>
>>> Ok, with this patch /sbin/init knows that 1002 is a descendant
>>> of apache(1000) which was spwaned by init. What can init do
>>> with this info?
>>>
>> Fundamentally init would now know that the apache service terminated,
>> and with what exit code or by what signal.
>>
>> Right now, all we know is that a process terminated (and why) - we can't
>> link that back to a service in any kind of foolproof manner.
>>
>> With the ability to do that, when the apache service dies, we can log
>> that in a more useful manner (including marking the service as down) -
>> but most importantly, we can respawn it!
>
> Aha, thanks, I suspected something like this.
>
> But how can we know (in general) that the service has died? We only
> know that the process has exited.
>
> IOW. when apache(1001) exits, we don't respawn. How can init know that
> the death of apache(1002) means "this is the real exit of service, the
> previous exits were due to initialization stage".
>
> The only answer I can see is: because init can figure out that all
> descendants of initially spawned apache(1000) have exited. But this
> doesn't look very flexible/reliable to me.

there are a number of options here.

init can look for error exit codes and respawn things that died with 
errors.

init can be taught what normal behavior is for different daemons (some 
sort of configuration options)

init can look for cases where all children have exited.

init could do monitoring of aplications, and if an application is deemed 
'sick' can make sure that it kills all processes associated with that 
application before trying to respawn it. (this is much more then what init 
has doesn historicly, and may not be a good idea for the general case, but 
it is still a possibility that will make sense in some cases)

I'm sure that there are other things that can be done with such a 
mechansims, this is just what I can think of off the top of my head

> And we already have CONFIG_PROC_EVENTS, init can monitor PROC_EVENT_FORK
> events, so it can do this without ->adopt_signal ?

wouldn't that require init to pay attention to every fork in the system to 
find the ones that it cares about?

also, an earlier post gave one reason for wanting to use signals being to 
eliminate race conditions.

David Lang
