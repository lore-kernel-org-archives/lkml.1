Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbZHDBwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbZHDBwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZHDBwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:52:03 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60128 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZHDBwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:52:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19063.37940.634.400042@cargo.ozlabs.ibm.com>
Date: Tue, 4 Aug 2009 11:51:47 +1000
From: Paul Mackerras <paulus@samba.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86: Make 64-bit efi_ioremap use ioremap on
 MMIO regions
In-Reply-To: <1249348807.24238.24.camel@yhuang-dev.sh.intel.com>
References: <19062.55858.533494.471153@cargo.ozlabs.ibm.com>
	<tip-19157af82cf0575032386f60378527904dbb7b8f@git.kernel.org>
	<1249348807.24238.24.camel@yhuang-dev.sh.intel.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying writes:

> This patch does not really fix the issue. __cpa_process_fault will warn
> if target memory area is beyond max_pfn_mapped. EFI runtime RAM area
> beyond max_pfn_mapped will trigger the warning too.

I think we already have that situation on that MacBook, and there is
no warning.  From dmesg:

[    0.000000] EFI: mem190: type=9, attr=0xf, range=[0x000000007fedf000-0x000000007feef000) (0MB)
[    0.000000] EFI: mem191: type=7, attr=0xf, range=[0x000000007feef000-0x000000007fef9000) (0MB)
[    0.000000] EFI: mem192: type=0, attr=0xf, range=[0x000000007fef9000-0x000000007feff000) (0MB)
[    0.000000] EFI: mem193: type=6, attr=0x800000000000000f, range=[0x000000007feff000-0x000000007ff00000) (0MB)
...
[    0.000000] last_pfn = 0x7fef9 max_arch_pfn = 0x400000000
...
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007fef9000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fef9000 page 4k
[    0.000000] kernel direct mapping tables up to 7fef9000 @ 8000-c000
...
[    0.001920] init_memory_mapping: 000000007feff000-000000007ff00000
[    0.001926]  007feff000 - 007ff00000 page 4k

So the initial mapping ends at 0x7fef9000, and I believe that
max_pfn_mapped is 0x7fef9, and then EFI asks for pfn 0x7feff to be
mapped.  But I freely admit this is not my area of expertise.  This
machine has 2GB of RAM, by the way.

> To fix the issue. I think we can loose the restriction of
> __cpa_process_fault a little. Add a global variable max_pfn, which is
> max pfn of all memory type (including RAM, RESERVED, etc, mapped or
> unmapped), and __cpa_process_fault warns for memory area beyond max_pfn
> only.

It seemed cleaner to me to use ioremap() on areas that we are told are
MMIO.  Why would it be better to use init_memory_mapping for those
areas?

Paul.
