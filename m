Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZBPICq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZBPICq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZBPICf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:02:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50196 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZBPICe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:02:34 -0500
Message-ID: <49991D8C.1050705@jp.fujitsu.com>
Date: Mon, 16 Feb 2009 17:02:20 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
References: <m1pri623g9.fsf@fess.ebiederm.org>	<49815BF6.7060402@jp.fujitsu.com>	<200902131129.09523.jbarnes@virtuousgeek.org>	<m11vu1wtk6.fsf@fess.ebiederm.org> <m1ab8p89is.fsf@fess.ebiederm.org> <m11vu183ti.fsf@fess.ebiederm.org>
In-Reply-To: <m11vu183ti.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
> 
>> And on the big gotcha's I have found one more I am tracking.
>>
>> I am seeing pci bridges with a NULL pointer for the subordinate bus.
>> Earlier I had thought that this was a symptom of the double remove
>> but I have been able to reproduce it without that.
>>
>> On just a little bit deeper investigation it looks like the cases
>> are dying are all coming when the nested bridge reappears.
>>
>> Which is wrong on so many levels as I am toggle power to the outer
>> slot, so the nested bridge should not even exist at that time.  Ugh.
>> More tracing to for me on that one.
> 
> Ok. Got it.  I was processing the interrupt for a device after it had
> been hot removed but before the device state had disappeared.
> 
> pcie_isr looks like it would be even worse in that situation.  Looping forever
> if pciehp_readw(ctrl, PCIE_EXPSLTA) always succeed sand returns 0xffff.
> 
> That loop in there appears impossibly misguided.  If the pending interrupt
> values change after you have received the interrupt another instance
> of the same interrupt should be pending so the loop should be completely
> unnecessary.
> 

For level-triggered interrupt, I think it's true.

But for edge-triggered interrupt, I don't think it's true. I think
only one interrupt is generated if the first hotplug event occurs
and the second hotplug event occurs before clearing the status of
first hotplug event.

Thanks,
Kenji Kaneshige


