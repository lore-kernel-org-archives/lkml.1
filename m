Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXKGQkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXKGQkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXKGQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:39:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXKGQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:39:49 -0500
Message-ID: <4731EA2B.5000806@redhat.com>
Date: Wed, 07 Nov 2007 11:39:07 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
CC: Neil Brown <neilb@suse.de>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan> <18222.16003.92062.970530@notabene.brown> <472ED613.8050101@systella.fr>
In-Reply-To: <472ED613.8050101@systella.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2007 03:36 AM, BERTRAND Joël wrote:
> Neil Brown wrote:
>> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
>>> # ps auxww | grep D
>>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40
>>> [pdflush]
>>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00
>>> [pdflush]
>>>
>>> After several days/weeks, this is the second time this has happened,
>>> while doing regular file I/O (decompressing a file), everything on
>>> the device went into D-state.
>>
>> At a guess (I haven't looked closely) I'd say it is the bug that was
>> meant to be fixed by
>>
>> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
>>
>> except that patch applied badly and needed to be fixed with
>> the following patch (not in git yet).
>> These have been sent to stable@ and should be in the queue for 2.6.23.2
> 
>     My linux-2.6.23/drivers/md/raid5.c contains your patch for a long
> time :
> 
> ...
>         spin_lock(&sh->lock);
>         clear_bit(STRIPE_HANDLE, &sh->state);
>         clear_bit(STRIPE_DELAYED, &sh->state);
> 
>         s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
>         s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
>         s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
>         /* Now to look around and see what can be done */
> 
>         /* clean-up completed biofill operations */
>         if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
>                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
>         }
> 
>         rcu_read_lock();
>         for (i=disks; i--; ) {
>                 mdk_rdev_t *rdev;
>                 struct r5dev *dev = &sh->dev[i];
> ...
> 
> but it doesn't fix this bug.
> 

Did that chunk starting with "clean-up completed biofill operations" end
up where it belongs? The patch with the big context moves it to a different
place from where the original one puts it when applied to 2.6.23...

Lately I've seen several problems where the context isn't enough to make
a patch apply properly when some offsets have changed. In some cases a
patch won't apply at all because two nearly-identical areas are being
changed and the first chunk gets applied where the second one should,
leaving nowhere for the second chunk to apply.

