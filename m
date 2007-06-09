Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbXFIUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbXFIUyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXFIUyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:54:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498AbXFIUyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:54:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Jinxed VAIO wreckage - current state of affairs
Date: Sat, 9 Jun 2007 22:59:49 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>
References: <1181418873.4404.402.camel@chaos>
In-Reply-To: <1181418873.4404.402.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706092259.50694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 9 June 2007 21:54, Thomas Gleixner wrote:
> Andrew's jinxed VAIO breaks with the high resolution timer updates in a
> very strange way. Andrew identified the following patch as the culprit:
> 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc4/broken-out/clockevents-fix-resume-logic.patch
> 
> This makes no sense at all. The patch just moves the timer restart to a
> different (later) place in the code and does exactly the same thing as
> the current code does.
> 
> On resume the VAIO is stuck in the following place:
> 
> <Andrews debug session>
> 
> We finish swsusp_save() and a few other functions then we go
> 
>         hibernate
>         ->platform_finish
>           ->acpi_hibernation_finish
>             ->acpi_leave_sleep_state
>               ->acpi_evaluate_object
> 
> and there it dies, in this call:
> 
> status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
> 
> I wonder how your patch caused that?
> 
> <debugs further>
> 
> OK, it gets to the last statement in acpi_evaluate_object():
> 
>         return_ACPI_STATUS(status);
> 
> but doesn't hit the printk on return to the caller,
> acpi_leave_sleep_state().
> 
> </Andrews debug session>
> 
> Some data points:
> 
> This happens only, when the local apic timer is used. With PIT the
> resume works fine.
> 
> I back ported the full high res stuff to 2.6.20. On 2.6.20 the VAIO
> survives that patch.
> 
> Can the suspend/resume and ACPI wizards please give some hint how to
> track this 100% reproducible wreckage down.

Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?

There are a couple of patches in there that might help in theory, this series
in particular:

swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
