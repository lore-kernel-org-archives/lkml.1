Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXCQSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXCQSa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 14:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXCQSa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 14:30:28 -0400
Received: from www17.your-server.de ([213.133.104.17]:2670 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXCQSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 14:30:28 -0400
Message-ID: <45FC3410.4060907@m3y3r.de>
Date: Sat, 17 Mar 2007 19:31:44 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in pci_restore_msi_state
References: <45FBE22A.8030304@m3y3r.de> <84144f020703170618x73808b4fmf5b420f4c2e02818@mail.gmail.com>
In-Reply-To: <84144f020703170618x73808b4fmf5b420f4c2e02818@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg schrieb:
> On 3/17/07, Thomas Meyer <thomas@m3y3r.de> wrote:
>> Hello everybody.
>>
>> I get this bug after suspending to disk twice:
>>
>> http://m3y3r.de/bilder/Bug-pci_restore_msi_state.png
>>
>> This happens with current git head
>> cd05a1f818073a623455a58e756c5b419fc98db9.
>
> If you know a kernel that works, please consider doing git bisect:
>
> http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
>
>
I don't think so, because suspend to disk began to work again with the
latest commit.

But it seems to have to do with dev->msi_enabled, that is enabled, but
the msi_attrib for this device is empty (pos is zero) in the function
__pci_restore_msi_state. irq=19 and msi_attrib=0 before the bug happens
(trying to accessing msi_attrib.pos).
But 19 is not an msi interrupt, isn't it?

           CPU0       CPU1
  0:     168998          0   IO-APIC-edge      timer
  9:       9056          0   IO-APIC-fasteoi   acpi
 16:         43          0   IO-APIC-fasteoi   uhci_hcd:usb5
 17:       8278      19996   IO-APIC-fasteoi   wifi0
 18:      11388          0   IO-APIC-fasteoi   libata, uhci_hcd:usb4
 19:          3          0   IO-APIC-fasteoi   uhci_hcd:usb3, ohci1394
 20:     115285          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:        225          0   IO-APIC-fasteoi   HDA Intel
218:      14365          0   PCI-MSI-edge      libata
219:          1          0   PCI-MSI-edge      eth0
NMI:          0          0
LOC:      49119      88723
ERR:          0
MIS:          0

Shouldn't  the flag msi_enabled be set to zero in function
msi_remove_pci_irq_vectors?


