Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205Ab0ATAOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0ATAOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172Ab0ATAOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:14:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:52022 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0ATAOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:14:37 -0500
Message-ID: <4B564C23.1030708@kernel.org>
Date: Wed, 20 Jan 2010 09:19:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative implementation
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org>	<20100118072523.2683cd59@linux.intel.com>	<4B55038D.3070106@kernel.org>	<4B550384.8030103@linux.intel.com>	<4B5565BE.4050406@kernel.org> <20100119063718.3f1f39cc@linux.intel.com>
In-Reply-To: <20100119063718.3f1f39cc@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 00:13:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On 01/19/2010 11:37 PM, Arjan van de Ven wrote:
>> This too can be implemented using wq directly.  More below.
> 
> however you are forcing the function to be split in pieces,
> which makes for a more complex programming model.
> For example, I have trouble proving to myself that your ata conversion
> is acutally correct.

I think it is.  :-)

>> The tradeoff changes with the worker pool implementation can be shared
>> with workqueue which provides its own ways to control concurrency and
>> synchronize. 
> 
> while I don't mind sharing the pool implementation (all 20 lines of
> it ;-), I don't think the objective of sharing some implementation
> detail is worth complicating the programming model.

Oh yeah, we can definitely pay some lines of code for a separate
synchronization model if it makes driver writers' lives easier.  I'm
just wondering whether the benefit is enough to justify a separate
sync model.

>> Before, the cookie based synchronization is something
>> inherent to the async mechanism.  The async worker pool was needed and
>> the synchronization mechanism came integrated with it.  Now that the
>> backend can be replaced with workqueue which supplies its own ways of
>> synchronization, the cookie based synchronization model needs stronger
>> justification as it no longer comes as a integral part of something
>> bigger which is needed anyway.
> 
> the wq model is either "full async" or "fully ordered".
> the cookie mechanism allows for "run async for the expensive bit, and
> then INSIDE THE SAME FUNCTION, synchronize, and then run some more".

Hmmm...

>> If so, we can leave the list based cookie synchronization alone and
>> simply use wq's to provide concurrency only without using its
>> synchronization mechanisms (flushes).
> 
> can you flush from inside a wq element?  That's the critical part
> that makes the cookie based system easy to program.

Yeah, you can flush individual works from other works and wqs from
works running from different wqs.  What's not allowed is flushing the
wq a work is running on from the work.  Let's say if the flush code
can be modified to do so, would that change your opinion?

Thanks.

-- 
tejun
