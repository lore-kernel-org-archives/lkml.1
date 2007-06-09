Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbXFITyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbXFITyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbXFITyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:54:37 -0400
Received: from www.osadl.org ([213.239.205.134]:49476 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758258AbXFITyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:54:37 -0400
Subject: Jinxed VAIO wreckage - current state of affairs
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 21:54:33 +0200
Message-Id: <1181418873.4404.402.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew's jinxed VAIO breaks with the high resolution timer updates in a
very strange way. Andrew identified the following patch as the culprit:

http://www.tglx.de/projects/hrtimers/2.6.22-rc4/broken-out/clockevents-fix-resume-logic.patch

This makes no sense at all. The patch just moves the timer restart to a
different (later) place in the code and does exactly the same thing as
the current code does.

On resume the VAIO is stuck in the following place:

<Andrews debug session>

We finish swsusp_save() and a few other functions then we go

        hibernate
        ->platform_finish
          ->acpi_hibernation_finish
            ->acpi_leave_sleep_state
              ->acpi_evaluate_object

and there it dies, in this call:

status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);

I wonder how your patch caused that?

<debugs further>

OK, it gets to the last statement in acpi_evaluate_object():

        return_ACPI_STATUS(status);

but doesn't hit the printk on return to the caller,
acpi_leave_sleep_state().

</Andrews debug session>

Some data points:

This happens only, when the local apic timer is used. With PIT the
resume works fine.

I back ported the full high res stuff to 2.6.20. On 2.6.20 the VAIO
survives that patch.

Can the suspend/resume and ACPI wizards please give some hint how to
track this 100% reproducible wreckage down.

Thanks,

	tglx


