Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYJGURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYJGURW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYJGURE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:17:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYJGURB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:17:01 -0400
Date: Tue, 7 Oct 2008 22:16:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, tglx@tglx.de,
       "Theodore Ts'o" <tytso@mit.edu>, linux-ide@vger.kernel.org
Subject: Re: Top kernel oopses/warnings for the week of October 7th, 2008
Message-ID: <20081007201617.GA20655@elte.hu>
References: <48EBBE15.9030905@linux.intel.com> <200810072213.16103.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810072213.16103.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Rank 9: device_pm_add (warning)
> > 	Reported 81 times (323 total reports)
> > 	Drivers with suspect suspend/resume logic; a patch is queued for 2.6.28 to identify
> > 	which drivers are involved.
> > 	This warning was last seen in version 2.6.27-rc4, and first seen in 2.6.26-rc5.
> > 	More info: http://www.kerneloops.org/searchweek.php?search=device_pm_add
> 
> This should have been fixed by:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f5a6d958b5d0a10e7e7a9dee1862fb31d08c6d26

hm, that is:

| From f5a6d958b5d0a10e7e7a9dee1862fb31d08c6d26 Mon Sep 17 00:00:00 2001
| From: Rafael J. Wysocki <rjw@sisk.pl>
| Date: Sat, 9 Aug 2008 01:05:13 +0200
| Subject: [PATCH] PM: Remove WARN_ON from device_pm_add
|
| PM: Remove WARN_ON from device_pm_add
|
| Fix message in device_pm_add() saying that the device will not be
| added to dpm_list, although in fact the device is going to be added
| to the list regardless of the ordering violation.
|
| Remove the WARN_ON(true) triggered in that situation, because it is
| hit by USB very often and spams the users' logs.
|
| This patch fixes bug #11263

+               if (dev->parent->power.status >= DPM_SUSPENDING)
+                       dev_warn(dev, "parent %s should not be sleeping\n",
                                dev->parent->bus_id);
-                       WARN_ON(true);
-               }


i.e. no bug was fixed in reality - we still emit a kernel log entry, but 
the WARN_ON() was removed, so that it does not fall under the scope of 
kerneloops.org, right?

	Ingo
