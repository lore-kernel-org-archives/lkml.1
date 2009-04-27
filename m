Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZD0VAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZD0VAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZD0VAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:00:20 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:33503 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZD0VAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wszlnkM5OVWEStaW+gblCICZZJBUgtyzRkoB8qby/ieCRuelkxS+qO/qaEGj40jE+t
         XY5Rt0kuAPzj27PGZCynrQmA/w3bBztiszTNJ/DmF4R8Uy2flP8yOkiK2kU+psWPiq0e
         YMhqiv6bc2eOdTUHieN9pmQ3vJBgydiHLJw20=
MIME-Version: 1.0
In-Reply-To: <200904271439.37396.bjorn.helgaas@hp.com>
References: <49ED22EC.2040204@kernel.org>
	 <200904271344.04099.bjorn.helgaas@hp.com> <49F61265.10201@kernel.org>
	 <200904271439.37396.bjorn.helgaas@hp.com>
Date: Mon, 27 Apr 2009 14:00:16 -0700
Message-ID: <86802c440904271400q379da621ja808c96152c3fb8b@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 1:39 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

>>
>> other system may have broken _CRS.
>
> Do you have examples of problems here, or are you just worried that
> there *may* be problems?
one system with three chains... with pci=use_crs
[    9.365669] pci_bus 0000:00: resource 0 io:  [0x00-0x3af]
[    9.371065] pci_bus 0000:00: resource 1 io:  [0x3e0-0xcf7]
[    9.376551] pci_bus 0000:00: resource 2 io:  [0x3b0-0x3bb]
[    9.382028] pci_bus 0000:00: resource 3 io:  [0x3c0-0x3df]
[    9.387513] pci_bus 0000:00: resource 4 io:  [0xd00-0xefff]
[    9.393077] pci_bus 0000:00: resource 5 mem: [0x0a0000-0x0bffff]
[    9.399084] pci_bus 0000:00: resource 6 mem: [0x0d0000-0x0dffff]
[    9.405089] pci_bus 0000:00: resource 7 mem: [0xdd000000-0xdfffffff]
[    9.505332] pci_bus 0000:40: resource 0 io:  [0x5000-0x8fff]
[    9.510991] pci_bus 0000:40: resource 1 mem: [0xdb000000-0xdcffffff]
[    9.553378] pci_bus 0000:80: resource 0 io:  [0x1000-0x4fff]
[    9.559036] pci_bus 0000:80: resource 1 mem: [0xda000000-0xdaffffff]

without that: amd_bus.c will read that from pci conf space
[    9.310965] pci_bus 0000:00: resource 0 io:  [0x9000-0xefff]
[    9.316621] pci_bus 0000:00: resource 1 io:  [0x00-0xfff]
[    9.322020] pci_bus 0000:00: resource 2 mem: [0xdd000000-0xdfffffff]
[    9.328373] pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]
[    9.334378] pci_bus 0000:00: resource 4 mem: [0xc0000000-0xd9ffffff]
[    9.340731] pci_bus 0000:00: resource 5 mem: [0xf0000000-0xffffffff]
[    9.347084] pci_bus 0000:00: resource 6 mem: [0x840000000-0xfcffffffff]
[    9.444440] pci_bus 0000:40: resource 0 io:  [0x5000-0x8fff]
[    9.450099] pci_bus 0000:40: resource 1 io:  [0xf000-0xffff]
[    9.455757] pci_bus 0000:40: resource 2 mem: [0xdb000000-0xdcffffff]
[    9.498118] pci_bus 0000:80: resource 0 io:  [0x1000-0x4fff]
[    9.503777] pci_bus 0000:80: resource 1 mem: [0xda000000-0xdaffffff]

>
>> maybe we could try to use DMI whitelist them?
>
> I don't like a whitelist because it requires ongoing maintenance
> for correctly-working machines.  A blacklist is nicer because it
> only requires maintenance for *broken* machines.  A date-based
> solution would be better from that point of view.

could try apply that in development cycle like -rcX, and disable that
formal release.
so could find more broken system.

YH
