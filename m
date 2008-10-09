Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYJIBSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYJIBSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYJIBSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:18:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:9863 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJIBSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PWu9vuFY5jovzbJtOL2Cne2fi4ETNsYgbehz/ppvl8pVEPbBc26W/UXqfy6f5NPnMJ
         tNWlATgyjeFLv3KhoEtX4ydakzSI2DfMKAT/eF7Kf1PHZGEzRBR+ZOzDT9Rl5qAdMHXX
         DZPi8VdAzqBrcDseTwyeADi3ltHflFUAbLtMg=
Subject: Re: [PATCH 1/4] h8300: Change unaligned access to use packed
 struct implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>
In-Reply-To: <20081008140214.GC2739@x200.localdomain>
References: <1223447903.8195.65.camel@brick>
	 <20081008140214.GC2739@x200.localdomain>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 18:18:11 -0700
Message-Id: <1223515092.8195.136.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 18:02 +0400, Alexey Dobriyan wrote:
> On Tue, Oct 07, 2008 at 11:38:22PM -0700, Harvey Harrison wrote:
> > There are only 3 arches that use the memmove-based implementation, there
> > doesn't seem to be any obvious reason not to use the struct implementation.
> 
> 1. Extensive use of "--- " area means changelogs are written badly.
> 2. Changing one of arch core header we can deduce from patch and this
>    exactly what subject line says.
> 3. As such there is absolutely no changelog.
> 
> [goes into digging how all this byteorder and endian activity was
> started]

It started by introducing the unaligned endian helper functions such as
get_unaligned_le16 to replace the repeated pattern of
u16 foo = le16_to_cpu(get_unaligned(some_le16 *));

and put_unaligned_le16 to replace the pattern of
put_unaligned(cpu_to_le16(some_u16), some_le16 *)

To do this I first consolidated the various unaligned implementations that
were in the kernel, which fell into the following:

1) Unaligned access was OK
2) Access values through a packed-struct (inspired by ia64 first I think)
3) Open-coded C byteshifting version (inspired by ARM)
4) memcpy/memmove based
5) FRV had a custom

So I collected them into a common include/linux/unaligned/ folder and moved
the arches to pull the implementation from there, with no behavioral changes,
except for FRV which lost its assembly version as the C (3) version produced
better code.

SO of the 4 remaining implementations, we have the following:

1) Unaligned Access-ok
Cris,m68k,mn10300,x86,m68knommu (non-coldfire),powerpc,s390

2) Struct-based
Alpha,AVR32,Mips,parisc,blackfin,ia64,m68knommu (coldfire),sh,sparc,sparc64

3) Open-coded byteshifting for both native and opposite endianness
Arm,FRV

4) memmove-based
xtensa,m32r,h8300

This series should have had an RFC on the front as I'm really just asking the maintainers
of these arches if they could move to the packed-struct versions, or if they had a particlar
need for the memmove version (toolchain, code generation, etc.)

In addition I'm also investigating moving FRV and ARM to use the packed-sruct version and if
so the whole unaligned/ folder could just become a single implementation in asm-generic
making it easier to change some of the unaligned access/byteorder functions _if_ needed.

As it stands the proposal I was going to make looked somewhat like the following:

Introduce the api:
load_le16(const __le16 *)
store_le16(__le16 *, u16)
load_unaligned_le16(const __le16 *)
store_unaligned_le16(__le16 *, u16)

load_le16() is a duplicate of the existing le16_to_cpup, all of which would
be replaced by the new api and the pointer variant removed.  All of the existing
users of cpu_to_le16p would also be removed as there are a trivial number of users
and many of them would be more efficient if they just used the value-based endian
helpers directly.

store_le16 is new-API and would replace a few private helpers that exist already in
the kernel.

The get_unaligned/put_unaligned API would then be transitioned to the load/store
variants, which are no different in the get/load case, and have opposite argument
ordering in the put/store case.


This would leave the endian helpers looking like:

cpu_to_le16
le16_to_cpu
cpu_to_le16s
le16_to_cpus
load_le16
store_le16
load_unaligned_le16
store_unaligned_le16

Notice that cpu_to_le16p, le16_to_cpup are gone.

Hope that helps with the larger picture.

Cheers,

Harvey

