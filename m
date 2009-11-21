Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZKVAAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZKVAAH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 19:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZKVAAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 19:00:06 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:48174 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbZKVAAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 19:00:04 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911141952.50030.rjw@sisk.pl>
	<87r5rwrkqs.fsf@tac.ki.iif.hu> <200911182313.14092.rjw@sisk.pl>
Date: Sun, 22 Nov 2009 00:59:46 +0100
In-Reply-To: Ferenc Wagner's message of "Wed\, 18 Nov 2009 23\:55\:01 +0100"
Message-ID: <87skc7mnt9.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
>> On Wednesday 18 November 2009, Ferenc Wagner wrote:
>>
>>> Ferenc Wagner <wferi@niif.hu> writes:
>>> 
>>>> Since I've instrumented s2disk and the hibernation path, no freeze
>>>> happened during hibernating the machine.
>>> 
>>> Not until I removed the delays from hibernation_platform_enter(), which
>>> were put there previously to get step-by-step feedback.  Removing them
>>> again resulted in a freeze in short course, maybe just two hibernations
>>> later.  The instrumentation shows it stuck in dpm_suspend_start(PMSG_HIBERNATE).
>>> Does it mean that some device driver is at fault?
>>
>> A driver or one of the platform hooks.

This result (the freeze happens in dpm_suspend_start) may not stand
anymore: the parport_pc module was loaded and this falsified my results.
That is, after suspending that device, the parport feedback ceased
working, outbs becoming ineffective.

>>> I'll check if it always fails at the same point (although tracing into
>>> dpm_suspend_start isn't pure fun because of the multitude of devices it
>>> loops over).  Is there any way to get printk output from that phase?
>>
>> Compile with CONFIG_PM_VERBOSE (it does mean exactly that).
>
> I've been running with CONFIG_PM_VERBOSE=y for a good while, but that
> didn't help getting for example the result of the following printks to
> the VGA console (0x3bc is the parallel port):
>
> @@ -445,34 +446,66 @@ int hibernation_platform_enter(void)
>          * hibernation_ops->finish() before saving the image, so we should let
>          * the firmware know that we're going to enter the sleep state after all
>          */
> +       printk ("hibernation_ops->begin()...\n");
> +       outb(16, 0x3bc);
>         error = hibernation_ops->begin();
> +       outb(17, 0x3bc);
> +       printk ("hibernation_ops->begin(): %d\n", error);
>         if (error)
>                 goto Close;

The problem was the very low (1) default suspend loglevel.  After
raising it, the incriminated messages (and lots of other stuff)
appeared.

> However, my dmesg is full of lines like
>
> agpgart-intel 0000:00:00.0: preparing freeze
> pci 0000:00:00.1: preparing freeze
> pci 0000:00:00.3: preparing freeze
>
> etc., I'll check it they are the same all the time.  Anyway, the above
> printk strings aren't present in dmesg after a successful resume even,
> so I must be doing something wrong...

These printks of mine are clearly out of scope of dmesg, because they
don't happen in the context of the resumed system.  I think I'm starting
to understand...

>>> Side question: If I run s2disk from the init=/bin/bash prompt, the
>>> instrumentation in acpi_enter_sleep_state_prep in drivers/acpi/acpica/hwsleep.c
>>> fires before the "Snapshotting system" phase, but it does not fire if I
>>> hibernate from the full running desktop.  (That instrumentation was put
>>> there to investigate the KMS-triggered STR freeze.)  What could explain
>>> this?
>>
>> It looks like it uses the "shutdown" method when run with init=/bin/bash, but
>> I don't know why exactly.
>
> Thanks for the tip, I'll check this too.

Looks like this was the effect of portport_pc being loaded when I run
s2disk from the desktop, but not when I started it after init=/bin/bash.
-- 
Regards,
Feri.
