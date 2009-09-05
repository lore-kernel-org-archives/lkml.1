Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbZIEJDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbZIEJDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 05:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932549AbZIEJDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 05:03:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbZIEJDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 05:03:43 -0400
Message-ID: <4AA2291D.4020103@redhat.com>
Date: Sat, 05 Sep 2009 11:02:21 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, lenb@kernel.org, ktokunag@redhat.com, tglx@linutronix.de,
       Olaf.Dabrunz@gmx.net
Subject: Re: [RFC][PATCH 1/2] show Intel QuickPath Interconnect Routing and
 	Protocol Layer Registers in PCI config space
References: <20090904165525.26294.31112.sendpatchset@t500>	 <20090904165535.26294.95511.sendpatchset@t500> <86802c440909041007w9fee1edg49d755dc3fe627e5@mail.gmail.com>
In-Reply-To: <86802c440909041007w9fee1edg49d755dc3fe627e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.09.2009 19:07, Yinghai Lu wrote:
> On Fri, Sep 4, 2009 at 9:55 AM, Stefan Assmann<sassmann@redhat.com> wrote:
>> On some machines with Intel X58 or Intel 55x0 chipset the Intel QuickPath
>> Interconnect Routing and Protocol Layer Registers or not exposed to PCI config
>> space. Access to these is necessary to disable boot interrupts in the QPI
>> Protocol Interrupt Control Register.
>> DEVHIDE1 provides a method to (un)hide the PCI config space of devices inside
>> the IOH and is altered to guarantee that PCI config space is accessible.
>> See Intel document #320838-003, sections 17.6.5.10 and 17.11.2.21.
>>
>> Signed-off-by: Stefan Assmann <sassmann@redhat.com>
>> ---
>>  drivers/pci/quirks.c    |   24 ++++++++++++++++++++++++
>>  include/linux/pci_ids.h |    1 +
>>  2 files changed, 25 insertions(+)
>>
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -1612,6 +1612,30 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
>>  DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10,    quirk_disable_intel_boot_interrupt);
>>
>>  /*
>> + * Show Intel QuickPath Interconnect Routing and Protocol Layer Registers
>> + * in PCI config space (ensures access to QPIPINTRC).
>> + * See Intel document #320838-003, sections 17.6.5.10 and 17.11.2.21.
>> + */
>> +#define INTEL_X58_55x0_DEVHIDE1_REG    0xf2
>> +#define INTEL_X58_55x0_HIDE_DEV17_FUN0 (1<<12)
>> +#define INTEL_X58_55x0_HIDE_DEV17_FUN1 (1<<13)
>> +
>> +static void quirk_show_intel_qpi_conf_register(struct pci_dev *dev)
>> +{
>> +       u16 pci_config_word;
>> +
>> +       pci_read_config_word(dev, INTEL_X58_55x0_DEVHIDE1_REG, &pci_config_word);
>> +       pci_config_word &= ~(INTEL_X58_55x0_HIDE_DEV17_FUN0 |
>> +                            INTEL_X58_55x0_HIDE_DEV17_FUN1);
>> +       pci_write_config_word(dev, INTEL_X58_55x0_DEVHIDE1_REG, pci_config_word);
>> +
>> +       /* need to rescan the bus for changes to take effect */
>> +       pci_rescan_bus(dev->bus);

Hi Yinghai,

> better to check if those bits are set already...

If that's really an issue I'll change it, however it shouldn't cause any
troubles to set an already set bit. I'm not really sure if it's worth
the effort. It has the advantage of possibly avoiding pci_rescan_bus,
you're right about that.

> can you move the quirk to EARLY to avoid rescan bus?

Already tried that and it didn't work.

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
