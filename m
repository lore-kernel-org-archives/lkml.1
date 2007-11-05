Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXKEXOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXKEXOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXKEXOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:14:14 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:36748 "EHLO
	omta14.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754740AbXKEXON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:14:13 -0500
X-Greylist: delayed 1612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2007 18:14:13 EST
X-Eon-Dm: dm43
X-Eon-Sig: AQEbFf9HL51l+H1mWQIAAAAE,b1e485d37b9e49bcefa07d32d6ca4953
Message-ID: <472F9D63.7010906@us.ibm.com>
Date: Mon, 05 Nov 2007 14:46:59 -0800
From: Mike Mason <mmlnx@us.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@shafik.org, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [to-be-posted-soon] Multiple handlers per marker
References: <472A345C.2010208@us.ibm.com> <20071101221530.GC19700@Krystal> <20071102033654.GA1301@Krystal> <20071104232442.GA32320@Krystal>
In-Reply-To: <20071104232442.GA32320@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
>> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
>>> * Mike Mason (mmlnx@us.ibm.com) wrote:
>>>> Hi Mathieu,
>>>>
>>>> Are you aware of any working being done to allow multiple handlers to be 
>>>> attached to a marker?  Something like what kprobes allows.  I've started to 
>>>> look into this and don't want to duplicate efforts.
>>>>
>>> Nope, but I know we will have to address this.
>>>
>>> Something along the lines of walking an RCU list of function pointers,
>>> calling them.
>>>
>>> The only downside I see is that we will have to pass a va_list * instead
>>> of real va args. The could make the marker site a little bit bigger and
>>> will change the probe callback arguments.
>>>
>>> What do you think about these ideas ?
>>>
>>> If we can find a way to make the common case (only one probe connected)
>>> _ultra_ fast, and yet architecture independent, that would be awesome. A
>>> simple call is kind of hard to beat though.. So we may have to think
>>> about a design with :
>>>
>>> - One call at the marker site
>>> - if 1 probe is installed :
>>>   - If the format string is empty, connect a probe without va args.
>>>   - If the format string is not empty, connect a "stage 1" probe that takes
>>>     the va args, starts/ends the va_list and calls _one_ function (let's
>>>     call it "stage 2" probe), that takes va_list as parameter.
>>> - if more than 1 probe is installed :
>>>   - The stage 1 probe creates the va_list and passes it to each function
>>>     connected, iterated with an RCU list.
>>>
>>> What do you think ?
>>>
>>> Mathieu
>>>
>> I'm working on an implementation.
>>
> 
> It's ready for testing. Please grab
> http://ltt.polymtl.ca/lttng/patch-2.6.24-rc1-git13-lttng-0.10-pre18.tar.bz2
> patch name :
> 
> markers-support-multiple-probes.patch

This patch alone doesn't apply cleanly at all on 2.6.24-rc1-git14.  Are there other patches in this series I should apply first?

Mike

> 
> It still need to go through patchcheck.pl and some polishing, but it
> seems to work fine for me with multiple probes (the sample marker,
> sample probe and multiple instances of my lttng probes can
> connect/disconnect without problem).
> 
> Currently, the "connect/disconnect" and "arm/disarm" operations are
> separate. However, they could be merged. Any comment/preference on this?
> Being separate, a probe provider can wait until the very last moment
> before it activates its markers, with a minimalistic impact on the
> system, but it is not such a strong argument.
> 
> Mathieu
> 
