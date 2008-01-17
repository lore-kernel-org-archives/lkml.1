Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYAQTVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYAQTVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYAQTV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:21:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:23910 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYAQTV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:21:26 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.24-rc8-mm1
Date: Thu, 17 Jan 2008 11:22:19 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5E909A@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080117104021.25a8e562.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.24-rc8-mm1
Thread-Index: AchZOGu4DqZO84g+TRWr0K7agkpjEgABQe5w
References: <20080117023514.9df393cf.akpm@linux-foundation.org><20080117124622.GA18450@balbir.in.ibm.com> <20080117104021.25a8e562.akpm@linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, <balbir@linux.vnet.ibm.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linux ACPI mailing list" <linux-acpi@vger.kernel.org>,
       "Intel E/100 mailing list" <e1000-devel@lists.sourceforge.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 17 Jan 2008 19:21:22.0505 (UTC) FILETIME=[25153390:01C8593E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Thursday, January 17, 2008 10:40 AM
>To: balbir@linux.vnet.ibm.com
>Cc: linux-kernel@vger.kernel.org; Linux ACPI mailing list; 
>Intel E/100 mailing list; Ingo Molnar; Thomas Gleixner; 
>Pallipadi, Venkatesh
>Subject: Re: 2.6.24-rc8-mm1
>
>On Thu, 17 Jan 2008 18:16:22 +0530 Balbir Singh 
><balbir@linux.vnet.ibm.com> wrote:
>
>> * Andrew Morton <akpm@linux-foundation.org> [2008-01-17 02:35:14]:
>> 
>> > 
>> > 
>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2
>.6.24-rc8/2.6.24-rc8-mm1/
>> > 
>> > - selinux is busted on one of my two selinux-enabled test machines.
>> > 
>> > - suspend-to-ram and suspend-to-disk are totally hosed on 
>one of my test
>> >   machines.  I guess I get to bisect this.
>> > 
>> > - git-nfsd is dropped due to conflicts with git-nfs
>> > 
>> > - git-newsetup is dropped due to conflicts with git-x86 (I think)
>> > 
>> > - git-perfmon is dropped due to conflicts with git-x86 (I think)
>> > 
>> > - git-kgdb is dropped due to conflicts with 
>git-damn-near-everything
>> > 
>> > - git-block is dropped due to conflicts with the IDE tree
>> > 
>> > - kvm probably doesn't work properly because I couldn't be 
>bothered fixing
>> >   the conflicts between git-kvm and the driver tree
>> > 
>> > - the volume of rejects and build errors which are caused 
>by subsystem
>> >   maintainers fiddling with other people's stuff is quite 
>out of control. 
>> >   Something needs to happen here.
>> 
>> Hi, Andrew,
>> 
>> May be it was one of the conflicts, but my system fails to get
>> ethernet working with this version. I see
>> 
>> e100: Intel(R) PRO/100 Network Driver, 3. 5.23-k4-NAPI
>> e100: Copyright(c) 1999-2006 Intel Corporation
>> ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 20 (level, low) -> IRQ 20
>> modprobe:2584 conflicting cache attribute 50000000-50001000
>> uncached<->default
>> e100: 0000:04:08.0: e100_probe: Cannot map device registers, 
>aborting.
>> ACPI: PCI interrupt for device 0000:04:08.0 disabled
>> e100: probe of 0000:04:08.0 failed with error -12
>> 
>It appears that the new PAT code didn't like e100's 
>pci_iomap().  Venki, can you
>take a look please?
>

This seems similar to one problem we saw yday. May not be specific to
e1000. May be at some generic pci code.

The problem is
>> modprobe:2584 conflicting cache attribute 50000000-50001000
>> uncached<->default

Some address range here is being mapped with conflicting types.
Somewhere the range was mapped with default (write-back). Later
pci_iomap() is mapping that region as uncacheable which is basically
aliasing. PAT code detects the aliasing and fails the second uncacheable
request which leads in the failure.

We are trying to find who exactly is mapping this with default at the
beginning.
Balbir: Full dmesg with debug boot parameter may help.

Thanks,
Venki
