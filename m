Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXDHKmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXDHKmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 06:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXDHKmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 06:42:36 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2425 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXDHKmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 06:42:35 -0400
Date: Sun, 8 Apr 2007 11:42:25 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] partitions: Changes to fs/partitions for readability and efficiency
Message-ID: <20070408104225.GB5431@flint.arm.linux.org.uk>
Mail-Followup-To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, aeb@cwi.nl,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 11:33:06PM -0400, John Anthony Kazos Jr. wrote:
> In addition to the Kconfig help text patch I submitted earlier, this is a 
> set of patches to touch up the partition handling files and also to change 
> the "array of function pointers" algorithm of the main checking function 
> to "list of calls to possible stub functions" to better fit in with the 
> rest of the kernel code, to reduce memory usage by a few dozen bytes, and 
> to generally be easier (in my opinion) to understand.

I'm not convinced.  Let's dispell the myth that this reduces memory usage.
Two configurations used (see below for their details):

[1]:
   text    data     bss     dec     hex filename
  10868     268       0   11136    2b80 unpatched/fs/partitions/built-in.o
  11260     228       0   11488    2ce0 patched/fs/partitions/built-in.o

[2]:
   7336     248       0    7584    1da0 unpatched/fs/partitions/built-in.o
   7668     228       0    7896    1ed8 patched/fs/partitions/built-in.o


It quite clearly has an average 330-ish byte cost increase rather than a
reduction.  That's quite obvious since instead of interating over data,
we're linearly executing effectively unrolled code which just repeats the
same operations time and time again, the only difference being that you're
calling some other function.

I'm also unconvinced that an array of function pointers is any harder to
read than open coding a list of calls.  In terms of clutter I'd say the
latter was worse.

Finally note that the following fix has been committed to mainline,
which requires the corresponding fix in your patch.  See commit ID
9bebff6ca5871e07b665cdaf71028ea21eb0bf0e for the full info.

-	if (!err)
+       if (err)
        /* The partition is unrecognized. So report I/O errors if there were any */
                res = err;

Configs used:

[1]:
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set

[2]:
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
