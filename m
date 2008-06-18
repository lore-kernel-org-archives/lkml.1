Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYFROuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYFROuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYFROu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:50:27 -0400
Received: from smtp1.extricom.com ([212.235.24.249]:49147 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751093AbYFROu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:50:26 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 10:50:25 EDT
Message-ID: <48591941.4070408@extricom.com>
Date: Wed, 18 Jun 2008 17:18:41 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc4: pci_remove_bus_device() => pci_scan_child_bus() => pci_bus_add_devices
 bug?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short:
1. Calling pci_remove_bus_device() on some of the devices on a bus will 
remove them. (ok)
2. Calling pci_scan_child_bus() on that bus will scan the bus for 
devices and add them all. even the ones already in the bus device list, 
which will now be duplicated in the bus device list! (no so ok)
3. Calling pci_bus_add_devices() Will try to add the device, assign 
resource, and create procfs files. The devices which were not originally 
removed are were being assigned resource they don't need and procfs 
files already exist and will collide (Bug)

Background:
I have a programmable component  which implements a pci device. Upon 
warm update i need to remove my devices from the bus, upgrade, and add 
them back.
I have bashed my head against pci.h API for the last week trying to make 
this work with no success. Right now I have devised a hideous hack to 
circumvent pci.h and directly remap the pci device registers.

demo code:

reload_my_hardware_design() {
    struct pci_dev *dev = NULL;
    struct pci_bus *bus = NULL;

    while ((dev = pci_get_device(PCI_VENDOR_ID_MY_ID,PCI_ANY_ID,NULL))) {
         pci_remove_bus_device(dev);
    }

    ...
    reload the hardware
    ...

    bus = pci_find_bus(0,0); /* though hard coded in this example this 
is the right bus*/
    pci_scan_child_bus(bus);
    pci_bus_add_devices(bus);
}


Is this a bug or am I doing something wrong?

Liberty
