Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZBQXRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZBQXRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZBQXRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:17:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48185 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZBQXRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:17:03 -0500
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org>
	<49815BF6.7060402@jp.fujitsu.com>
	<200902131129.09523.jbarnes@virtuousgeek.org>
	<m11vu1wtk6.fsf@fess.ebiederm.org> <m1ab8p89is.fsf@fess.ebiederm.org>
	<m11vu183ti.fsf@fess.ebiederm.org> <49991D8C.1050705@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Feb 2009 15:17:18 -0800
In-Reply-To: <49991D8C.1050705@jp.fujitsu.com> (Kenji Kaneshige's message of "Mon\, 16 Feb 2009 17\:02\:20 +0900")
Message-ID: <m1y6w4u001.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kaneshige.kenji@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0950]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:

> Eric W. Biederman wrote:
>> ebiederm@xmission.com (Eric W. Biederman) writes:
>> 
>>> And on the big gotcha's I have found one more I am tracking.
>>>
>>> I am seeing pci bridges with a NULL pointer for the subordinate bus.
>>> Earlier I had thought that this was a symptom of the double remove
>>> but I have been able to reproduce it without that.
>>>
>>> On just a little bit deeper investigation it looks like the cases
>>> are dying are all coming when the nested bridge reappears.
>>>
>>> Which is wrong on so many levels as I am toggle power to the outer
>>> slot, so the nested bridge should not even exist at that time.  Ugh.
>>> More tracing to for me on that one.
>> 
>> Ok. Got it.  I was processing the interrupt for a device after it had
>> been hot removed but before the device state had disappeared.
>> 
>> pcie_isr looks like it would be even worse in that situation.  Looping forever
>> if pciehp_readw(ctrl, PCIE_EXPSLTA) always succeed sand returns 0xffff.
>> 
>> That loop in there appears impossibly misguided.  If the pending interrupt
>> values change after you have received the interrupt another instance
>> of the same interrupt should be pending so the loop should be completely
>> unnecessary.
>> 
>
> For level-triggered interrupt, I think it's true.
>
> But for edge-triggered interrupt, I don't think it's true. I think
> only one interrupt is generated if the first hotplug event occurs
> and the second hotplug event occurs before clearing the status of
> first hotplug event.

My test case is edge-triggered MSI's.  The issue is that I get an interrupt
from the card that I am unplugging, but by the time the interrupt handler
is executed the card is physically absent, but the pci_dev structure is
still present in the kernel.

Eric
