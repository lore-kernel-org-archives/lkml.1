Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYABKxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYABKxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYABKxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:53:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbYABKxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:53:08 -0500
Date: Wed, 2 Jan 2008 11:52:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
	(rev. 2)
Message-ID: <20080102105217.GA14731@elte.hu>
References: <200801020032.45529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801020032.45529.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Hi,
> 
> Some device drivers register CPU hotplug notifiers and use them to 
> destroy device objects when removing the corresponding CPUs and to 
> create these objects when adding the CPUs back.
> 
> Unfortunately, this is not the right thing to do during 
> suspend/hibernation, since in that cases the CPU hotplug notifiers are 
> called after suspending devices and before resuming them, so the 
> operations in question are carried out on the objects representing 
> suspended devices which shouldn't be unregistered behing the PM core's 
> back.  Although right now it usually doesn't lead to any practical 
> complications, it will predictably deadlock if 
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch is 
> applied.
> 
> The solution is to prevent drivers from removing/adding devices from 
> within CPU hotplug notifiers during suspend/hibernation using the 
> FROZEN bit in the notifier's action argument.  However, this has to be 
> done with care, since the devices objects related to the nonboot CPUs 
> that failed to go online during resume should not be present in the 
> system.  For this reason, it seems reasonable to introduce a mechanism 
> allowing drivers to ask the PM core to remove device objects 
> corresponding to suspended devices on their behalf.
> 
> The first patch in the series introduces such a mechanism.  The 
> remaining three patches modify the MSR, x86-64 MCE and cpuid drivers 
> in accordance with the above approach.

btw., it would be really, really cool if there was a scriptable way i 
could test suspend/resume functionality. Pavel has this /dev/rtc thing 
to set up an alarm (not sure how functional it is) - would it be 
possible to have it as a "suspend for 10 seconds then resume" debug 
functionality? That way any suspend breakage would be detectable (and 
bisectable) in automated testing - if the resume does not come back 
after 10-20 seconds then the test failed.

	Ingo
