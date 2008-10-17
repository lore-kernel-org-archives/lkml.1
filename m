Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYJQVu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYJQVu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYJQVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:50:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:2579 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYJQVuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:50:50 -0400
Message-ID: <13c67e2c0810171450t4001a9c8h594d42bab83a7426@mail.gmail.com>
Date: Fri, 17 Oct 2008 14:50:49 -0700
From: "Ani Sinha" <kernel@anirban.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: panic() logic
Cc: kernel@anirban.org
In-Reply-To: <13c67e2c0810171448o6858827ei1ccc9e0ddf487f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <13c67e2c0810171448o6858827ei1ccc9e0ddf487f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:

I noticed an issue with the panic() firing on a back core in SMP
lately. We are mostly working on mips architectures but it might
effect other archs as well. Therefore, I am putting forward my
thoughts and comments to the whole linux community. In the following,
by front core I mean core#0 and by back core I mean other cores.

The panic() call does a smp_send_stop() pretty early in the call
process. There is an issue with this:

smp_send_stop basically marks all the other cores as 'down' and
updates the cpu bitmap. One implication of this is that you can not do
an IPI later on to other cores (smp_send_function() does a
'for_earch_online_cpu'). This makes sense since you should not be
allowed to do anything on a down cpu. But what if a particular
architecture had logic to do specific things for the front core and
other things on the back cores as a part of 'graceful reboot' process?
For example, the arch dependent emergency_restart() might try to do
send IPI to the front core to do a graceful reboot and simply place
the others on an infinite loop? As a concrete example, mips sibyte
processor has logic in arch dependent restart code to call cfe_exit()
on front core and an infinite loop on the back cores. It does this
through an IPI which obviously does not succeed because of the early
smp_send_stop().

So, my proposal is, can we just run panic on the front core and put
the back cores in loop right away. I mean, can we do this in pseudo
code?

panic()
{

/* do stuff that must be done on the current core */
   on_each_cpu(continue_panic, ...);
   return;
}

continue_panic()
{
 if (!smp_processor_id()) {
       smp_send_stop();
       /* rest of existing panic() logic */
 }else
   for(;;)
}

Is this going to be okay for all archs?

Cheers!

Ani
