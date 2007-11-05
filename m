Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbXKEUuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbXKEUuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXKEUuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:50:01 -0500
Received: from gw.goop.org ([64.81.55.164]:36010 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXKEUuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:50:00 -0500
Message-ID: <472F81D9.6040205@goop.org>
Date: Mon, 05 Nov 2007 12:49:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86 boot: document for 32 bit boot protocol
References: <1193192329.23935.121.camel@caritas-dev.intel.com>
In-Reply-To: <1193192329.23935.121.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch documents the 32-bit boot protocol of x86. It has been used
> by Kexec and LinuxBIOS. This patch is based on the proposal of Peter
> Anvin.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
>
> v2:
>
> - Fixes a bug about which registers should be set to zero.
>
>
> ---
>
>  boot.txt      |   38 ++++++++++++++++
>  zero-page.txt |  130 +++++++++++++---------------------------------------------
>  2 files changed, 69 insertions(+), 99 deletions(-)
>
> Index: linux-2.6/Documentation/i386/boot.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/i386/boot.txt	2007-10-24 09:21:57.000000000 +0800
> +++ linux-2.6/Documentation/i386/boot.txt	2007-10-24 10:01:42.000000000 +0800
> @@ -785,3 +785,41 @@
>  	After completing your hook, you should jump to the address
>  	that was in this field before your boot loader overwrote it
>  	(relocated, if appropriate.)
> +
> +
> +**** 32-bit BOOT PROTOCOL
> +
> +For machine with some new BIOS other than legacy BIOS, such as EFI,
> +LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
> +based on legacy BIOS can not be used, so a 32-bit boot protocol needs
> +to be defined.
> +
> +In 32-bit boot protocol, the first step in loading a Linux kernel
> +should be to setup the boot parameters (struct boot_params,
> +traditionally known as "zero page"). The memory for struct boot_params
> +should be allocated and initialized to all zero. Then the setup header
> +from offset 0x01f1 of kernel image on should be loaded into struct
> +boot_params and examined. The end of setup header can be calculated as
> +follow:
> +
> +	0x0202 + byte value at offset 0x0201
> +
> +In addition to read/modify/write the setup header of the struct
> +boot_params as that of 16-bit boot protocol, the boot loader should
> +also fill the additional fields of the struct boot_params as that
> +described in zero-page.txt.
> +
> +After setupping the struct boot_params, the boot loader can load the
> +32/64-bit kernel in the same way as that of 16-bit boot protocol.
> +
> +In 32-bit boot protocol, the kernel is started by jumping to the
> +32-bit kernel entry point, which is the start address of loaded
> +32/64-bit kernel.
> +
> +At entry, the CPU must be in 32-bit protected mode with paging
> +disabled; a GDT must be loaded with the descriptors for selectors
> +__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
> +segment; __BOOS_CS must have execute/read permission, and __BOOT_DS
> +must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
> +must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
> +address of the struct boot_params; %ebp, %edi and %ebx must be zero.
>   

I'm sorry I missed this when it was posted.

Unfortunately this protocol doesn't suit booting paravirtualized under
Xen.  There are two problems:

   1. Xen will always boot with paging enabled; it's simply not possible
      to do otherwise, since it uses paging to protect guests from each
      other.  This would need to be amended to allow paging to be
      enabled, with an initial default pagetable.  Presumably an
      identity mapping pagetable would be preferred, but the question of
      how much to map comes up, and where the pagetable lives in the
      kernel's address space.
   2. Also, Xen reserves the last chunk of the GDT for its own
      descriptors, and by default boots the guest with the segment
      registers preloaded with selectors pointing to flat 4G descriptors
      in this range.  These segments are not a full 4G, since it uses
      segment limits to protect the hypervisor from guests.  The limits
      are as large as they can possibly be.  I like to see the boot
      protocol require that all segments registers are preloaded with
      large flat 32-bit descriptors, but not require a specific selector
      value.  I'd happy to require the GDT to be active, so the segment
      registers can be reloaded with their current values, until the
      kernel establishes its own GDT.


    J
