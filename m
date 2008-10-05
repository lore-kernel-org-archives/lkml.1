Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYJEU26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYJEU26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 16:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYJEU2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 16:28:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53288 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYJEU2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:28:49 -0400
Message-ID: <48E92378.8050309@firstfloor.org>
Date: Sun, 05 Oct 2008 22:28:40 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional	hotplug
 CPUs to be set at compile time
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org> <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu> <alpine.LFD.2.00.0810051626150.3398@apollo> <20081005152025.GA27066@elte.hu>
In-Reply-To: <20081005152025.GA27066@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>> Btw, additional_cpus has interesting properties. Providing a negative 
>> number < -1 on the kernel command line - happened due to a typo - 
>> explodes in early boot, which is not really surprising, but should be 
>> sanity checked.
> 
> indeed, and that mess was introduced, interestingly, by this commit, 
> three years ago, by Andi:

What mess do you mean? That not all parameters are 100% sanity checked?
"Unix gives you enough rope to shot yourself into the foot."
Normally people who set kernel parameters are expected to know what
they are doing. That said the parameter should probably use some
unsigned form of get_option, but unfortunately there isn't any.

But if you describe any kernel parameter that isn't 100% sanity
checked as mess I'm afraid there won't be many non messy parameters
left.

> | From 420f8f68c9c5148dddf946bebdbc7eacde2172cb Mon Sep 17 00:00:00 2001
> | From: Andi Kleen <ak@suse.de>
> | Date: Sat, 5 Nov 2005 17:25:54 +0100
> | Subject: [PATCH] [PATCH] x86_64: New heuristics to find out hotpluggable CPUs.
> 
> so to clean up the mess i've removed the additional_cpus= boot parameter 
> and the Kconfig entry as well - see the patch in x86/core below.

This also breaks real CPU hotplug on systems that do not follow
the Documentation/x86/x86_64/cpu-hotplug-spec specification.

This extension is not part of the standard ACPI spec (I invented it),
so I don't think everyone requiring to follow such a Linux specific extension
is a good idea. I tried to lobby a few vendors to follow this
extension, but I doubt I was 100% successfull.

So please readd the boot parameter.

Or if you don't chose it at least modify the document clearly
stating that all CPU hotplug requires a non ACPI standard extension now
and that the users is screwed if their vendor doesn't follow it.

But it would be better to keep the parameter as a fallback.

> and no way can any of this go into v2.6.27: this is fragile code with a 
> lot of historic baggage

In my experience CPU discovery in ACPI/mptables isn't particularly fragile.
alternatives can be, but this patch doesn't affect its basic operation.

> and the original error is non-fatal to begin 
> with. 

That is true, it's just a performance issue especially on systems
with slow LOCK prefix (like P4s) which commonly have the bogus extra
CPU in the BIOS tables when they don't support HT directly.

-Andi
