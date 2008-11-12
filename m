Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYKLS4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYKLS4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYKLS4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:56:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbYKLS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:56:40 -0500
Date: Wed, 12 Nov 2008 10:56:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>, Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "lenb@kernel.org" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [Linux 2.6.28-rc4] BUG: using smp_processor_id() in preemptible
 [00000000] code: suspend_to_disk/2934
In-Reply-To: <8db1092f0811121030t1977b3bbu8340b582694d1e65@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811121046360.3468@nehalem.linux-foundation.org>
References: <8db1092f0811121030t1977b3bbu8340b582694d1e65@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Nov 2008, Maciej Rutecki wrote:

> -rc3 works OK
> 
> I have this bug during suspend to disk:
> 
> [  188.592151] Enabling non-boot CPUs ...
> [  188.592151] SMP alternatives: switching to SMP code
> [  188.666058] BUG: using smp_processor_id() in preemptible [00000000]
> code: suspend_to_disk/2934
> [  188.666064] caller is native_sched_clock+0x2b/0x80

The cause seems to be commit 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5, 
"sched: optimize sched_clock() a bit" by Ingo.

Which actually comments on the fact that a few callers may need to be 
updated. That wasn't good. Ingo - it's not acceptable for a latish-rc 
patch to introduce _known_ bugs and not fixing everything up.

Of course, since Maciej has frame pointers disabled, the stack trace isn't 
entirely reliable, but it looks like the problem is "init_idle()".

That thing needs to call sched_clock() with interrupts disabled. Looking 
at it, I'd also expect that it should have used "sched_clock_cpu()", but 
I'm leaving that to Ingo to sort out. Ingo?

		Linus
