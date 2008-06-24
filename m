Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYFXFq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYFXFq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYFXFqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:46:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYFXFqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:46:48 -0400
Message-ID: <48608A11.8070605@zytor.com>
Date: Mon, 23 Jun 2008 22:45:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, andi@firstfloor.org,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
 via linked list of setup data
References: <1213155219.13392.2.camel@caritas-dev.intel.com>	 <20080618114511.GB28838@elte.hu>	 <1214200441.25753.5.camel@caritas-dev.intel.com>	 <20080623015326.bec9a75d.pj@sgi.com>	 <1214205686.26437.18.camel@caritas-dev.intel.com>	 <20080623034728.250c6fd1.pj@sgi.com>	 <1214212441.27182.4.camel@caritas-dev.intel.com>	 <20080623044813.d2fee3a0.pj@sgi.com> <1214269774.31773.13.camel@caritas-dev.intel.com>
In-Reply-To: <1214269774.31773.13.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> On Mon, 2008-06-23 at 04:48 -0500, Paul Jackson wrote:
>> Huang wrote:
>>> 4. Current EFI memmap based code does not work properly in all
>>> situation, for example it can not works with kernel parameter:
>>> "memmap=exactmap, memmap=<xxx>, ...", "mem=<xxx>" or "noefi".
>> With "noefi" parameter, my EFI memmap based code is not supposed
>> to do anything.  The "noefi" parameter asks the kernel to ignore
>> any EFI support in the firmware it is booting from.
> 
> "noefi" is used to specify that the EFI runtime services should be
> disabled in kernel. But the memmap should be complete.
> 
>> Could you tell me more what you mean by "does not work properly?"
> 
> OK. It is OK for your code with "noefi". The remaining issues:
> 
> If "memmap=exactmap memmap=<xxx>" is specified in kernel command line.
> The user defined memmap should override that from firmware. But your
> code is executed after the user defined memmap is parsed, so the memmap
> from firmware will override that from user. This does not conform the
> semantics of "memmap=exactmap ...". Same issue for "mem=<xxx>".
> 
> Another issue is that the size of E820 memmap required on EFI system
> must be two times bigger than that really needed. Because at first the
> E820 memmap is filled with the entries from E820 and E820_EXT, then that
> from EFI memmap is appended.
> 

Hello,

I discussed this with Ingo earlier today, and we came to the following 
conclusion:

1. The EFI memmap code as a backup to the bootloader is fine.
2. Ying's memmap= objection needs to be addressed.  Violating user 
overrides is not appropriate.
3. It is important that we don't override the bootloader when the 
bootloader really does know best.  For example, kexec may want to 
control exactly what memory the target kernel uses.  As a result, we 
need a flag somewhere to disable *any* attempts at obtaining memory 
information from the environment, be it EFI, OpenFirmware or what have 
you.  The easiest way to do this is probably via a command-line flag, 
e.g. "noauxmem".

What do you guys think?

	-hpa
