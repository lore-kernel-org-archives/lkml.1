Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZEHFfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZEHFfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZEHFff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:35:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZEHFfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:35:34 -0400
Message-ID: <4A03C3BB.3070401@intel.com>
Date: Thu, 07 May 2009 22:31:39 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       sam@ravnborg.org
Subject: Re: [PATCH 00/14] RFC: x86: relocatable kernel changes
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <m14ovwz8ua.fsf@fess.ebiederm.org>
In-Reply-To: <m14ovwz8ua.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Peter do you plan to update pxelinux or other bootloaders to use the
> relocatable kernel feature?

Yes.

> The direction of this patch seems reasonable.  The details are broken.
> The common case for relocatable kernels today is kdump.  A situation
> with very minimal memory.  In that situation the kernel needs to run
> where we put it, modifying the kernel to not run where it gets put
> is a problem.

I thought in the kdump case you typically loaded it pretty high?  Either
which way, kdump is always loaded by kexec, so it should just be a
matter of updating kexec to zero the runtime_start field, no?  Basically
this is the bootloader saying "do what I say, dammit."  Since the
existing protocol doesn't have a way to unambiguously communicate one
direction versus another (see below), it seems like a relatively small
issue involving only one tool.  Suboptimal, yes.

> With the code as it is today you can get the exact same behavior
> by simply bumping up the minimum alignment to 16MB, and a lot less code
> and no changes needed to any bootloaders.
> 
> Is your goal to setup a scenario where on small memory systems a bootloader
> like pxelinux can support a relocatable kernel and load it a lower
> address?  If so that seems reasonable.

Yes.

> With that said how about we change the logic to:
> 
> if (load_addr == legacy_load_addr) /* 0x100000 */
> 	use config_physical_start
> else if aligned
> 	noop
> else
>         /* Crap this is bad align the kernel and hope something works. */
> 
> That gets the desired behavior we override bootloaders that are not
> smart and taking relocation into account.  I am really not comfortable
> with having code that will override a bootloader doing something
> reasonable.

I'm not sure that is quite right either, because if alignment is
configured to be 1 MB or less then 1 MB is a perfectly legitimate
address for a relocating bootloader to want to use, even if it is not
configured in.  It would be more than a bit odd to not have that be
permitted.

> I expect we will still want to update kexec to be able to take
> advantage of loadtime_size (runtime_size seems like the wrong name).

Well, it is the amount of memory the kernel needs during runtime (as
opposed to during loading.)  I admit it's not an ideal name, though.  On
the other hand, simply calling it kernel_start and kernel_size seemed
ambiguous.

	-hpa

