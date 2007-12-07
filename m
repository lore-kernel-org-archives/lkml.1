Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXLGJ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXLGJ3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXLGJ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:29:19 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:48558 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbXLGJ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:29:18 -0500
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02NkfMqoFqI5zZfblYF
From: Stefan Rompf <stefan@loplof.de>
To: David Miller <davem@davemloft.net>
Subject: Re: sockets affected by IPsec always block (2.6.23)
Date: Fri, 7 Dec 2007 10:29:04 +0100
User-Agent: KMail/1.9.5
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200712061330.20586.stefan@loplof.de> <200712061531.54107.stefan@loplof.de> <20071206.192030.170597084.davem@davemloft.net>
In-Reply-To: <20071206.192030.170597084.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071029.05092.stefan@loplof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 7. Dezember 2007 04:20 schrieb David Miller:

> If IPSEC takes a long time to resolve, and we don't block, the
> connect() can hard fail (we will just keep dropping the outgoing SYN
> packet send attempts, eventually hitting the retry limit) in cases
> where if we did block it would not fail (because we wouldn't send
> the first SYN until IPSEC resolved).

David - I'm aware of this, the discussion is which behaviour is ok. Let's go 
back to a real life example. I've already researched that the squid web proxy 
has a poll() based main loop doing nonblocking connects, may be with multiple 
threads.

Situation: One user wants to access a web page that needs IPSEC. The SA takes 
30 seconds to come up.

a) Non-blocking connect is respected: SYN packets during the first 30 seconds 
will be dropped as you said. Connection can be completed on the next SYN 
retry (timeout in linux: 3 minutes). During this time, the 500 other users 
can continue to browse using the proxy.

b) Non-blocking connect is ignored during IPSEC resolving as you advocate it: 
Connection for the one user can be completed immediatly after IPSEC comes up. 
That's the pro. However, until then, the other 500 proxy user CANNOT ACCESS 
THE WEB because squid's threads are stuck in connect()s on sockets they 
configured not to block. If the IPSEC SA never resolves due to some network 
outage, squid will sleep forever or until an admin configures it that it 
doesn't try to connect the adress in question and restarts it.

Don't you realize how broken this behaviour is? Can you give me ONE example of 
an application that works better with b) and why this outweights the problems 
it creates for everybody else?

Even the DNS example you posted in  
<20071204.231200.117152338.davem@davemloft.net> is wrong because the second 
server will never queried if the kernel puts the process into coma while the 
IPSEC SA to the first server cannot be resolved.

Stefan
