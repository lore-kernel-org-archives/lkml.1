Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZHJQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZHJQmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZHJQmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:42:46 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:20641 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbZHJQmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:42:45 -0400
X-SpamScore: -38
X-BigFish: VPS-38(zz146fK542N1432R98dN1521M9371Pzz1202hzzz2dh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] Rethinking MicroBlaze commandline precedence
Date: Mon, 10 Aug 2009 09:42:20 -0700
In-Reply-To: <4A7FE78F.4040504@petalogix.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] Rethinking MicroBlaze commandline precedence
Thread-Index: AcoZng9xe6VjQDWFRMyycLQ3i6WabwAOPUfw
References: <1d3f23370908092328l6e980f3ft2d5a8f8f37c26fcf@mail.gmail.com>	 <4A7FCC42.40809@petalogix.com> <1d3f23370908100156q46b9869av5ecdcc8879617be9@mail.gmail.com> <4A7FE78F.4040504@petalogix.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>
CC: "John Linn" <linnj@xilinx.com>, "David DeBonis" <ddeboni@xilinx.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Aug 2009 16:42:42.0137 (UTC) FILETIME=[945F9490:01CA19D9]
Message-ID: <20090810164242.05DE8CC8055@mail83-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: owner-microblaze-uclinux@lists.itee.uq.edu.au
[mailto:owner-microblaze-
> uclinux@lists.itee.uq.edu.au] On Behalf Of Michal Simek
> Sent: Monday, August 10, 2009 2:26 AM
> To: microblaze-uclinux@itee.uq.edu.au
> Cc: John Linn; David DeBonis; Linux Kernel list
> Subject: Re: [microblaze-uclinux] Rethinking MicroBlaze commandline
precedence
> 
> Hi John,
> 
> John Williams wrote:
> > Hi Michal,
> >
> > On Mon, Aug 10, 2009 at 5:29 PM, Michal
Simek<michal.simek@petalogix.com> wrote:
> >
> >> John Williams wrote:
> >
> >>> Currently, MicroBlaze commandline handling in order of lowest to
> >>> highest priority, looks like this:
> >>>
> >>> 1. pointer in r5 from bootloader
> >>> 2. CONFIG_CMDLINE=...
> >>> 3. "chosen" section in DTS/DT
> >>> 4. CONFIG_CMDLINE=... && CONFIG_CMDLINE_FORCE
> >>>
> >>> I'm wondering if a cmdline in r5 should override the DTS.  My
thinking
> >>> is based on two observations:
> >>>
> >>> (a) not everyone will use a bootloader like u-boot that can
manipulate
> >>> DTBs easily before kernel boot
> >>> (b) a custom cmdline string in r5 allows the latest possible
binding
> >>> (runtime), where as the DTB is typically created at compile time.
> >>>
> >>> So, how about this order instead:
> >>>
> >>> 1. CONFIG_CMDLINE=...
> >>> 2. "chosen" section in DTS/DT
> >>> 3. pointer in r5 from bootloader
> >>> 4. CONFIG_CMDLINE=... and CONFIG_CMDLINE_FORCE
> >>>
> >>> Then, apart from CMDLINE_FORCE, the precedence goes from earliest
> >>> binding (kernel build) to latest (runtime via bootloader/r5).

This makes reasonable sense to me, although I wonder if the order is
correct?  For instance, in many cases a flow may be to fix the hardware
DTS and then iteratively compile the kernel?  Are all of these
points/fallback priorities necessary?  Personally, it seems like I want
one 'compiled-in' source, and then the option to override at boot time.
Could it be simplified by getting rid CONFIG_CMDLINE alltogether and
just using the DTS, now that this we always have a device tree?

> >>> Thoughts?
> >> I see there one big problem which can easily arise. Kernel expect
that r5 points to
> >> NULL string and DTS/DTB and CMDLINE will contain correct string.
Kernel just copy it and use
> >> it. There will be undefined behavior for more cases than for
current handling. It will be
> >> less error prune.
> >
> > This expectation currently exists anyway,  giving precendence to DTS
> > cmdline is only less error-prone on the assumption that it's more
> > common.
> >
> > What about a move to an ARM-style ATAGs arrangement, where r5 points
> > not to an ASCIIZ string but instead to some sort of loosely
structured
> > object, with tag codes to signify the commandline etc.
> >
> > That way, we can error check r5 - if it doesn't have the right tags
> > then we don't use the (probably bogus) cmdline string?
> 
> Not sure if is help - but seems to me more complicated than we need.

I would strongly discourage this, if only because the device tree also
fulfills those requirements.

> >> Ad observation a)
> >>
> >> My expectation is that users will use s.....I.... format (I don't
like that name - What about
> >> renaming it?) with dtb - they setup commandline at once and they
don't change it.
> >
> >
> > Ah what's wrong with simpleImage?  It's simple to boot, and make-fu
> > makes it simple to build! :)
> 
> It is more complicated than origin file. Your suggestion for simple
build/boot is fine. :-)
> 
> >
> >> Ad observation b) - for final product they will use only one
command line. For testing you can
> setup
> >> kernel to use only r5.
> >
> > How?  Do we add CONFIG_CMDLINE_IGNORE_DTB?
> 
> >
> > Or just remove the commandline section from DTS "chosen" part?
> 
> yes.
> 
> >
> >> I understand that you are trying to pass to kernel for example MTD
map which could be possible but
> >> IMHO better to do this in script which one with sed
erase/comment/setup command line in DTS before
> >> compilation.
> >
> > It's still a very early binding, and I think there are plenty of
> > reasons to want to override it at boot time.  If there weren't, why
do
> > u-boot and PPC simpleBoot add the capability to tweak at boot time,
> > the cmdline passed via the DTB?
> 
> I understand that make sense to change it - especially for
development.
> It should be possible to do it in u-boot. Not sure if is work to
extend command line but maybe yes.
> Worth to ask on u-boot mailing list.

One way around this is to do what powerpc has: a simple bootloader with
the capability to edit the cmdline on the terminal before boot.  Then
the question of 'does someone have a bootloader' is moot... they can
always fall back on that one.  This would also make microblaze arch more
in the spirit of EPapr, which exactly tries to standardize all of these
mechanisms.

> > Setting MAC addresses for example - you don't want to compile a new
> > DTS for every board you ship, just to provide unique values. You
just
> > want to be able to tweak the cmdline in the config flash or
whatever.
> 
> You should be able to change it in u-boot. The size of mac addr is the
same. Shorten is possible too.
> 
> 
> Cheers,
> Michal
> 
> >
> > Cheers,
> >
> > John
> 
> --
> Michal Simek, Ing. (M.Eng)
> PetaLogix - Linux Solutions for a Reconfigurable World
> w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f:
+61-7-30090663
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page :
http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive :
http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


