Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbXHUBoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbXHUBoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 21:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXHUBoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 21:44:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:29117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXHUBoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 21:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,286,1183359600"; 
   d="scan'208";a="285552653"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
In-Reply-To: <46C9CB89.7020603@zytor.com>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815154245.500c572c.akpm@linux-foundation.org>
	 <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de>
	 <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <46C5C8C4.4060407@zytor.com>
	 <1187580031.27947.67.camel@caritas-dev.intel.com>
	 <46C9CB89.7020603@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Aug 2007 09:44:49 +0800
Message-Id: <1187660689.20920.27.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 21 Aug 2007 01:44:10.0153 (UTC) FILETIME=[C4E7A990:01C7E394]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 10:12 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> >>
> >> I propose that, in addition to the aforementioned version number and
> >> magic fields, we add a pointer, which should be the last pointer added
> >> that doesn't point into I/O space or reserved memory (i.e. memory that
> >> is off limit anyway for the operating system.)
> >>
> >> This pointer should point to a linked list of suggested form:
> >>
> >> struct setup_data {
> >> 	u64 next;
> >> 	u32 type;
> >> 	u32 len;
> >> 	u8 data[];
> >> };
> >>

I think the "next" field can be u32 instead of u64. Because the linked
list of struct setup_data is prepared by bootloader, which can control
the memory location.

To facilitate the kernel early mapping, I think the memory location of
"linked list" should be kept to a predefined range (in the real mode
memory area?).

> > So, we need not define a new boot protocol, just extend the standard
> > boot protocol. The version number and magic need not to be added to
> > "zero page". But, at the same time, the bootloader on EFI, LinuxBIOS and
> > kexec must be changed accordingly.
> > 
> 
> I think this is too radical of a change to be practical.  Instead, I
> propose the following:
> 
> - "struct boot_params" (the zeropage) is kept as a legacy interface.
> %esi will continue to point to it on entry to the 32-bit entrypoint
> (presumably that is %rsi on entry to a 64-bit entrypoint?)
> 
> - We add a magic number and a pointer chain to the zeropage.  The
> presence of the magic number indicates that:
> 
> 	- Any unused fields in the zeropage is zero;
> 	- The pointer chain is valid (unless zero);
> 	- The old "HD info" fields (and possibly the EDD fields)
> 	  can be recycled.

Previously, I think the "zero page" is not external formally, so we can
ignore the user. But it is used by some bootloaders. So your proposal
may be better, especially for these bootloaders.

I think something others need to be done:

- Increase the version number of standard boot protocol.
- Add the contents of zero page into standard boot protocol document as
a optional part for 32-bit entry (and 64-bit entry?).
- Make 32-bit (64-bit?) boot protocol formal in standard boot protocol
document.

> What a post-upgrade kernel should do upon encountering an old structure
> (sans magic) is to zero out any fields that wasn't present in the legacy
> structure definition, including the pointer chain, then it can use it as-is.

As for the magic number in zero page, do you think it should be used
only by 16-bit kernel setup code?

> We should avoid adding fields to the zero_page after that, unless
> necessary for backwards compatibility reasons.  In general, new data
> items should be added as pointer capabilities.

Yes.

> Compare this to the legacy PCI header vs. PCI capabilities.

Best Regards,
Huang Ying
