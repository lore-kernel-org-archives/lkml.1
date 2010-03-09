Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0CIXAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:00:25 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:48035 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648Ab0CIXAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:00:24 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 18:00:23 EST
Message-ID: <4B96D055.90201@metafoo.de>
Date: Tue, 09 Mar 2010 23:48:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Valdis.Kletnieks@vt.edu, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot
 and handle_level_irq
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>            <alpine.LFD.2.00.1003090855250.22855@localhost.localdomain> <5309.1268153945@localhost> <alpine.LFD.2.00.1003091907500.22855@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003091907500.22855@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thomas Gleixner wrote:
> On Tue, 9 Mar 2010, Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 09 Mar 2010 08:58:11 +0100, Thomas Gleixner said:
>>> On Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
>>>
>>>> If the kernel has been compiled with preemtion support and
handle_level_irq is
>>>> called from process context for a oneshot irq there is a race between
>>>> irq_finalize_oneshot and handle_level_irq which results in the irq
not being
>>>> unmasked after its handlers have been run.
>>>>
>>>> irq_finalize_oneshot is expected to unmask the irq after the
threaded irq
>>>> handler has been run. It only does so if IRQ_MASKED is set for the
irqs status.
>>>> IRQ_MASKED gets set in the lower part of handle_level_irq after
handle_IRQ_event
>>>> has been called.
>>>> handle_IRQ_event will wakeup the oneshot irqs threaded handler and
if the
>>>> kernel has been build with preemption there is a chance that the
threaded irq
>>>> handler will finish before execution is returned to handle_level_irq.
>>>> As a result irq_finalize_oneshot will not unmask the irq and
handle_level_irq
>>>> will set the IRQ_MASKED flag. Thus the irq will stay masked and stalls.
>>>>
>>>> In case of an race the call-graph would look like this:
>>>>  handle_level_irq
>>>>  |- mask_ack_irq
>>>>  |- handle_IRQ_event
>>>>     |- wake_up_process
>>>>        |- irq_thread
>>>>           |- action->thread_fn
>>>>           |- irq_finalize_oneshot # Does not unmask the irq
>>>> |- # Set IRQ_MASKED status flag
>>> Errm, a thread _CANNOT_ preempt a hard interrupt handler.
>> What stops the thread from concurrently running on another CPU and racing
>> that way?  I'm an idiot, use small words. :)
>
> Right it's a valid SMP problem, but I got confused by the lengthy
> explanation of a thread preempting an hard interrupt handler. :)
Yes, sorry for bothering you with that. I actually had the symptoms
described on a non SMP system. The irq in question was part of a
longer irq chain and I though that it might be detached from the
hardirq context somewhere along the chain.
After your comment I reread some parts and it turned out that
irq_enter()/irq_exit() was missing around the first level irq handler.

- - Lars
>
> Will have a look after dinner.
>
> Thanks,
>
>     tglx
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuW0FUACgkQBX4mSR26RiOiSgCfUJJM6i8rEoiifuY5LwoOaJnA
kfAAnjHh5us4m8NgPEV2wYkyIPh7zzly
=R/J/
-----END PGP SIGNATURE-----

