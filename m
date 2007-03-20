Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbXCTVGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbXCTVGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXCTVGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:06:45 -0400
Received: from www17.your-server.de ([213.133.104.17]:2600 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbXCTVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:06:45 -0400
Message-ID: <46004D2F.4020901@m3y3r.de>
Date: Tue, 20 Mar 2007 22:07:59 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
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

Ok. The error happens in the call of pcibios_enable_device in the
function do_pci_enable_device (drivers/pci/pci.c):

Before the call of pcibios_enable_device:

do_pci_enable_device: pci_dev= c1a40000
do_pci_enable_device: irq= 218
do_pci_enable_device: msi_enabled= 1

after the call:
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19

do_pci_enable_device: pci_dev= c1a40000
do_pci_enable_device: irq= 19
do_pci_enable_device: msi_enabled= 1


So the function acpi_pci_irq_enable in drivers/acpi/pci_irq.c  needs to
be fixed:

a.) acpi_pci_irq_enable should care about msi setups and set the flag
msi_enabled to 0 or
b.) acpi_pci_irq_enable should care about msi setups and should touch
the dev->irq field.

Please comment on this.

with kind regards
thomas


