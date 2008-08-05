Return-Path: <linux-kernel-owner+w=401wt.eu-S1763609AbYHEHMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763609AbYHEHMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760553AbYHEHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:07:22 -0400
Received: from gw-d.mimosa.com ([209.161.207.149]:46805 "EHLO gw-d.mimosa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193AbYHEHHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:07:18 -0400
X-Greylist: delayed 1573 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 03:07:18 EDT
Date: Tue, 5 Aug 2008 02:41:00 -0400 (EDT)
From: "D. Hugh Redelmeier" <hugh@mimosa.com>
Reply-To: "D. Hugh Redelmeier" <hugh@mimosa.com>
To: linux-kernel@vger.kernel.org
Subject: MTRR ioctl interface hides MTRRs extending above 4G
Message-ID: <alpine.LRH.1.10.0808031813260.27764@redclaw.mimosa.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MTRR interface is (incompletely) described in Documentation/x86/mtrr.txt
and include/asm-x86/mtrr.h.  (Is it documented anywhere else?)

On my desktop machine, a couple of MTRRs are initialized with sizes
larger than 4G.  Here is what /proc/mtrr shows:

    reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
    reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
    reg02: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
    reg03: base=0x100000000 (4096MB), size=2048MB: write-back, count=1
    reg04: base=0x180000000 (6144MB), size= 512MB: write-back, count=1
    reg05: base=0x1a0000000 (6656MB), size= 256MB: write-back, count=1

Documentation/x86/mtrr.txt has a sample program mtrr-show.c that uses
the ioctl interface to get the MTRR settings and display them.  Here
is its output:
    Register: 0 base: 0xd0000000 size: 0x10000000 type: uncachable
    Register: 1 base: 0xe0000000 size: 0x20000000 type: uncachable
    Register: 2 disabled
    Register: 3 disabled
    Register: 4 disabled
    Register: 5 disabled
    Register: 6 disabled
    Register: 7 disabled

This is clearly wrong.

Why does this happen?

The implementation of MTRRIOC_GET_ENTRY in iarch/x86/kernel/cpu/mtrr/if.c
has a comment:
                /* Hide entries that go above 4GB */
This seems quite misguided.  It certainly isn't described in the
documentation that I've seen.


It turns out the mtrr values are transferred between the kernel and
userland in struct mtrr_gentry defined in include/asm-x86/mtrr.h.

Unfortunately, the struct field "size" is defined to be an unsigned
int.  This is not wide enough to represent all possible values.  It
doesn't even match the sample code in mtrr.txt: size values are
converted from text using strtoul and printed using format %lx.

But the member "base" is unsigned long and so is large enough (on
x86_64).  (Note: there are separate definitions of this structure for
__i386__ and for !__i386__ (x86_66, I assume).  But both define these
fields with the same types.)

So there are several problems:

1) .size is not large enough to hold the values it must

2) .base is not large enough on __i386__ to hold the values it must

3) the code hides entries that extend beyond 4G, even if they could be
   represented

4) the type of .size in mtrr.h does not match the type implied by
   sample code in Documentation/x86/mtrr.txt.  The sample code
   formats .size values with %lx and decodes text representations
   using strtoul(3), so the type should be unsigned long.

What are the practical consequences of these problems?

I stumbled upon this problem because I was trying to write a program
to manipulate MTRRs, but perhaps my application doesn't count.  (My
motivation is that the X server doesn't work on my machine due to MTRR
issues.)

I think that the main (only?) user of this interface is the X server,
including its drivers.  X wants to change the type of the memory
aperture of the video interface.

Are there any other uses?

If X is the only important user of the interface, and it more or less
works with the broken interface, then maybe the problem doesn't matter
a lot.  Apertures seem to be below 4G.  I'm not sure that it does
work - it fails on my machine.



What is to be done?  Here are a bunch of possible fixes, with pluses
and minuses that I can think of.  Not all are mutually exclusive.

a) Document the status quo

+ can cause no new failures.  Makes the kernel honest.

- the ioctl interface remains inadequate, at least in theory.


b) Fix problem (3)

+ very easy

+ I would guess that this would break no currently working programs,
  but I cannot be sure.

- not much of a step forward

--- arch/x86/kernel/cpu/mtrr/if.c	2008-07-29 17:48:19.000000000 -0400
+++ arch/x86/kernel/cpu/mtrr/if.c.new	2008-08-03 22:45:02.000000000 -0400
@@ -248,8 +248,8 @@
 			return -EINVAL;
 		mtrr_if->get(gentry.regnum, &gentry.base, &size, &type);
 
-		/* Hide entries that go above 4GB */
-		if (gentry.base + size - 1 >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT))
+		/* Hide entries that cannot be represented. */
+		if (gentry.base >= (1UL << (8 * sizeof(gentry.base) - PAGE_SHIFT))
 		    || size >= (1UL << (8 * sizeof(gentry.size) - PAGE_SHIFT)))
 			gentry.base = gentry.size = gentry.type = 0;
 		else {


c) fix the ioctl code to report failure when it cannot report MTRR
   values: EOVERFLOW or ERANGE (I don't know which is appropriate)

+ honest

- might confuse existing code


c) fix the types of fields in struct mtrr_gentry:  64-bit unsigned ints for
   .base and .size seem appropriate

+ this is the cleanest fix

+ can be the same in i386 and x86_64

- it is likely to break existing code


d) add a new set of ioctls parallel to the existing set with a a
   revised struct mtrr_gentry (struct mtrr_gentry64?) with 64-bit
   unsigned ints for .base and .size

+ clean, simple

+ can be the same in i386 and x86_64

+ allows existing code to migrate to new interface

+ eventually the old interface can be deleted


e) add a new set of ioctls with a revised struct mtrr_gentry that use
   scaled 32-bit values rather than 64-bit values for .base and .size

+ this reflects the underlying hardware: the values are scaled by
  pagesize.  So 32 bits are enough.

+ can be the same in i386 and x86_64

+ efficient on i386 and x86_64 since only 32-bit arithmetic is needed.

+ eventually the old interface can be deleted

- requires slightly more intricate changes to existing code


I'm willing to code any of these solutions but I'd like to get opinions
on which is the best way forward.  My preference would be (e) but (d)
would be easier.  I'd certainly fix the documentation.


References:

https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/253204

http://kerneltrap.org/mailarchive/linux-kernel/2008/4/28/1627364
