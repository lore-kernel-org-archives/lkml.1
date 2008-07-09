Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYGIPkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYGIPkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYGIPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:39:43 -0400
Received: from mail.av.it.pt ([193.136.92.53]:41527 "EHLO av.it.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754248AbYGIPjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:39:42 -0400
Message-ID: <4874DBBF.1000907@av.it.pt>
Date: Wed, 09 Jul 2008 16:39:43 +0100
From: Bruno Santos <bsantos@av.it.pt>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: semaphore: lockless fastpath using atomic_{inc,dec}_return
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 >hi,
 >
 >not to ruin the party but... how is this lockless? An atomic variable
 >is every bit a "lock" as a spinlock is... and very much equally
 >expensive as well for most cases ;-(

Perhaps not the best the choice of words, I should have omitted the word 
lockless. But it seems my understanding of lockless and yours is different.
And indeed, it's very expensive as a spinlock, but comparatively, is 
only one operation, that if successful doesn't have to lock and then 
unlock (that's why I called it lockless ...).
The mutex takes the same approach, however it uses it's own flavour of 
atomic ops. What I'm really interested is if this brings any benefit in 
terms of performance.


 > And is this safe? It seems that we can always be rescheduled after 
the atomic operation and
 > interrupts can occur too. You need to tell us why this is safe in all 
cases.

The slowpaths take care of that:
In 'down' slowpath after acquiring the spinlock the semaphore may have 
been unlocked ("we can always be rescheduled after the atomic operation 
and interrupts can occur too"), so we test again doing an 
atomic_dec_return, like in fastpath case, if it fails we proced to wait 
list and wait loop until someone wake us, if we get 
task_interrupted/timeout we just abandon the wait list.
In 'up' slowpath after acquiring the spinlock we wake up one waiter, 
however the list may be empty because we acquired the lock faster than a 
possible waiter(s) or the waiter(s) abandoned the wait list, in such 
case we atomic_inc the count to value that is >= 1 (taking into account 
another 'up').

