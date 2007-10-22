Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXJVSmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXJVSmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbXJVSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:42:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbXJVSml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:42:41 -0400
Message-ID: <471CEEFA.60001@zytor.com>
Date: Mon, 22 Oct 2007 11:42:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v6 0/3] x86 boot: 32-bit boot protocol
References: <1193037408.23935.21.camel@caritas-dev.intel.com>
In-Reply-To: <1193037408.23935.21.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patchset defines a 32-bit boot protocol for x86 platform,
> adds an extensible boot parameter passing mechanism, export the boot
> parameters via sysfs.
> 
> The patchset has been tested against kernel of git version
> v2.6.23-6623-g55b70a0 on x86_64 and i386.
> 

Hi Huang,

This patchset should be rebased on top of Rusty's changes; the rebase is 
  fairly trivial and I was originally intending to simply commit the 
rebase as-is, with the boot protocol version bumped to 2.08.

However, the documentation section is simply wrong in a number of 
places.  In particular:

+In 32-bit boot protocol, the first step in loading a Linux kernel
+should still be to load the real-mode code and then examine the kernel
+header at offset 0x01f1. But, it is not necessary to load all
+real-mode code, just first 4K bytes traditionally known as "zero page"
+is needed.

This is incorrect.  The zeropage (which really is better referred to as 
struct boot_param) should be initialized to all zero, except for the 
setup header (starting at offset 0x1f0 or 0x1f1(*)) to the length 
specified either by boot protocol version or by the byte at offset 0x201.

+At entry, the CPU must be in 32-bit protected mode with paging
+disabled; the CS and DS must be 4G flat segments; %esi holds the base
+address of the "zero page"; %esp, %ebp, %edi should be zero.

You also need to have a GDT loaded with the selectors for __BOOT_CS 
(0x10) and __BOOT_DS (0x18) containing appropriate values, and you 
should enter with interrupts disabled.  For safety, set up ES and SS as 
well as DS.

The bit about %esp, %ebp and %edi being zero is nonsense, although 
specifying at least %ebp == %edi == 0 for future use isn't a bad idea. 
On the other hand, %ebx *is* supposed to be zero.

The documentation in zero-page.txt is wrong when it comes to protocol 
versions.  Most of these fields are ancient, and only a handful of the 
remainder can be tied to specific protocol versions.

+  struct setup_data {
+	  u64 next;
+	  u32 type;
+	  u32 len;
+	  u8  data[0];
+  } __attribute__((packed));

Why packed?

Time permitting, I might rewrite this myself, but it may be quicker for 
you to update it.

	-hpa

