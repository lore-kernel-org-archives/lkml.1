Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYJIF5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYJIF5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 01:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYJIF44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 01:56:56 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:25747 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYJIF4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 01:56:55 -0400
Date: Wed, 8 Oct 2008 23:56:54 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v5 04/16] PCI: prevent duplicate slot names
Message-ID: <20081009055654.GA30972@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20081009043140.8678.44164.stgit@bob.kio> <20081009044649.8678.30990.stgit@bob.kio> <48ED9716.3040301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ED9716.3040301@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>
> Thank your new patches. Very quick!!!

I'm trying to get into 2.6.28. ;)

> Though I have not reviewed/tested your patches yet (of course), I have
> one concern as I said in the e-mail soon before. Does the new one
> consider the following senario?
>
> 	Scenario C:
> 	hotplug driver(A)               	hotplug_driver(B)
> 	--------------                  	----------------
>        pci_create_slot(name=A, rename=1)
> 						pci_create_slot(name=B, rename=1)
>
> The hotplug driver (A) creates the slot with name "A". The the hotplug
> driver (B) tries to create the same slot, but wants the name "B" instead.
> In this case, hotplug driver fails to create the slot and the slot name
> should not be changed to "B" from "A".

Hm... I don't think this is a common scenario but...

int pci_hp_register(...)
{
	...

        pci_slot = pci_create_slot(bus, slot_nr, name, 1);
        if (IS_ERR(pci_slot))    
                return PTR_ERR(pci_slot);

        if (pci_slot->hotplug) {
                dbg("%s: already claimed\n", __func__);
                pci_destroy_slot(pci_slot);
                return -EBUSY;
        }
	...
}

I could maybe move that check into pci_create_slot() instead.

struct pci_slot *pci_create_slot(...)
{
	...

        /*
         * Get existing slot and rename if desired
         */
        slot = get_slot(parent, slot_nr);
        if (slot && rename) {
		if ((err = slot->hotplug ? -EBUSY : 0)
		     || (err = rename_slot(slot, name))) {
                        kobject_put(&slot->kobj);
                        slot = NULL;
                        goto err;
                } else
                        goto out;
        } else if (slot)
                goto out;
	...
}

Seems a little ugly to me, but maybe it's necessary?

/ac

