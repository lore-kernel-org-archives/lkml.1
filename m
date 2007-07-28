Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbXG1Q4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbXG1Q4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXG1Q4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:56:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56108 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXG1Q4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:56:04 -0400
Date: Sat, 28 Jul 2007 09:55:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for
 2.6.23-rc1)
In-Reply-To: <alpine.LFD.0.999.0707280921150.3442@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707280932470.3442@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707262248.09187.rjw@sisk.pl>
 <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
 <200707280330.26991.lenb@kernel.org>
 <alpine.LFD.0.999.0707280921150.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Linus Torvalds wrote:
> 
> And it's the *top*level* code that selects HOTPLUG_CPU. Through 
> SUSPEND_SMP (which will select HOTPLUG_CPU) and SOFTWARE_SUSPEND.

In other words, the problem seems to be that 

	kernel/power/main.c:
		suspend_devices_and_enter()

does the proper "disable/enable_nonboot_cpus()", but it does so without 
having enabled CPU hotplug.

And you seem to think that it's ACPI that should enable the hotplug, even 
though the code that actually needs it is _outside_ ACPI. And I think 
that's wrong, and that this is a bug.

So I think the real issue is that we allow that 
"suspend_devices_and_enter()" code to be compiled without HOTPLUG_CPU in 
the first place. It's not supposed to work that way.

Of course, it may well be that other architectures can happily suspend 
even with multiple CPU's active, which may be the cause of this mess. But 
I really think it shouldn't be ACPI that has to select the CPU hotplug, 
since it's not ACPI that _uses_ it in the first place.

Rafael: making a config option for STR (the same way we have a config 
option for hibernate), and just not allowing it on SMP without HOTPLUG_CPU 
seems to be the right thing. Len is right in that we do insane things 
right now (trying to STR with multiple CPU's still active), and I just 
don't think he's the one that should work around it!

		Linus
