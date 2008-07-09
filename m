Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYGIQ4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYGIQ4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYGIQ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:56:22 -0400
Received: from mail.av.it.pt ([193.136.92.53]:48087 "EHLO av.it.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755195AbYGIQ4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:56:21 -0400
Message-ID: <4874EDB5.7030007@av.it.pt>
Date: Wed, 09 Jul 2008 17:56:21 +0100
From: Bruno Santos <bsantos@av.it.pt>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: semaphore: lockless fastpath using atomic_{inc,dec}_return
References: <4874DBBF.1000907@av.it.pt> <20080709085018.3a76d1e0@infradead.org>
In-Reply-To: <20080709085018.3a76d1e0@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 09 Jul 2008 16:39:43 +0100
> Bruno Santos <bsantos@av.it.pt> wrote:
>
>   
>> Hi,
>>
>>  >hi,
>>  >
>>  >not to ruin the party but... how is this lockless? An atomic
>>  >variable is every bit a "lock" as a spinlock is... and very much
>>  >equally expensive as well for most cases ;-(
>>
>> Perhaps not the best the choice of words, I should have omitted the
>> word lockless. But it seems my understanding of lockless and yours is
>> different. And indeed, it's very expensive as a spinlock, but
>> comparatively, is only one operation, that if successful doesn't have
>> to lock and then unlock (that's why I called it lockless ...).
>>     
>
> ok I only come from an Intel/x86 background, where unlock is basically
> free, and the "lock" is exactly the same cost as an atomic op.
> (in fact, an atomic op and a lock are the exact same code.. you're just
> open coding it)
>   
 From your words if we do:

spin_lock()
val = --foo;
spin_unlock();

Has the same cost than:

val = atomic_dec_return(&foo);

?

>   
>> The mutex takes the same approach, however it uses it's own flavour
>> of atomic ops. What I'm really interested is if this brings any
>> benefit in terms of performance.
>>     
>
> on x86... I would highly doubt it since you have the same number of
> atomic operations. (it's not the lock that is expensive. ever. it's
> always the fact that a lock implies an atomic operation that makes it
> expensive)
>
>   

How come I have the same number of atomic ops?

Let's consider the fast case scenario (semaphore is unlocked for the 
'down' and has no waiters for 'up') in x86:
- with the spinlock only approach we have 2 atomic ops, xadd for lock, 
inc for unlock. The unlock doesn't come for free in x86 after all.
- with the approach I presented we have 1 atomic op (xadd or it could be 
inc/dec if optimized)

If go the slow path things get more expensive than the spinlock only 
approach: we have to lock, do some atomic ops for correctness, and unlock.

