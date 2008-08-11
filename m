Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYHKBU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYHKBU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 21:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYHKBUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 21:20:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49529 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbYHKBUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 21:20:48 -0400
Message-ID: <489F938A.10302@jp.fujitsu.com>
Date: Mon, 11 Aug 2008 10:19:06 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/7] Fixups for duplicate slot names
References: <20080806050745.GA31319@ldl.fc.hp.com> <489AB595.7000006@jp.fujitsu.com> <20080807172529.GB25902@ldl.fc.hp.com>
In-Reply-To: <20080807172529.GB25902@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Hi Alex-san,
>>
>> Thank you for patches!
>>
>> I looked at your patches and it looks good. But I have only one
>> concern about how to allocate/free memory for slot name.
>>
>> With your change, memory region for slot name will be allocated
>> by hotplug *controller* driver and it can be freed using kfree()
>> by hotplug *core* driver (not hotplug controller driver). So all
>> hotplug controller drivers including drivers implemented in the
>> future need to take it into account.
>>
>> I think it will be more robust if we can allocate and free memory
>> in the same component (maybe hotplug core driver in this case).
> 
> Hm, I didn't think this would be a problem. The sequence is:
> 
> 	- controller allocates memory for slot name
> 	- if core detects a collision:
> 		- it frees the name
> 		- it allocates new memory for name
> 		- it assigns that memory to the name parameter
> 	- controller->release will eventually free the name
> 
> So it shouldn't matter if the core frees the original name
> pointer and allocates new memory, because the core will change
> the pointer for the controller.
> 
> This is why I had to change the interface of pci_create_slot()
> from taking a const char *name to a char *name.
> 
> Is there something I'm missing?
> 
> /ac

I'm worrying about the following cases for example:

 - hotplug controller driver allocates memory for slot name using
   other than kmalloc().

 - hotplug controller driver allocates memory for slot name as
   a part of another data structure.

Thanks,
Kenji Kaneshige


