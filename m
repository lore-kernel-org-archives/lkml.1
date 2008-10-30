Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYJ3S5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYJ3S5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYJ3S5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:57:34 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33777 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYJ3S5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:57:34 -0400
Message-ID: <490A0364.3040902@cosmosbay.com>
Date: Thu, 30 Oct 2008 19:56:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Evgeniy Polyakov <s0mbre@tservice.net.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
References: <20081009231759.GA8664@tservice.net.ru>	<20081010115518.GA3159@tservice.net.ru>	<20081010115725.GD19487@elte.hu>	<200810250025.35734.rjw@sisk.pl>	<20081026112924.GA29258@ioremap.net>	<20081026122300.GA30905@ioremap.net> <20081030111526.7d9bb0f8@extreme> <490A0054.2030903@cosmosbay.com>
In-Reply-To: <490A0054.2030903@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 30 Oct 2008 19:56:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Stephen Hemminger a écrit :
>> Has anyone looked into the impact of port randomization on this 
>> benchmark.
>> If it is generating lots of sockets quickly there could be an impact:
>>   * port randomization causes available port space to get filled 
>> non-uniformly
>>     and what was once a linear scan may have to walk over existing ports.
>>     (This could be improved by a hint bitmap)
>>
>>   * port randomization adds at least one modulus operation per socket
>>     creation. This could be optimized by using a loop instead.
> 
> 
> 
> tbench setups one socket per client, then send/receive lot of messages 
> on this socket.
> 
> Connection setup time can be ignored for the tbench regression analysis
> 

Hum, re-reading your question, I feel you might have a valid point after all :)

Not because of connection setup time, but because the rwlocks used on tcp hash table.

tcp sessions used on this tbench test might now be on the same cache lines,
because of port randomization or so.

CPUS might do cache-line ping pongs on those rwlocks.

# netstat -tn|grep 7003
tcp        0     59 127.0.0.1:37248         127.0.0.1:7003          ESTABLISHED
tcp        0     71 127.0.0.1:7003          127.0.0.1:37252         ESTABLISHED
tcp        0      0 127.0.0.1:37251         127.0.0.1:7003          ESTABLISHED
tcp        0   4155 127.0.0.1:7003          127.0.0.1:37249         ESTABLISHED
tcp        0     55 127.0.0.1:7003          127.0.0.1:37248         ESTABLISHED
tcp        0      0 127.0.0.1:37252         127.0.0.1:7003          ESTABLISHED
tcp        0      0 127.0.0.1:37249         127.0.0.1:7003          ESTABLISHED
tcp        0     59 127.0.0.1:37246         127.0.0.1:7003          ESTABLISHED
tcp        0      0 127.0.0.1:37250         127.0.0.1:7003          ESTABLISHED
tcp       71      0 127.0.0.1:37245         127.0.0.1:7003          ESTABLISHED
tcp        0      0 127.0.0.1:37244         127.0.0.1:7003          ESTABLISHED
tcp        0     87 127.0.0.1:7003          127.0.0.1:37250         ESTABLISHED
tcp        0   4155 127.0.0.1:7003          127.0.0.1:37251         ESTABLISHED
tcp        0   4155 127.0.0.1:7003          127.0.0.1:37246         ESTABLISHED
tcp        0     71 127.0.0.1:7003          127.0.0.1:37245         ESTABLISHED
tcp        0   4155 127.0.0.1:7003          127.0.0.1:37244         ESTABLISHED

We use a jhash, so normally we could expect a really random split of hash values
for all these sessions, but it would be worth to check :)

You know understand why we want to avoid those rwlocks Stephen, and switch to RCU...

