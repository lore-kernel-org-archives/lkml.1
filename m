Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZLUNTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZLUNTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZLUNTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:19:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:53388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZLUNTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:19:33 -0500
Message-ID: <4B2F7593.7070002@kernel.org>
Date: Mon, 21 Dec 2009 22:18:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <20091221110929.GF25372@basil.fritz.box> <4B2F592C.4000504@linux.intel.com>
In-Reply-To: <4B2F592C.4000504@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On 12/21/2009 08:17 PM, Arjan van de Ven wrote:
>>> One would hope not, since that is by no means outside of what you see on
>>> boxes today... Thousands. The fact that they are cheap, is not an
>>> argument against doing it right. Conceptually, I think the concurrency
>>> managed work queue pool is a much cleaner (and efficient) design.
>>
>> Agreed. Even if possible thousands of threads waste precious cache.
> 
> only used ones waste cache ;-)

Yes and using dedicated threads increases the number of used stacks.
ie. with cmwq, in most cases, only few stacks would be active and
shared among different works.  With workqueues with dedicated workers,
different type of works will always end up using different stacks thus
unnecessarily increasing cache footprint.

>> And they look ugly in ps.
> 
> that we could solve by making them properly threads of each other;
> ps and co already (at least by default) fold threads of the same
> program into one.

That way poses two unnecessary problems.  It will easily incur a
scalability issue.  ie. I've been thinking about making block EHs
per-device so that per-device EH actions can be implemented which
won't block the whole host.  If I do this with dedicated threads and
allocate single thread per block device, it will be the easiest,
right?  The problem is that there are machines with tens of thousands
of LUNs (not that uncommon either) and such design would simply
collapse there.

Such potential scalability issues thus would require special crafting
at the block layer to manage concurrency to gurantee both EH forward
progress and proper level of concurrency without paying too much
upfront.  We'll need another partial solution to solve concurrency
there and it never stops there.  What about in-kernel media presence
polling?  Or what about ATA PIO pollers?

>> Also the nice thing about dynamically sizing the thread pool
>> is that if something bad (error condition that takes long) happens
>> in one work queue for a specific subsystem there's still a chance
>> to make process with other operations in the same subsystem.
> 
> yup same is true for hitting some form of contention; just make an
> extra thread so that the rest can continue.

cmwq tries to do exactly that.  It uses scheduler notificatinos to
detect those contentions and creates new workers if everything is
blocked.  The reason why rescuers are required is to guarantee forward
progress in creating workers.

Thanks.

-- 
tejun
