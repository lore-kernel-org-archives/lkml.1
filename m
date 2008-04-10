Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYDJVFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYDJVFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbYDJVFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:05:15 -0400
Received: from rtr.ca ([76.10.145.34]:4613 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbYDJVFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:05:13 -0400
Message-ID: <47FE8107.4050400@rtr.ca>
Date: Thu, 10 Apr 2008 17:05:11 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: =?UTF-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
       Jeff Garzik <jeff@garzik.org>, rjw@sisk.pl,
       LKML <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <47FCF9DD.6080007@rtr.ca> <20080410.023045.16227424.yoshfuji@linux-ipv6.org> <47FD138B.2060801@rtr.ca> <20080409.152933.132174258.davem@davemloft.net> <47FD590C.5020003@rtr.ca> <Pine.LNX.4.64.0804101147070.24841@wrl-59.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0804101147070.24841@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Wed, 9 Apr 2008, Mark Lord wrote:
> 
>> David Miller wrote:
>>> From: Mark Lord <lkml@rtr.ca>
>>> Date: Wed, 09 Apr 2008 15:05:47 -0400
>>>
>>>> But it would be far more useful for whoever has been working on the
>>>> stack to suggest some possible/likely commits to look at instead.
>>> Personally all I see is that one side closes the socket before all
>>> data packets received have been read into the application, resulting
>>> in a (correct) reset going out.
>>>
>>> I can't think of any change we've made over the course of this
>>> release that would change behvaior in that area.
>>>
>>> So you will likely need to bisect.
>> ..
>>
>> Or I can ignore it, like the net developers, since I have a workaround.
>> And then we'll see what other apps are broken upon 2.6.25 final release.
>>
>> Really, folks.  Bug reports are intended to *help* the developers,
>> not something to be thrown back in their faces.
>>
>> There do seem to have been a *lot* of changes around the tcp closing/close
>> code (as I see from diff'ing 2.6.24 against latest -git).
..
> I might help if would add netdev on cc list in case you really want to 
> reac net developers, otherwise they might just end up "ignoring it"... ;-)
..

Oh.. I didn't know about that list.  How does that differ from linux-net ?
(Thanks)

> 
>> reducing the mountain of commits to a big handful or two.
> 
> Those touching fin/close are mostly whitespace/move things, so I doubt 
> that you find these useful but in case you insist, here's the list:
>
> 056834d9f6f6eaf4cc7268569e53acab957aac27 [TCP]: cleanup tcp_{in,out}put.c style
> 058dc3342b71ffb3531c4f9df7c35f943f392b8d [TCP]: reduce tcp_output's indentation levels a bit
> 490d5046930276aae50dd16942649bfc626056f7 [TCP]: Uninline tcp_set_state
> 
> In addition, there's this one (...though I have read it number of times 
> through and still cannot catch something that would cause the wrongness 
> you're seeing):
> 
> e870a8efcddaaa3da7e180b6ae21239fb96aa2bb [TCP]: Perform setting of common 
> control fields in one place
> 
> There's very little really on interesting side I can think of, mostly 
> thinks are congestion control related changes... ...maybe either one of 
> these could cause something unpleasant in some corner case:
> 
> bd515c3e48ececd774eb3128e81b669dbbd32637 [TCP]: Fix TSO deferring
> 0e3a4803aa06cd7bc2cfc1d04289df4f6027640a [TCP]: Force TSO splits to MSS boundaries
> 
> ...e.g., if the latter causes a return with zero limit under some 
> conditions, tso_fragment might generate, well, interesting packets and 
> never finish if the condition persists but.
..

That matches my own assessment there, too: lot's of whitespace changes,
and not much real code difference on most paths.  Bummer.  :)

-ml

