Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYKDFr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYKDFr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 00:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYKDFrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 00:47:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46121 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbYKDFrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 00:47:49 -0500
Message-ID: <490FE1AC.5030608@jp.fujitsu.com>
Date: Tue, 04 Nov 2008 14:46:20 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
References: <20081029200903.GA1678@srcf.ucam.org> <490FAC33.9050808@jp.fujitsu.com> <20081104020700.GA11761@srcf.ucam.org> <20081104050245.GA13466@srcf.ucam.org>
In-Reply-To: <20081104050245.GA13466@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Nov 04, 2008 at 02:07:00AM +0000, Matthew Garrett wrote:
>> On Tue, Nov 04, 2008 at 10:58:11AM +0900, Kenji Kaneshige wrote:
>>>> 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if 
>>>> 	slot is occupied */
>>>> -	if (value && pciehp_force) {
>>>> +	if (value && (pciehp_force || pciehp_passive)) {
>>>> 		rc = pciehp_enable_slot(t_slot);
>>>> 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
>>>> 			value = 0;
>> This code no longer runs in the pciehp_passive case. However, by the 
>> looks of it it still does in the resume case - that probably wants 
>> fixing.
> 
> Thinking about this - you said that the problem occurs because 
> pciehp_force=1 causes it to try to enable an already enabled slot, and 
> then tries to power down the slot as a result? It sounds like this code 
> should actually be checking whether the return value is ENODEV or 
> EINVAL, and in the latter case not powering the slot down. That sounds 
> like a separate bugfix that I'll send later on.
> 

I think the root cause of this problem is the following line.

>>>> 			value = 0;

I can't understand why the 'value' is set to 0 when pciehp_enable_slot()
returns error. The 'value' here is representing whether the slot is
occupied or not. Even if pciehp_enable_slot() returns error, it doesn't
mean slot is not occupied. So I think it is clearly wrong thing that
changing 'value' to 0 from 1 here.

How about just ignore the return value from pciehp_enable_slot()? The
code would be as follows.

	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
	if (value) {
		if (pciehp_force)
			pciehp_enable_slot(t_slot);
	} else {
		/* Power off the slot if not occupied, just in case */
		if (POWER_CTRL(ctrl))
			if (t_slot->hpc_ops->power_off_slot(t_slot))
				goto err_out_free_ctrl_slots;
	}

Thanks,
Kenji Kaneshige

