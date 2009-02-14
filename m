Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZBNEGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZBNEGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 23:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZBNEGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 23:06:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48759 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZBNEGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 23:06:44 -0500
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org>
	<49815BF6.7060402@jp.fujitsu.com>
	<200902131129.09523.jbarnes@virtuousgeek.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 13 Feb 2009 20:06:49 -0800
In-Reply-To: <200902131129.09523.jbarnes@virtuousgeek.org> (Jesse Barnes's message of "Fri\, 13 Feb 2009 11\:29\:08 -0800")
Message-ID: <m11vu1wtk6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesse Barnes <jbarnes@virtuousgeek.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> Any update here, Eric?  Sounds like you're using hotplug in real environments 
> with complex topologies (based on your earlier messages), so we're interested 
> in what you're seeing here...

Yes.

Currently I have a test system that is a subset of what I'm worried
about and will shortly have the real hardware, so my immediate goal is
to get things working well enough so my internal users won't get
blocked by bugs.  Currently I only have the pcie hotplug and pcie
hotplug surprise case.  My basic topology is 16 hotplug slots into
which I will be plugging in pci express switches with a couple of
additional hotplug slots.  As for the firmware, I will have it reserving
bus numbers and mmio space on each of the first 16 slots and the rest
is going to be up to the linux kernel.  This is an embedded design
so no ACPI is appears more pain than it is worth to implement.

I am also looking at the case of pcie switches with two upstream
ports, and switching which cpu they are connected to at runtime.  So
in some cases I will have devices whose presence is detected but will
not get link for hours or days, as opposed to the 20ms time limit in
the pci express specification.  Call it a necessary extension.

I need to revisit the pciehp driver but my first pass through it
looked like every corner case appeared to get something wrong. So I
have written myself a little 430 line replaces that handles the case
that I currently care about.  Part of what I was seeing before is that
we don't clear pending events in the pciehp driver before we enable
interrupts.  So if booting the system has left some pending and you
have CONFIG_DEBUG_SHIRQ enabled you get a nice oops because p_slot has
not been initialized and so the interrupts can't be handled.

My little driver is at least good enough to let me start looking at
other things.  I have just found yesterday that if you mmap a resource
in sysfs hot-remove doesn't complete.  Sysfs issues seem to be the
bane of my existence and I am currently working on a patch for that.

Currently the pcie port driver calls the remove methods of child
drivers twice if it removed (say because you have hot unplugged a
bridge).  Which is one of the truly nasty bugs I saw when I was trying
to bring up my test system, as things start access freed memory and
all kinds of silly things happen.

After I get the worst of the problems handled I intend to do a
thorough review and fix everything that I can see.

Eric
