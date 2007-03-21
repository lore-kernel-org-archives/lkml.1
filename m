Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXCURnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXCURnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933236AbXCURnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:43:31 -0400
Received: from dkl3.neoplus.adsl.tpnet.pl ([83.24.15.3]:63064 "EHLO
	dkl3.neoplus.adsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933231AbXCURna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:43:30 -0400
X-Greylist: delayed 1157 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 13:43:30 EDT
Message-ID: <46016A3B.2090205@o2.pl>
Date: Wed, 21 Mar 2007 18:24:11 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1 (X11/20070320)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com> <200703192353.19673.a1426z@gawab.com> <46003B1B.9070601@o2.pl> <200703210715.35898.a1426z@gawab.com>
In-Reply-To: <200703210715.35898.a1426z@gawab.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Artur Skawina wrote:
>> Al Boldi wrote:
>>> -	p->quota = rr_quota(p);
>>> +	/*
>>> +	 * boost factor hardcoded to 5; adjust to your liking
>>> +	 * higher means more likely to DoS
>>> +	 */
>>> +	p->quota = rr_quota(p) + (((now - p->timestamp) >> 20) * 5);

>> mouse cursor stalls lasting almost 1s. i/o bound tasks starving X?
>> After reverting the patch everything is smooth again.
> 
> This patch wasn't really meant for production, as any sleeping background 
> proc turned cpu-hog may DoS the system.
> 
> If you like to play with this, then you probably want to at least reset the 
> quota in its expiration.

well, the problem is that i can't reproduce the problem :) I tried
the patch because i suspected it could introduce regressions, and it
did. Maybe with some tuning a reasonable compromise could be found,
but first we need to know what to tune for... Does anybody have a
simple reproducible way to show the scheduling regressions of RSDL
vs mainline? ie one that does not involve (or at least is
independent of) specific X drivers, binary apps etc. Some reports
mentioned MP, is UP less susceptible?

I've now tried a -j2 kernel compilation on UP and in the not niced
case X interactivity suffers, which i guess is to be expected when
you have ~5 processes competing for one cpu (2*(cc+as)+X). "nice -5"
helps a bit, but does not eliminate the effect completely. Obviously
the right solution is to nice the makes, but i think the scheduler
could do better, at least in the case of almost idle X (once you
start moving windows etc it becomes a cpuhog just as the the
compiler). I'll look into this, maybe there's a way to prioritize
often sleeping tasks which can not be abused.
Another thing is the nice levels; right now "nice -10" means ~35%
and "nice -19" gives ~5% cpu; that's probably 2..5 times too much.

artur
