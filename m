Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYJJF2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYJJF2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYJJF17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:27:59 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:24000 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYJJF17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:27:59 -0400
Date: Thu, 9 Oct 2008 23:27:57 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v5 04/16] PCI: prevent duplicate slot names
Message-ID: <20081010052757.GA26341@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20081009043140.8678.44164.stgit@bob.kio> <20081009044649.8678.30990.stgit@bob.kio> <48ED9716.3040301@jp.fujitsu.com> <20081009055654.GA30972@ldl.fc.hp.com> <48EDF9F5.9020802@jp.fujitsu.com> <20081010021034.GA13292@ldl.fc.hp.com> <48EEDD7E.5090002@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EEDD7E.5090002@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>
> I'm sorry, but I forgot to tell you one important thing. Now we
> are trying to change pci slot management API to setup
> pci_slot->hotplug.  We must consider how to implement the
> counterpart to clean up pci_slot->hotplug at the same time. My
> current idea is adding hotplug arg to pci_destroy_slot(), but
> it seems a little ugly...

Ugh, I'm not sure which is worse, an unbalanced API vs passing a
hotplug_slot to pci_destroy_slot.

pci_destroy_slot should never touch the pci_slot->hotplug
argument, I think, because it is possible for non-hotplug callers
to call pci_create_slot.

I think the rule should just be:

	- all hotplug drivers must use pci_hp_register/deregister
	- hotplug drivers must pass a valid hotplug_slot argument

	- all detection drivers must use pci_create/destroy_slot
	- detection drivers must pass NULL for hotplug_slot

If you prefer, we could wrap pci_create_slot for detection
drivers:

struct pci_slot *pci_slot_register(struct pci_bus *parent, int slot_nr,
				   const char *name)

{
	return pci_create_slot(parent, slot_nr, name, NULL);
}
EXPORT_SYMBOL_GPL(pci_slot_register);

And then do not export pci_create_slot().

Hm?

/ac

