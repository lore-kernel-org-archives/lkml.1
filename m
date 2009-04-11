Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZDKTFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZDKTFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbZDKTFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:05:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758250AbZDKTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:05:41 -0400
Date: Sat, 11 Apr 2009 11:57:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, shemminger@vyatta.com,
       jeff.chua.linux@gmail.com, dada1@cosmosbay.com, jengelh@medozas.de,
       kaber@trash.net, r000n@r000n.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: iptables very slow after commit
 784544739a25c30637397ace5489eeb6e15d7d49
In-Reply-To: <20090411041533.GB6822@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0904111150380.4583@localhost.localdomain>
References: <Pine.LNX.4.64.0904101656190.2093@boston.corp.fedex.com> <20090410095246.4fdccb56@s6510> <20090410.182507.140306636.davem@davemloft.net> <alpine.LFD.2.00.0904101828490.4583@localhost.localdomain> <20090411041533.GB6822@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, Paul E. McKenney wrote:
> 
> 1.	Assuming that the synchronize_net() is intended to guarantee
> 	that the new rules will be in effect before returning to
> 	user space:

Btw, I think that's a bad assumption.

The thing is, nobody can really care if the new rules are in effect or 
not, because the thing you race with is not the "return to user space" 
part, but the incoming packets.

And those incoming packets might have been incoming before the rules were 
set up too.

So I seriously doubt you need to synchronize with any returning to user 
space. What you want to synchronize with is then later actions that do 
things like turning on the interface that the rules are attached to etc!

So I would suggest:

 - remove the synchronize_net() entirely. Replace it with just freeing the 
   old rules using RCU.

 - new packets will always end up seeing the new rules. That includes the 
   case of somebody doing "ifconfig eth0 up" that enables a new source of 
   packets, so there are no real security issues.

 - if you enabled your network interfaces before you updated your packet 
   filtering rules, you already had a window where packets would come in 
   with the old rules, so doing a "synchronize_net()" in no way protects 
   against any race conditions anyway.

Am I missing something?

			Linus
