Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZKPONk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZKPONk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZKPONj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:13:39 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:37834 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZKPONi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:13:38 -0500
Message-ID: <4B015E0C.9030904@linux.vnet.ibm.com>
Date: Mon, 16 Nov 2009 12:13:32 -0200
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-net-drivers@solarflare.com
Subject: Re: PCI: pci_restore_state() is returning 0 when it fails
References: <4AFD91DD.7000104@linux.vnet.ibm.com> <200911132108.56691.rjw@sisk.pl>
In-Reply-To: <200911132108.56691.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael, 

Rafael J. Wysocki wrote:
> On Friday 13 November 2009, Breno Leitao wrote:
>> Actually pci_restore_state() is returning 0 if the restore process
>> fails, instead of a error value.
>>
>> If it fails, I believe that it should return -EPERM, once that
>> it is an invalid operation and probably pci_save_state() wasn't
>> called.
> 
> I believe this patch will break a number of things.
Well, I checked it, and found that there are around 10 places that
really verify the return value for this function, and almost all of them
do the correct thing, and the patch doesn't seem to break any of them
except a specific case in the drivers/net/sfc/falcon.c file, that contains:

                if (FALCON_IS_DUAL_FUNC(efx)) {
                        rc = pci_restore_state(nic_data->pci_dev2);
                        if (rc) {
                                EFX_ERR(efx, "failed to restore PCI config for "
                                        "the secondary function\n");
                                goto fail3;
                        }
                }
                rc = pci_restore_state(efx->pci_dev);
                if (rc) {
                        EFX_ERR(efx, "failed to restore PCI config for the "
                                "primary function\n");
                        goto fail4;


In this case, if FALCON_IS_DUAL_FUNC(efx) returns true, then the next
pci_restore_state(efx->pci_dev) will return -1, and cause the "failed to 
restore PCI config for the primary function" error.
That's because the code is calling pci_restore_state() twice without calling
pci_save_state() in the middle. 
Since this seems to be the only place that will be broken, and the fix is
trivial, I believe that the patch can be applied smoothly.

> Does it actually fix any problem you have observed?
No, but we use this function to resume drivers after PPC machines detects
errors (EEH). And before your patch, we basically save the state once 
(in the init function), and then call pci_restore_state() every time the 
machine detects an error. After your patch, it's not possible anymore, 
because pci_restore_state() will not restore the state after the
first restore. So, I'd like to instrument some drivers to check if it's
possible to recover or not.

I also believe that returning 0 for a failed function isn't a good plan.

Thanks for the review, 
Breno
