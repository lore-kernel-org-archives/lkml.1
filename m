Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYIASnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYIASnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYIASnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 14:43:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYIASnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 14:43:09 -0400
Date: Mon, 1 Sep 2008 11:42:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alok Kataria <akataria@vmware.com>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <48BC2A03.9000104@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0809011136340.12958@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Sep 2008, Larry Finger wrote:
>
> TSC calibrated against PIT
> Detected 428.823 MHz processor.

Ok, Thomas, that means that the PIT is reliable (not surprising), and the 
PM_TIMER isn't (again, I'm not horribly surprised). And HPET isn't 
available, of course.

The old x86-32 code never even bothered with the PM_TIMER for calibration. 
I don't understand why the x86-64 code bothers with it either. Why not 
just drop that whole broken thing, and just depend on the PIT if there is 
no HPET?

I would also like to point out that the 32-bit code actually had a much 
nicer PIT setup, using the much better documented mach_prepare_counter() 
and mach_countup() helper functions. I'm unhappy to note that the new 
"common" code uses what appears to be the inferior code.

Also, note that this is _not_ a new issue. See "verify_pmtmr_rate()" in 
drivers/clocksource/acpi_pm.c, along with all the code to check that the 
reads are stable in "init_acpi_pm_clocksource()".

IOW, the PM_TIMER has been found to be broken before. Depending on it for 
calibration is broken.

			Linus
