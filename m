Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbZBDXvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbZBDXvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759743AbZBDXtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:49:53 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:2265 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759699AbZBDXtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:49:52 -0500
Date: Wed, 4 Feb 2009 16:49:49 -0700
From: Alex Chiang <achiang@hp.com>
To: Krishna Kothapalli <krishna_sunitha@hotmail.com>
Cc: kaneshige.kenji@jp.fujitsu.com, ebiederm@xmission.com,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, djwong@us.ibm.com,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
Message-ID: <20090204234949.GC19517@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Krishna Kothapalli <krishna_sunitha@hotmail.com>,
	kaneshige.kenji@jp.fujitsu.com, ebiederm@xmission.com,
	linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
	djwong@us.ibm.com, xyzzy@speakeasy.org,
	linux-kernel@vger.kernel.org
References: <m1fxj06js8.fsf@fess.ebiederm.org> <4986581F.7060704@jp.fujitsu.com> <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl> <49879508.4090801@jp.fujitsu.com> <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl> <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl> <49892CDE.9040305@jp.fujitsu.com> <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Krishna Kothapalli <krishna_sunitha@hotmail.com>:
> 
> > o The pciehp's debug output. We can get this as follows.
>   # /sbin/modprobe pciehp pciehp_debug
>   # dmesg | grep pciehp 
> pciehp 0000:00:09.0:pcie02: Hotplug Controller:
> pciehp 0000:00:09.0:pcie02:   Seg/Bus/Dev/Func/IRQ : 0000:00:09.0 IRQ 2295
> pciehp 0000:00:09.0:pcie02:   Vendor ID            : 0x8086
> pciehp 0000:00:09.0:pcie02:   Device ID            : 0x3410
> pciehp 0000:00:09.0:pcie02:   Subsystem ID         : 0x0000
> pciehp 0000:00:09.0:pcie02:   Subsystem Vendor ID  : 0x0000
> pciehp 0000:00:09.0:pcie02:   PCIe Cap offset      : 0x90
> pciehp 0000:00:09.0:pcie02: Slot Capabilities      : 0x0302005f
> pciehp 0000:00:09.0:pcie02:   Physical Slot Number : 96

Hm, this is merely an observation, but the slot number here seems
wacky compared to the one that acpiphp reports later below.

Did we ever get a dmidecode from this machine?

Also, once you insert the card, what happens if you:

	# echo 1 > /sys/bus/pci/slots/96/power

Does that do anything?

> [root@localhost test]#  /sbin/modprobe acpiphp debug
> [root@localhost test]# dmesg | grep acpiphp
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:00:09.0
> acpiphp_glue: found ACPI PCI Hotplug slot 2 at PCI 0000:09:00
> acpiphp: Slot [2] registered

Here we see that ACPI thinks it's slot 2, not 96.

> acpiphp_glue: Bus 0000:09 has 1 slot
> acpiphp_glue: Total 1 slots
> [root@localhost test]# 
> [root@localhost test]# ls -lt /sys/bus/pci/slots
> total 0
> drwxr-xr-x 2 root root 0 2009-02-04 09:59 2
> ---  Insert PCI express card in the slot
> [root@localhost test]# dmesg | grep acpiphp
> [root@localhost test]# lspci | wc
>     105    1284    9203
> [root@localhost test]# ls -lt /sys/bus/pci/slots/2/
> total 0
> -r--r--r-- 1 root root 4096 2009-02-04 10:01 adapter
> -r--r--r-- 1 root root 4096 2009-02-04 10:01 address
> -rw-r--r-- 1 root root 4096 2009-02-04 10:01 attention
> -r--r--r-- 1 root root 4096 2009-02-04 10:01 latch
> -rw-r--r-- 1 root root 4096 2009-02-04 10:01 power

Can you echo a 1 into the power file above?

> [root@localhost test]# 
> [root@localhost test]# /sbin/rmmod acpiphp
> [root@localhost test]# dmesg | grep acpiphp
> acpiphp: Slot [2] unregistered
> acpiphp: release_slot - physical_slot = 2
> [root@localhost test]# 

Thanks.

/ac

