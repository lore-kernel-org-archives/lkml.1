Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYCKNMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYCKNMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYCKNMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:12:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42277 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYCKNMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:12:32 -0400
Message-ID: <47D684D0.6060200@jp.fujitsu.com>
Date: Tue, 11 Mar 2008 22:10:40 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com>
In-Reply-To: <20080305202052.GN3694@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

Alex Chiang wrote:
>>> It wasn't the IBM machine that was breaking; it was Fujitsu. They
>>> were returning an error code (the numerical value 1023) when I
>>> called the _SUN method on a slot object that existed in the ACPI
>>> namespace but was not present (as reported by the _STA method).
>>> By the time I got that error report, I'd already dropped the
>>> duplicate name detection code, and was letting the kobject
>>> infrastructure warn about duplicate names because for my test
>>> cases, refcounting was a better solution.
>>> [Kenji-san from Fujitsu seemed to be ok with the progress I'd
>>> made at the time, he can speak up if he's changed his mind ;)]
>> Unfortunatelly, I have not tried the new version of slot detection
>> driver because of the lack of test environment. Maybe we need more
>> several days to wait for test environment. 
>> BTW, does the new one fixes the issue I reported before? I could not
>> find it in the changelog. IIRC, this issue was difficult to solve
>> because the root cause of this issue is from the difference of
>> interpretation of ACPI spec between HP and Fujitsu (I still don't
>> think it's a good idea to evaluate _SUN for the device object whose
>> _STA is 0).
> 
> It looks like we disagree on how to interpret the spec (IBM
> machines interpret the spec the same way HP machines do).
> 
> So given that it's two versus one, I modified my
> drivers/acpi/pci_slot module to consider Fujitsu machines to be a
> quirk. :)
> 
> Can you please test patches 1 and 2 that I sent out as v8 of my
> series, but replace patch 3 with this patch?
> 
> Please note -- you will probably need to modify this block:
> 
> 	{ 
> 	 .callback = do_sta_before_sun,
> 	 .ident = "Fujitsu Limited Primequest",
> 	 .matches = {
> 	 	DMI_MATCH(DMI_BIOS_VENDOR, "Fujitsu"),
> 		DMI_MATCH(DMI_BIOS_VERSION, "2.35"),
> 		},
> 	},
> 
> To get the correct values for DMI_BIOS_VENDOR and
> DMI_BIOS_VERSION, because I was just guessing.
> 

I tried your patches, and I have two comments. I want 1) to be fixed
before merge to Greg's tree (or linux-next?), at least.

 1) I checked ACPI spec again and again, but I could not find any
    reason to add Fujitsu servers to quirks list. So I'd like you to
    add HP servers to the quirks list. I'll send the following patches
    followed by this e-mail.

    - [PATCH 3/(3+1)] ACPI PCI slot detection driver
      This is the updated version of ACPI PCI slot detection driver. I
      changed your patch to evaluate _STA before evaluating _SUN.

    - [PATCH 4/(3+1)] add quirks for ACPI PCI slot detection driver
      Add quirks management code using DMI. Please update the
      following part for HP servers.

      static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
              /*
               * Ignore _STA if the hardware provides _STA to indicate the
               * presence of PCI adapter card on PCI hotplug slot.
               */
              /* Please add appropriate values for HP/IBM servers.
              {
                      .callback = ignore_sta_before_sun,
                      .ident = "",
                      .matches = {
                              DMI_MATCH(DMI_BIOS_VENDOR, ""),
                              DMI_MATCH(DMI_BIOS_VERSION, ""),
                      },
              },
               */
              {}
      };

 2) The ACPI PCI slot detection driver would change the slot names of
    some hotplug drivers (at least I checked shpchp and pciehp). And
    the name of slots are depending on the order of driver loading.
    For example, on my system which has several SHPCHP slots and
    PCIEHP slots, the name of PCIEHP slots are changed as
    follows. Please note that PCIEHP based slots are 0034_0027 and
    0032_0026, and others are SHPCHP based slots.

    - Without ACPI PCI slot detection driver
      # ls /sys/bus/pci/slots/
      0009_0016  0014_0018  0019_0020  0021_0022  0034_0027
      0011_0017  0016_0019  0021_0021  0032_0026

    - With ACPI PCI slot detection driver
      # ls /sys/bus/pci/slots/
      0009_0016  0014_0018  0019_0020  0021_0022  27
      0011_0017  0016_0019  0021_0021  26

    I had thought it is not a big problem before because people who
    don't like new names would not load the PCI slot driver. But since
    it is loaded automatically at boot time, I'm wondering that it
    would be a problem. For example, some platform, not fujitsu,
    depends on the old slot name to work, IIRC (Maybe Kristen knows
    the background about it). And I don't think the fact that slot
    names are changed depending on the order of driver loading is
    acceptable by system management people/software, though I don't
    have such software.

    Though I don't have any specific idea about this, folliwings might
    be candidates.

    - Override slot names with hotplug driver's slot names
    - Unify slot names among all hotplug drivers
    - Stop automatic loading of ACPI PCI slot driver

    Anyway, the naming should be considered in the next enhancement.

Thanks,
Kenji Kaneshige


