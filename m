Return-Path: <linux-kernel-owner+w=401wt.eu-S934029AbYBTUhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbYBTUhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764984AbYBTUhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:37:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38330 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759824AbYBTUhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:37:04 -0500
Message-ID: <47BC8F6C.6040403@garzik.org>
Date: Wed, 20 Feb 2008 15:37:00 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] Re: [PATCH 4/12] riscom8: fix SMP brokenness
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223638.DD9FE1F81A8@havoc.gtf.org> <20080207002915.GA27124@elte.hu>
In-Reply-To: <20080207002915.GA27124@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> After analyzing the elements that save_flags/cli/sti/restore_flags 
>> were protecting, convert their usages to a global spinlock (the 
>> easiest and most obvious next-step).  There were some usages of flags 
>> being intentionally cached, because the code already knew the state of 
>> interrupts.  These have been taken into account.
>>
>> This allows us to remove CONFIG_BROKEN_ON_SMP.  Completely untested.
> 
> regression for sale :-) The above patch, after sitting in -mm for 
> approximately 3 months, just went upstream today via commit 
> d9afa43532adf8a31b93c4c7601f and promptly broke tonight's x86.git 
> randconfig qa run via tons of these messages:
> 
> [    3.768431] BUG: scheduling while atomic: swapper/1/0x00000002
> [    3.769430] 1 lock held by swapper/1:
> [    3.770437]  #0:  (riscom_lock){--..}, at: [<80389ceb>] rc_release_drivers+0xe/0x33
> [    3.776430] Pid: 1, comm: swapper Not tainted 2.6.24 #14
> [    3.777428]  [<801167d3>] __schedule_bug+0x6e/0x75
> [    3.779427]  [<80756065>] schedule+0x35c/0x429
> [    3.781427]  [<80103a0b>] ? restore_nocheck+0x12/0x15
> [    3.784427]  [<80103a0b>] ? restore_nocheck+0x12/0x15
> [    3.786426]  [<80756381>] schedule_timeout+0x69/0xa2
> [    3.788426]  [<80758337>] ? _spin_unlock_irq+0x25/0x40
> [    3.790426]  [<80755c0e>] wait_for_common+0x96/0x10d
> [    3.792425]  [<80115edc>] ? default_wake_function+0x0/0xd
> [    3.794425]  [<80755d07>] wait_for_completion+0x12/0x14
> [    3.796425]  [<801282fe>] call_usermodehelper_exec+0x78/0x8c
> [    3.798424]  [<8015a041>] ? slob_alloc+0xd8/0x1ad
> [    3.800424]  [<80301640>] kobject_uevent_env+0x3ae/0x3c5
> [    3.802424]  [<803ac361>] ? dev_uevent+0x0/0x25a
> [    3.804424]  [<80301661>] kobject_uevent+0xa/0xc
> [    3.806423]  [<803acc06>] device_del+0x139/0x15d
> [    3.808423]  [<803acc58>] device_unregister+0x2e/0x3b
> [    3.810423]  [<803acc8e>] device_destroy+0x29/0x2f
> [    3.812422]  [<8035965f>] tty_unregister_device+0x18/0x1a
> [    3.814422]  [<8035970b>] tty_unregister_driver+0xaa/0xf6
> [    3.816422]  [<80389cf7>] rc_release_drivers+0x1a/0x33
> [    3.818421]  [<80ac5e16>] riscom8_init_module+0x4ff/0x539
> [    3.820421]  [<8012e76f>] ? ktime_get_ts+0x44/0x49
> [    3.822421]  [<80aaf701>] kernel_init+0x9a/0x263
> [    3.824421]  [<80ac5917>] ? riscom8_init_module+0x0/0x539
> [    3.827420]  [<80aaf667>] ? kernel_init+0x0/0x263
> [    3.829420]  [<8010455f>] kernel_thread_helper+0x7/0x18
> [    3.831419]  =======================

This is unfortunately very low on the priority stack.  I was a bit 
surprised when it went in, honestly, since I hadn't gotten any "it 
works" test reports yet...  but that's my fault for not keeping akpm up 
to date.

We'll want to revert this for 2.6.25 release, if it doesn't get fixed up.

	Jeff



