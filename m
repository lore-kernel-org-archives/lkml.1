Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbZDVQ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbZDVQ7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZDVQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:58:56 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:44110 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZDVQ6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:58:55 -0400
Message-ID: <49EF4C75.6060604@cosmosbay.com>
Date: Wed, 22 Apr 2009 18:57:25 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephen Hemminger <shemminger@vyatta.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
References: <20090420103414.1b4c490f@nehalam> <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam> <alpine.LFD.2.00.0904210831560.2199@localhost.localdomain> <20090421111541.228e977a@nehalam> <20090421191007.GA15485@elte.hu> <49EE2293.4090201@cosmosbay.com> <20090422073524.GA31835@elte.hu> <49EEDAF0.2010507@cosmosbay.com> <alpine.LFD.2.00.0904220806320.3101@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904220806320.3101@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 22 Apr 2009 18:57:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 22 Apr 2009, Eric Dumazet wrote:
>> If this could be done without recursion, I am pretty sure netfilter
>> and network guys would have done it. I found Linus reaction quite
>> shocking IMHO, considering hard work done by all people on this.
> 
> You don't _understand_ do you?
> 
> There is a huge difference between recursive code, and a recursive lock.
> 
> The netfilter code may need to occasionally re-enter itself. Nobody ever 
> contested _that_ part.
> 
> What I have disagreed with the whole time is 
> 
>  (a) doing local ad-hoc locking primitives without any comments 
>      what-so-ever.
> 
>  (b) Doing them _wrong_ in many cases
> 
>  (c) Calling the _lock_ a "recursive" lock.
> 
> The fact that a lock works with recursion doesn't make it "recursive". 
> That generally has a very special meaning for locking primitives, and 
> means something else.
> 
> In contrast, a read-write lock actually has known properties, and we have 
> existing locking mechanisms for those. And we call them read-write locks 
> DESPITE THE FACT that the reading part can be done recursively. 
> 
> If you call a read-write lock a "recursive" lock, then you're a moron. 
> It simply is _not_ a recursive lock. And neither is the lock you actually 
> implemented, even though you (and Stephen) continually call it that. 
> 
> SO STOP CALLING IT A RECURSIVE LOCK. Look at your very own code: you can 
> actually only use that lock in a recursive context in a _very_ specific 
> place. Notice how it's only "recursive" when taken in the per-CPU context, 
> but _not_ recursive when the filter-updating code ("writer") takes it?
> 
> Do you understand now? It really shouldn't be so hard for you. 
> 
> Naming is important. Locking is important. You did both things wrong. You 
> named your locks something incorrect and mis-leading that didn't actually 
> describe them, and you did your own private locking code without then 
> documenting what the rules for this special lock were.
> 
> Maybe in your world that's ok. But no, in mine it's not. I've seen too 
> many damn _non-functioning_ locks to ever want to see stuff like that 
> again.
> 
>

Linus,

I actually sent *one* buggy patch, and you already gave your feedback and NACK.

Fine

I even relayed this to Stephen suggesting him not calling this a recursive lock.
(Note how I use 'suggesting' here)

So, what do you want from me ? Should I copy 100 times :

"I should not call it a recursive lock. I shall not invent new locking infra. I am a moron." 
"I should not call it a recursive lock. I shall not invent new locking infra. I am a moron." 
"I should not call it a recursive lock. I shall not invent new locking infra. I am a moron." 
"I should not call it a recursive lock. I shall not invent new locking infra. I am a moron." 
"I should not call it a recursive lock. I shall not invent new locking infra. I am a moron." 
"I should not call it a recursive lock. I shall not invent new locking infra. I am a moron." 
...

OK done

Can we now proceed and continue ?

Thank you

