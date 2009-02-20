Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZBTGSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZBTGSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 01:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZBTGSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 01:18:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58954 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZBTGSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 01:18:32 -0500
Message-ID: <499E4B2F.9070607@jp.fujitsu.com>
Date: Fri, 20 Feb 2009 15:18:23 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
References: <m1pri623g9.fsf@fess.ebiederm.org>	<49815BF6.7060402@jp.fujitsu.com>	<200902131129.09523.jbarnes@virtuousgeek.org>	<m11vu1wtk6.fsf@fess.ebiederm.org> <49991D3A.7090001@jp.fujitsu.com>	<m1mycktw5t.fsf@fess.ebiederm.org> <499BB4EB.6020602@jp.fujitsu.com> <m1hc2s5dyp.fsf@fess.ebiederm.org>
In-Reply-To: <m1hc2s5dyp.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:
> 
>> In the current pciehp implementation, minimum resources enough to
>> enable devices under the bridge are assigned when P2P bridge is
>> hot-added. My concern is that enough resources are NOT assigned to
>> the bridge if an additional slot is empty. As a result, hot-add
>> adapter card on the additional slot won't work because of resource
>> shortage.
> 
> It is a good concern.  Right now I know I won't need a bus number
> but you are quite right the mmio and iospace may be a problem.
> 
> My preliminary test case doesn't cover that so I will look and
> confirm it is a problem I need to address.
> 
>>> kobject_name is not initialized, and slot_name(p_slot) calls
>>> hoptlug_slot_name which calls pci_slot_name which kobj_name. 
>>> It looks like this problem was introduced in commit 
>>> e1acb24f059defdaa0264e925f19cc21b0a3e592
>> Thank your for the information. I understood what is happening.
>> This needs to be fixed. But, as I mentioned before, I think
>> software notification mechanism should be initialized before
>> sysfs entries are created. I'll consider alternative fix.
> 
> Reasonable.  I haven't had the need nor gotten brave enough to
> support those sysfs entries in my minimal driver.
> 

Eric-san, Jesse-san,

I tried to make alternative fix, but now I have a conclusion that
Eric-san's patch is the best solution. The reasons are

- Eric-san's approach prevents the regression such as commit
  e1acb24f059defdaa0264e925f19cc21b0a3e592.

- My concern was that command completion might not be handled if
  we enable software notification mechanism after creating sysfs
  entries. But it is not true because pciehp uses polling approach
  if command is issued before enabling software notification (I
  made it, but I forgot it...). Just in case, I confirmed that
  hotplug operations (power on/off, attention indication on/off
  and so on) works even if I make pciehp_init_notification() NOP.

Jesse-san, could you consider applying Eric-san's patch?

Here are my

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Note: I tested Eric-san's patch on Jesse-san's for-linus tree.

Thanks,
Kenji Kaneshige


