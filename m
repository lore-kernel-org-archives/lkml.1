Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZBRAkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZBRAkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZBRAj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:39:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58857 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZBRAj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:39:58 -0500
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org>
	<49815BF6.7060402@jp.fujitsu.com>
	<200902131129.09523.jbarnes@virtuousgeek.org>
	<m11vu1wtk6.fsf@fess.ebiederm.org> <49991D3A.7090001@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Feb 2009 16:40:14 -0800
In-Reply-To: <49991D3A.7090001@jp.fujitsu.com> (Kenji Kaneshige's message of "Mon\, 16 Feb 2009 17\:00\:58 +0900")
Message-ID: <m1mycktw5t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kaneshige.kenji@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:

> Eric W. Biederman wrote:
>> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>> 
>>> Any update here, Eric?  Sounds like you're using hotplug in real environments
>>> with complex topologies (based on your earlier messages), so we're interested
>>> in what you're seeing here...
>> 
>> Yes.
>> 
>> Currently I have a test system that is a subset of what I'm worried
>> about and will shortly have the real hardware, so my immediate goal is
>> to get things working well enough so my internal users won't get
>> blocked by bugs.  Currently I only have the pcie hotplug and pcie
>> hotplug surprise case.  My basic topology is 16 hotplug slots into
>> which I will be plugging in pci express switches with a couple of
>> additional hotplug slots.  As for the firmware, I will have it reserving
>> bus numbers and mmio space on each of the first 16 slots and the rest
>> is going to be up to the linux kernel.  This is an embedded design
>> so no ACPI is appears more pain than it is worth to implement.
>> 
>
> Very interesting. Can I ask you some questions?
>
> - On hot-insertion of pci express switches with a additional hotplug
>   slots, who initialize HwInit registers (for example, physical slot
>   number field in the Slot Capabilities register)? OS, firmware,
>   hardware or others?

It happens before the linux kernel gets to see it.  Call it firmware.

> - Bus numbers and MMIO space that needs to be reserved is depending
>   on platform design. How do you tell kernel (or hotplug drivers) how
>   many resources need to be reserved, in your current design?

So far it looks like I can get away without telling the kernel
anything, and just perform reservations at the layer of the
firmware on the primary board, and have the kernel see those
reservations when it boots up, and just subdivide them.

I have some thoughts on how to do things better but I'm not at a point
where it makes a difference right now.


>> I need to revisit the pciehp driver but my first pass through it
>> looked like every corner case appeared to get something wrong. So I
>> have written myself a little 430 line replaces that handles the case
>> that I currently care about.  Part of what I was seeing before is that
>> we don't clear pending events in the pciehp driver before we enable
>> interrupts.  So if booting the system has left some pending and you
>> have CONFIG_DEBUG_SHIRQ enabled you get a nice oops because p_slot has
>> not been initialized and so the interrupts can't be handled.
>> 
>
> I've made a fix (c4635eb06af700820d658a163f06aff12e17cfb2) for a similar
> problem several months ago. With this fix, pciehp had been changed to
> initialize p_slot before installing interrupt service routine. So I still
> don't understand what is happening. Could you please tell me the details
> about "p_slot has not been initialized..."?

kobject_name is not initialized, and slot_name(p_slot) calls
hoptlug_slot_name which calls pci_slot_name which kobj_name. 
It looks like this problem was introduced in commit 
e1acb24f059defdaa0264e925f19cc21b0a3e592

Eric
