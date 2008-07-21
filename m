Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYGUTVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYGUTVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYGUTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:20:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52521 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbYGUTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:20:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4884E174.5030802@s5r6.in-berlin.de>
Date: Mon, 21 Jul 2008 21:20:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080719 SeaMonkey/1.1.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [crash] kernel BUG at net/core/dev.c:1328!
References: <20080721134506.GA27598@elte.hu>	<20080721182318.GA20940@elte.hu>	<alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org> <20080721.120052.123606398.davem@davemloft.net>
In-Reply-To: <20080721.120052.123606398.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 21 Jul 2008 11:35:21 -0700 (PDT)
> 
>> Maybe the network drivers are few enough that it will get fixed, or
>> maybe the WARN_ON_ONCE() will just be removed and the rule not
>> reinforced.
>>
>> I personally suspect the latter, since it seems to happen with just
>> about _any_ random network driver, including the common and
>> well-maintained ones (ie the Gods only help us for the truly
>> odd/random cases)
> 
> Yes, we'll see how this plays out.
> 
> Ian Schram just posted a patch for the NULL pointer derfer in
> wireless Ingo reported, so we'll see if that bug will be fixed
> now as well.

In the meantime:  Is there perhaps something obviously wrong with 
drivers/ieee1394/eth1394.c's netdevice initialization?  We do it in 
ether1394_add_host(), and shortly thereafter the crashing 
ether1394_host_reset() is called.  So we have essentially

(add host)
	dev = alloc_netdev(...);
	initialize various members in dev...
	register_netdev(dev);

(host reset)
	netif_stop_queue(dev);
	discard some stale 1394 stuff if there were some...
	netif_wake_queue(dev);  <-- crashes in __netif_schedule(dev);

-- 
Stefan Richter
-=====-==--- -=== =-=-=
http://arcgraph.de/sr/
