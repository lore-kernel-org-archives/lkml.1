Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbXKEIhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbXKEIhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbXKEIgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:36:52 -0500
Received: from rayleigh.systella.fr ([213.41.184.253]:42904 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbXKEIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:36:51 -0500
Message-ID: <472ED613.8050101@systella.fr>
Date: Mon, 05 Nov 2007 09:36:35 +0100
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux sparc64; fr-FR; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan> <18222.16003.92062.970530@notabene.brown>
In-Reply-To: <18222.16003.92062.970530@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Mon, 05 Nov 2007 09:36:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
>> # ps auxww | grep D
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
>>
>> After several days/weeks, this is the second time this has happened, while 
>> doing regular file I/O (decompressing a file), everything on the device 
>> went into D-state.
> 
> At a guess (I haven't looked closely) I'd say it is the bug that was
> meant to be fixed by
> 
> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
> 
> except that patch applied badly and needed to be fixed with
> the following patch (not in git yet).
> These have been sent to stable@ and should be in the queue for 2.6.23.2

	My linux-2.6.23/drivers/md/raid5.c contains your patch for a long time :

...
         spin_lock(&sh->lock);
         clear_bit(STRIPE_HANDLE, &sh->state);
         clear_bit(STRIPE_DELAYED, &sh->state);

         s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
         s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
         s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
         /* Now to look around and see what can be done */

         /* clean-up completed biofill operations */
         if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
                 clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
         }

         rcu_read_lock();
         for (i=disks; i--; ) {
                 mdk_rdev_t *rdev;
                 struct r5dev *dev = &sh->dev[i];
...

but it doesn't fix this bug.

	Regards,

	JKB
