Return-Path: <linux-kernel-owner+w=401wt.eu-S1751888AbZLEF17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbZLEF17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 00:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZLEF14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 00:27:56 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6382 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZLEF14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 00:27:56 -0500
Date: Fri, 4 Dec 2009 22:28:02 -0700
From: Alex Chiang <achiang@hp.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: Make pci_dev struct point to NULL.
Message-ID: <20091205052802.GD10777@ldl.fc.hp.com>
References: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com> <20091204202709.GA32347@ldl.fc.hp.com> <b9df5fa10912041753n27e60020x2dd41eb50f4608ff@mail.gmail.com> <20091205043635.GA10777@ldl.fc.hp.com> <b9df5fa10912042118p733416ffwe21b79b1f8246f2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10912042118p733416ffwe21b79b1f8246f2f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rakib Mullick <rakib.mullick@gmail.com>:
> 
> Since *pdev might be uninitialized. But if we are sure that it
> is not uninitialized then it is okay.
> 
> And yes - althrough we weren't warned by the compiler.

Let's start over.

This is the function:

 965 static int __ref enable_device(struct acpiphp_slot *slot)
 966 {
 967         struct pci_dev *dev;

Your patch makes this change:
             struct pci_dev *dev = NULL;

 968         struct pci_bus *bus = slot->bridge->pci_bus;
 969         struct list_head *l;
 970         struct acpiphp_func *func;
 971         int retval = 0;
 972         int num, max, pass;
 973         acpi_status status;
 974 
 975         if (slot->flags & SLOT_ENABLED)
 976                 goto err_exit;

Here, if the slot is already enabled, we goto the err_exit label
(below). We haven't touched 'dev' yet.

Otherwise, we call pci_get_slot().

 977 
 978         /* sanity check: dev should be NULL when hot-plugged in */
 979         dev = pci_get_slot(bus, PCI_DEVFN(slot->device, 0));
 980         if (dev) {
 981                 /* This case shouldn't happen */
 982                 err("pci_dev structure already exists.\n");
 983                 pci_dev_put(dev);
 984                 retval = -1;
 985                 goto err_exit;
 986         }

If pci_get_slot() finds the devfn, it returns the pointer to the
pdev, puts it into 'dev' and we return early.

If it cannot find the devfn, then we put NULL into dev and
continue with the rest of the function.

1044  err_exit:
1045         return retval;
1046 }


At no point that I can tell do we ever access an uninitialized
'dev'.

Please explain to me one more time what you think you are fixing.

Thanks,
/ac
