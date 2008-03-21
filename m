Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbYCUSAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbYCUSAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYCUR7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:59:49 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:37903 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbYCUR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:59:48 -0400
Date: Fri, 21 Mar 2008 10:59:27 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: Re: [patch 1/4] x86: vSMP: Fix is_vsmp_box()
Message-ID: <20080321175927.GC6085@localdomain>
References: <20080320073740.GA9414@localdomain> <20080320073902.GB9414@localdomain> <86802c440803200044g54617517k4530db76ebe2cabb@mail.gmail.com> <20080320184045.GA6085@localdomain> <20080321091139.GD20420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321091139.GD20420@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 10:11:39AM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> >>         /* Check if we are running on a ScaleMP vSMP box */
>> >>  -       if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
>> >>  -            (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
>> >>  +       if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
>> >>  +            PCI_VENDOR_ID_SCALEMP) &&
>> >>  +           (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
>> >>  +           PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
>> >>                 vsmp = 1;
>> >>
>> >>         return vsmp;
>> >
>> >why read two times
>> >
>> 
>> Well, the pci cfg space read happens just _once_ during the boot, as 
>> the result is cached in a static flag. The above code is better 
>> readable. So readability is better than micro-optimization here.
>
>i think the patch below results in even more readable and a bit smaller 
>
>code got a bit smaller:
>
>arch/x86/kernel/vsmp_64.o:
>
>   text	   data	    bss	    dec	    hex	filename
>    205	      4	      0	    209	     d1	vsmp_64.o.before
>    181	      4	      0	    185	     b9	vsmp_64.o.after

Wow!  good to know that avoiding one call shaved so many bytes.
Agreed, the below patch is  better.

Thanks,
Kiran

>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>
>---
> arch/x86/kernel/vsmp_64.c |    6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>
>Index: linux-x86.q/arch/x86/kernel/vsmp_64.c
>===================================================================
>--- linux-x86.q.orig/arch/x86/kernel/vsmp_64.c
>+++ linux-x86.q/arch/x86/kernel/vsmp_64.c
>@@ -120,10 +120,8 @@ int is_vsmp_box(void)
> 		return vsmp;
> 
> 	/* Check if we are running on a ScaleMP vSMP box */
>-	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
>-	     PCI_VENDOR_ID_SCALEMP) &&
>-	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
>-	    PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
>+	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
>+	     (PCI_VENDOR_ID_SCALEMP | (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
> 		vsmp = 1;
> 
> 	return vsmp;
