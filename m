Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbYBBASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbYBBASb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYBBASW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:18:22 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50165 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606AbYBBAST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:18:19 -0500
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.6)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, michaelc@cs.wisc.edu, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20080130213700.GA28529@andromeda.dapyr.net>
References: <20080130213700.GA28529@andromeda.dapyr.net>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 18:18:09 -0600
Message-Id: <1201911489.3134.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-30 at 17:37 -0400, Konrad Rzeszutek wrote:
> This patch (v0.4.6) adds /sysfs/firmware/ibft/[initiator|targetX|ethernetX]
> directories along with text properties which export the the iSCSI
> Boot Firmware Table (iBFT) structure.
> 
> What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
> tools to extract from the machine NICs the iSCSI connection information
> so that they can automagically mount the iSCSI share/target. Currently
> the iSCSI information is hard-coded in the initrd. The /sysfs entries
> are read-only one-name-and-value fields.
> 
> The usual set of data exposed is:
> 
> # for a in `find /sys/firmware/ibft/ -type f -print`; do  echo -n "$a: ";  cat $a; done
> /sys/firmware/ibft/target0/target-name: iqn.2007.com.intel-sbx44:storage-10gb
> /sys/firmware/ibft/target0/nic-assoc: 0
> /sys/firmware/ibft/target0/chap-type: 0
> /sys/firmware/ibft/target0/lun: 00000000
> /sys/firmware/ibft/target0/port: 3260
> /sys/firmware/ibft/target0/ip-addr: 192.168.79.116
> /sys/firmware/ibft/target0/flags: 3
> /sys/firmware/ibft/target0/index: 0
> /sys/firmware/ibft/ethernet0/mac: 00:11:25:9d:8b:01
> /sys/firmware/ibft/ethernet0/vlan: 0
> /sys/firmware/ibft/ethernet0/gateway: 192.168.79.254
> /sys/firmware/ibft/ethernet0/origin: 0
> /sys/firmware/ibft/ethernet0/subnet-mask: 255.255.252.0
> /sys/firmware/ibft/ethernet0/ip-addr: 192.168.77.41
> /sys/firmware/ibft/ethernet0/flags: 7
> /sys/firmware/ibft/ethernet0/index: 0
> /sys/firmware/ibft/initiator/initiator-name: iqn.2007-07.com:konrad.initiator
> /sys/firmware/ibft/initiator/flags: 3
> /sys/firmware/ibft/initiator/index: 0
> 
> 
> For full details of the IBFT structure please take a look at:
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf

Some pieces of the patch are obviously wrong:  find_ibft() shouldn't be
in ibft_init ... if ibft_phys was zero, it means the bootmem reservation
wasn't done and you shouldn't be poking about in memory which has likely
now been overwritten.

Also, why is ibft_phys the global variable you pass?  You never actually
want to use the physical address, what you always end up using is the
kernel virtual address.

I'd simply use the ibft variable to point to the virtual address of the
ibft or null if not found, then you can throw out all the phys_to_virt()
calls.

Also, move the reserve_bootmem into the ibft_find routines and ensure
they're only called once on boot.  Refuse to attach the ibft driver if
the virtual pointer ibft is null.

James


