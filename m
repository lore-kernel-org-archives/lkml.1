Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYCUJSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYCUJSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYCUJSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:18:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:52921 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYCUJSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AM+bN1zC7e7LJFHnaqh+5wkyTfZA64MP31moZ4GgE1z0lgKv2xaei8f26Bw4NN5N0Bwtqu8kNO31yqkga+BTDtm1pNxM+02/rXokywvpmAe5r80EjjFyKPGmBdeUYOaG+zRKW0V8aBHaFMqNH2T/eTdT1JnkBqLLuovOCfyDG/s=
Message-ID: <86802c440803210217p2793195bj989be0b25017414@mail.gmail.com>
Date: Fri, 21 Mar 2008 02:17:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: vSMP: Fix is_vsmp_box()
Cc: "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       "Andi Kleen" <ak@suse.de>, shai@scalex86.org
In-Reply-To: <20080321091139.GD20420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080320073740.GA9414@localdomain>
	 <20080320073902.GB9414@localdomain>
	 <86802c440803200044g54617517k4530db76ebe2cabb@mail.gmail.com>
	 <20080320184045.GA6085@localdomain> <20080321091139.GD20420@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 2:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>
> > >>         /* Check if we are running on a ScaleMP vSMP box */
>  > >>  -       if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
>  > >>  -            (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
>  > >>  +       if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
>  > >>  +            PCI_VENDOR_ID_SCALEMP) &&
>  > >>  +           (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
>  > >>  +           PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
>  > >>                 vsmp = 1;
>  > >>
>  > >>         return vsmp;
>  > >
>  > >why read two times
>  > >
>  >
>  > Well, the pci cfg space read happens just _once_ during the boot, as
>  > the result is cached in a static flag. The above code is better
>  > readable. So readability is better than micro-optimization here.
>
>  i think the patch below results in even more readable and a bit smaller
>  code - because it's such a simple check?
>
>  OTOH, you are right in general, for example in mmconf-fam10h_64.c's
>  get_fam10h_pci_mmconf_base() function, we do this:
>
>                 id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
>
>                 vendor = id & 0xffff;
>                 device = (id>>16) & 0xffff;
>                 if (pci_probes[i].vendor == vendor &&
>                     pci_probes[i].device == device) {
>
>  here it would indeed be cleaner to simply do:
>
>                 vendor = read_pci_config_16(bus, slot, 0, PCI_VENDOR_ID);
>                 device = read_pci_config_16(bus, slot, 0, PCI_DEVICE_ID);
>
>  instead of open-coding the 16-bit splitting.
>
>         Ingo
>
>  ------------>
>  Subject: x86: vsmp fix x86 vsmp fix is vsmp box cleanup
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Fri Mar 21 09:55:06 CET 2008
>
>  code got a bit smaller:
>
>  arch/x86/kernel/vsmp_64.o:
>
>    text    data     bss     dec     hex filename
>     205       4       0     209      d1 vsmp_64.o.before
>     181       4       0     185      b9 vsmp_64.o.after

good evidence.

YH
