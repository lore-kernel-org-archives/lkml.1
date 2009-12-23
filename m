Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZLWDfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZLWDfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 22:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZLWDf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 22:35:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:41892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbZLWDf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 22:35:28 -0500
Message-ID: <4B31907C.7070408@kernel.org>
Date: Wed, 23 Dec 2009 12:37:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>	  <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk>	  <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>	  <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>	  <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>	 <1261480220.4937.24.camel@laptop>	 <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain> <1261504042.4937.59.camel@laptop>
In-Reply-To: <1261504042.4937.59.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/23/2009 02:47 AM, Peter Zijlstra wrote:
> On Tue, 2009-12-22 at 09:20 -0800, Linus Torvalds wrote:
>>
>> So stop arguing about irrelevancies. Nobody uses workqueues for RT or for 
>> CPU-intensive crap. It's not what they were designed for, or used for.
> 
> RT crap maybe, but cpu intensive bits are used for sure, see the
> crypto/crypto_wq.c drivers/md/dm*.c.
>
> I've seen those consume significant amounts of cpu, now I'm not going to
> argue that workqueues are not the best way to consume lots of cpu, but
> the fact is they _are_ used for that.
>
> And since tejun's thing doesn't have wakeup parallelism covered these
> uses can turn into significant loads.

(cc'ing Herbert Xu and David Miller for crypt)

I wrote this before but if something is burning CPU cycles using MT
workqueues, this can be easily supported by marking such workqueue as
not concurrency-managed.  ie. Works queued for such workqueues
wouldn't contribute to the perceived workqueue concurrency and will be
left to be managed solely by the scheduler.  This will completely
cover the crypto_wq case which uses MT workqueue with local cpu
binding.

I don't think dm is currently using workqueue for checksumming but it
does use kcryptd (a ST workqueue) for dm-crypt.  My understanding of
crypt subsystem is limited but kcryptd simply passes the encryption
request to crypt subsystem which may then again pass the thing to
crypto workers (the MT workqueue described above) or process it
synchronously depending on how the encryption chain is setup.  In the
former case, cmwq with the above described modification wouldn't
change anything.  For the latter case, it would make the worker pinned
to a cpu while encrypting/decrypting but then again kcryptd spending
large amount of cpu cycles is simply wrong to begin with.  There's
only _single_ kcryptd which is shared by all dm-crypt instances.  It
should be issuing works to crypto workers instead of doing
encrypt/decrypt itself.

It seems that cryptd is building an async mechanism for CPU-intensive
tasks on top of workqueue mechanism, which can be well supported by
cmwq (not different from the current situation).  In the long run, the
right thing to do would to build a generic mechanism for this type of
workloads and share it among crypt, dm/btrfs block processing.  But,
at any rate, this doesn't really change anything for cmwq.  With
slight modification, it can support the current mechanisms just as
well.

>> People use workqueues for other things _today_, and they have annoying 
>> problems as they stand. It would be nice to get rid of the deadlock 
>> issue, for example - right now the tty driver literally does crazy things, 
>> and drops locks that it shouldn't drop due to the fact that it needs to 
>> wait for queued work - even if the queued work it is actually waiting for 
>> isn't the one that takes the lock!
> 
> Which in turn would imply we cannot carry fwd the current lockdep
> annotations, right?
>
> Which means we'll be stuck in a situation where A flushes B and B
> flushes A will go undetected until we actually hit it.

Lockdep annotations will keep working where it matters.  Why would it
change at all?

Thanks.

-- 
tejun
