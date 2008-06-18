Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYFRTSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYFRTSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYFRTSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:18:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:32988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYFRTSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,667,1204531200"; 
   d="scan'208";a="343004691"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Strange problem with e1000 driver - ping packet loss
Date: Wed, 18 Jun 2008 12:18:30 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52056F2AC0@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080618125215.GC3988@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Strange problem with e1000 driver - ping packet loss
Thread-Index: AcjRQrd5OjgLPLLfS92B968WpqRRMgAHqOIA
References: <20080618125215.GC3988@linux.vnet.ibm.com>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: <vatsa@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
       <e1000-devel@lists.sourceforge.net>
Cc: <greg@kroah.com>, <varunc@linux.vnet.ibm.com>, <jbarnes@virtuousgeek.org>
X-OriginalArrivalTime: 18 Jun 2008 19:18:31.0049 (UTC) FILETIME=[1816D790:01C8D178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> Hi,
> 	I happened to look at a system which was exhibiting poor ping
> performance with e1000 driver (in 2.6.25) and had some questions
> regarding that. 
> ...

> Upon some investigation, I found that the interrupt count field in
> /proc/interrupts (associated with eth1) is not incrementing as fast as
> it should. Moreover eth1 interrupt line is shared with the hard disk
> interrupt (ata_piix) as below:
> 
> # cat /proc/interrupts
>  10:       2296    XT-PIC-XT        ata_piix, eth0, eth1

whats wrong with your system that you can't use acpi and/or apic?  It
would probably orthoginally solve the problem by unsharing your
interrupt.

> IRQ10 is thus being shared by both the hard disk and eth0/eth1.

bad for performance but should really work okay.
 
> Here's the strange observation I made:
> 
> When I initiate some disk activity (ex: dd if=/dev/zero
> ...

> This meant that e1000 NIC is having trouble interrupting the OS.

you're correct here, there appears to be some problem on your system
either with interrupt delivery or with the driver masking off interrupts
and leaving them disabled.
 
> Before I could jump up and say this is a hardware issue, I was told
> that Windows works just fine on the server (and as well as 2.4 kernel,
> which I couldnt verify) :(

well it might be a bios issue, but would likely be solved by using boot
option acpi=force and/or lapci (see kernel-parameters.txt

> Some more observations:
> 
> 1. I tried setting e1000 parameters (RxIntDelay=0, RxAbsIntDelay=0,
>    TxIntDelay=0, TxAbsIntDelay=0, InterruptThrottleRate=0). None of
>    them helped.

these won't help you get an interrupt delivered or re-enabled
 
> 2. When ping performance was poor, readprofile showed that system
>    is mostly idle. This confirms that OS is not getting very
>    frequenty interrupts from eth1 and hence idling.

expected, thanks for checking.

> 3. When ping performance was poor, ethtool -S eth1 showed that
>    rx_bytes was incrementing at a good pace, showing that the
>    NIC was receiving ping responses back, but not handing them over
>    to OS for further processing

also expected for an interrupt problem.
 
> 4. e1000 chipset is 82546GB
> 
> 5. e1000e driver didnt work at all (it doesnt recognize the cards).

expected, this is a PCI-X adapter.
 

> Any advice on how to fix this problem?

try the boot options first, then if that doesn't work for you, download
ethregs from e1000.sourceforge.net download area and compile/run it and
send me the output in private email.

if you have a spare moment, you can try the e1000-8.X driver from
sourceforge and let me know if it works okay, that would imply we just
need to patch the in-kernel driver to fix an already known issue.

Jesse
