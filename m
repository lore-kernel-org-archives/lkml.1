Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbYJIFc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbYJIFc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 01:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYJIFcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 01:32:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47890 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYJIFcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 01:32:15 -0400
Message-ID: <48ED9716.3040301@jp.fujitsu.com>
Date: Thu, 09 Oct 2008 14:31:02 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v5 04/16] PCI: prevent duplicate slot names
References: <20081009043140.8678.44164.stgit@bob.kio> <20081009044649.8678.30990.stgit@bob.kio>
In-Reply-To: <20081009044649.8678.30990.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Prevent callers of pci_create_slot() from registering slots with
> duplicate names. This condition occurs most often when PCI hotplug
> drivers are loaded on platforms with broken firmware that assigns
> identical names to multiple slots.
> 
> We now rename these duplicate slots on behalf of the user.
> 
> If firmware assigns the name N to multiple slots, then:
> 
> 	The first registered slot is assigned N
> 	The second registered slot is assigned N-1
> 	The third registered slot is assigned N-2
> 	etc.
> 
> A side effect of this patch is that the error condition for when
> multiple drivers attempt to claim the same slot becomes much more
> prominent. The -EBUSY was getting masked previously by -EEXIST in
> the event of duplicate slot names; this is no longer so.
> 
> This is the permanent fix mentioned in earlier commits d6a9e9b4 and
> 167e782e (shpchp/pciehp: Rename duplicate slot name...).
> 
> Finally, we take advantage of the new 'rename' parameter in
> pci_create_slot() to prevent a slot create/rename race between hotplug
> drivers and detection drivers.
> 
> 	Scenario A:
> 	hotplug driver                  detection_driver
> 	--------------                  ----------------
> 	pci_create_slot(rename=1)
> 					pci_create_slot(rename=0)
> 
> The hotplug driver creates the slot with its desired name, and then
> releases the semaphore. Now, the detection driver tries to create
> the same slot, but it already exists. We don't care about renaming,
> so return the existing slot.
> 
> 	Scenario B:
> 	hotplug driver                  detection_driver
> 	--------------                  ----------------
> 					pci_create_slot(rename=0)
> 	pci_create_slot(rename=1)
> 
> The detection driver creates the slot with name "X". Then the hotplug
> driver tries to create the same slot, but wants the name "Y" instead.
> We detect that we're trying to create the same slot and that we also
> want a rename, so rename the slot to "Y" and return.
> 

Thank your new patches. Very quick!!!

Though I have not reviewed/tested your patches yet (of course), I have
one concern as I said in the e-mail soon before. Does the new one
consider the following senario?

 	Scenario C:
 	hotplug driver(A)               	hotplug_driver(B)
 	--------------                  	----------------
        pci_create_slot(name=A, rename=1)
						pci_create_slot(name=B, rename=1)

The hotplug driver (A) creates the slot with name "A". The the hotplug
driver (B) tries to create the same slot, but wants the name "B" instead.
In this case, hotplug driver fails to create the slot and the slot name
should not be changed to "B" from "A".

Thanks,
Kenji Kaneshige

