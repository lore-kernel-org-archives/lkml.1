Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXA3LBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXA3LBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbXA3LBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:01:11 -0500
Received: from highlandsun.propagation.net ([66.221.212.168]:4320 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932876AbXA3LBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:01:10 -0500
Message-ID: <45BF2570.5000408@symas.com>
Date: Tue, 30 Jan 2007 03:01:04 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9a2pre) Gecko/20070128 Netscape/7.2 (ax) Firefox/1.5 SeaMonkey/1.5a
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>
Subject: Re: Why active list and inactive list?
References: <45B62376.9000303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel <r...@redhat.com> wrote:
>> CLOCK-Pro is still vulnerable to the cyclic scan use case, since at that
>> time all pages will have equal distance.
> 
> That's fixable.  Just bias in favor of the already active
> pages and only let pages with a clearly smaller interreference
> distance replace them.

Yes, I asked Song Jiang about whether this was a normal behavior, and he 
mentioned it would be an easy fix.

> Getting rid of swappiness is a very good thing, IMHO.
> I have heard about a few customer workloads that required
> changes to swappiness in order for the system to be able
> to handle their workload at all.
> 
> Systems should not have to be tuned like that...

Can say that again...

>> The main problem I'm having is test cases, notably the lack thereof.
>> (and lack of time ofcourse ;-)
> 
> Yes, this is always a problem.  I am not aware of any complete
> test cases to test page replacement.

"Complete" would seem to be impossible. Exercise all code paths, sure. But 
exercise all usage patterns, I think you're just going to have to pick a few 
scenarios and hope you didn't miss anything bad.

> It would be easy to simulate some database by having part of
> the dataset be the index and referencing that in an r^2 way,
> and the rest being the data which is referenced less.  At that
> point you can see how taking frequency into account helps.

> However, tests like that are simply not complete.  They are
> not representative of the things most people do with their
> system.

Is *anything* really representative of "most people"? After all there is 
nobody out there who is actually Joe Average.

> Something like AIM-7 suffers from the same problems...
> 
> Anybody?

No great ideas spring to mind. We very seldom run in machines that are 
memory-constrained, so very few of our tests are oriented toward that.

If you're just testing to see if getting rid of swappiness is feasible, I 
think a fair test would just be a program that alternately touches 
file-backed pages vs anonymous RAM. E.g., allocate 2GB of RAM and mmap 2GB of 
a file on a machine with only 2GB of free RAM. Walk through each memory range 
and make sure the balance of memory shifts as expected. Cycle that, increase 
the stride on each cycle, and toss some other variations in there. You don't 
need to drive real apps, you just need to have a couple of threads exerting 
pressure.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc
   OpenLDAP Core Team            http://www.openldap.org/project/
