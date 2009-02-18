Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZBRFtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZBRFtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 00:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZBRFs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 00:48:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47087 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZBRFsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:48:55 -0500
Message-ID: <499BA141.2090403@jp.fujitsu.com>
Date: Wed, 18 Feb 2009 14:48:49 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
References: <m1pri623g9.fsf@fess.ebiederm.org>	<49815BF6.7060402@jp.fujitsu.com>	<200902131129.09523.jbarnes@virtuousgeek.org>	<m11vu1wtk6.fsf@fess.ebiederm.org> <m1ab8p89is.fsf@fess.ebiederm.org>	<m11vu183ti.fsf@fess.ebiederm.org> <49991D8C.1050705@jp.fujitsu.com> <m1y6w4u001.fsf@fess.ebiederm.org>
In-Reply-To: <m1y6w4u001.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:
> 
>> Eric W. Biederman wrote:
>>> ebiederm@xmission.com (Eric W. Biederman) writes:
>>>
>>>> And on the big gotcha's I have found one more I am tracking.
>>>>
>>>> I am seeing pci bridges with a NULL pointer for the subordinate bus.
>>>> Earlier I had thought that this was a symptom of the double remove
>>>> but I have been able to reproduce it without that.
>>>>
>>>> On just a little bit deeper investigation it looks like the cases
>>>> are dying are all coming when the nested bridge reappears.
>>>>
>>>> Which is wrong on so many levels as I am toggle power to the outer
>>>> slot, so the nested bridge should not even exist at that time.  Ugh.
>>>> More tracing to for me on that one.
>>> Ok. Got it.  I was processing the interrupt for a device after it had
>>> been hot removed but before the device state had disappeared.
>>>
>>> pcie_isr looks like it would be even worse in that situation.  Looping forever
>>> if pciehp_readw(ctrl, PCIE_EXPSLTA) always succeed sand returns 0xffff.
>>>
>>> That loop in there appears impossibly misguided.  If the pending interrupt
>>> values change after you have received the interrupt another instance
>>> of the same interrupt should be pending so the loop should be completely
>>> unnecessary.
>>>
>> For level-triggered interrupt, I think it's true.
>>
>> But for edge-triggered interrupt, I don't think it's true. I think
>> only one interrupt is generated if the first hotplug event occurs
>> and the second hotplug event occurs before clearing the status of
>> first hotplug event.
> 
> My test case is edge-triggered MSI's.  The issue is that I get an interrupt
> from the card that I am unplugging, but by the time the interrupt handler
> is executed the card is physically absent, but the pci_dev structure is
> still present in the kernel.
> 

Ok, I understood what is happening. Could you try the following patch?
It is currently in Jesse's linux-next.

http://marc.info/?l=linux-pci&m=123364118418484&w=2

BTW, I don't think surprise removal is well tested.

Thanks,
Kenji Kaneshige


