Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYFYOhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYFYOhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbYFYOgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:36:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbYFYOgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:36:17 -0400
Date: Wed, 25 Jun 2008 10:36:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [3/10 PATCH] inline wake_up_bit
In-Reply-To: <200806251617.40871.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0806251031330.7542@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240156230.27784@engineering.redhat.com>
 <200806251617.40871.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, Denys Vlasenko wrote:

> On Tuesday 24 June 2008 07:57, Mikulas Patocka wrote:
>> Inline wake_up_bit. The function just pases arguments around.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
>>   int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
>> -void wake_up_bit(void *, int);
>>   int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
>
>> +static __always_inline void wake_up_bit(void *word, int bit)
>> +{
>> +	__wake_up_bit(bit_waitqueue(word, bit), word, bit);
>> +}
>
> So now every call to wake_up_bit(word, bit) now is converted to:
>
> __wake_up_bit(bit_waitqueue(word, bit), word, bit);
>
> which is in turn converted to (looking into your next patch):
>
> {
>       wait_queue_head_t *wq = bit_waitqueue(word, bit);
>       struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
>       if (waitqueue_active(wq))
>               __wake_up(wq, TASK_NORMAL, 1, &key);
> }
>
> which is in turn converted to (looking into your other patch):
>
> {
>       wait_queue_head_t *wq = bit_waitqueue(word, bit);
>       struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
>       if (waitqueue_active(wq))
>               {
>                      unsigned long flags;
>                      spin_lock_irqsave(&qw->lock, flags);
>                      __wake_up_common(wq, TASK_NORMAL, 1, 0, &key);
>                      spin_unlock_irqrestore(&wq->lock, flags);
>               }
> }
>
> And you know what? This is likely not the end yet! It's possible
> spin_lock_irqXXX, __wake_up_common, waitqueue_active or bit_waitqueue
> are inlines - I didn't check.
> --
> vda

Yes, that's 0.2% code size increase (or none increase, if drop 
inline-__wake_up_bit.patch and apply only the other patches). To me it 
seems crazy, how this code was refactored again and again over time, up to 
8 levels of functions (including passing a pointer to a method). In 2.0.x 
kernel series, it was just a single call to wake up a queue.

Mikulas
