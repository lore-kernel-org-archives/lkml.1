Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbYHIQOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbYHIQOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 12:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYHIQOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 12:14:14 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29771 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYHIQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 12:14:13 -0400
Date: Sat, 9 Aug 2008 18:13:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Renninger" <trenn@suse.de>
Subject: Re: New conflict message in latest GIT
Message-ID: <20080809181358.5c9da790@hyperion.delvare>
In-Reply-To: <b637ec0b0807231250g3e5b29eak8fbba41b69816351@mail.gmail.com>
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
	<200807231256.42743.bjorn.helgaas@hp.com>
	<b637ec0b0807231250g3e5b29eak8fbba41b69816351@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Wed, 23 Jul 2008 21:50:24 +0200, Fabio Comolli wrote:
> Hi.
> 
> On Wed, Jul 23, 2008 at 8:56 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Tuesday 22 July 2008 12:56:36 pm Fabio Comolli wrote:
> >> Linus' GIT tree 2.6.26-05752-g93ded9b shows this message:
> >>
> >> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> >> ACPI: I/O resource 0000:00:1f.3 [0x18e0-0x18ff] conflicts with ACPI
> >> region SMBI [0x18e0-0x18ef]
> >> ACPI: Device needs an ACPI driver
> >>
> >> There is no equivalent in 2.6.26 or previous kernels.
> >
> > The "ACPI: I/O resource ... conflicts with ..." message was added by
> > Thomas:
> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=df92e695998e1bc6e426a840eb86d6d1ee87e2a5
> >
> > That conflict checking infrastructure was in 2.6.26, but Jean's
> > change to make the i801_smbus driver use it didn't happen until
> > about a week ago:
> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=54fb4a05af0a4b814e6716cfdf3fa97fc6be7a32
> >
> > The message is telling us that the i801_smbus driver thinks it owns
> > the 0x18e0-0x18ff region, but there's also an ACPI opregion that
> > references that region.  There's no coordination between ACPI and
> > the i801_smbus driver, so there may be issues where nearly
> > simultaneous accesses cause incorrect behavior, e.g,. one may
> > read the wrong value from a temperature sensor.  That, of course,
> > can lead to more serious things like unintended machine shutdowns.
> >
> > I don't have any ideas about how to address this.  I think Thomas's
> > intent was to collect better information for unreproducible bugs.
> > (Maybe this sort of conflict should even set a taint flag?)

Yes, at this point these messages are informative only and displayed as
a hint when investigating bug reports. In the long run, we might
decide to grant exclusive access to the shared region to either ACPI or
the native driver, or to setup a safe concurrent access mechanism.
That's a long way to go though, due to the diversity of BIOSes out
there and the fact that many of them declare opregions in bogus ways.

> OK, I actually didn't even know what i801_smbus (i2c_801 I suppose)
> was. It seems that my laptop has a super-IO chip which is detected by
> lm-sensors as `Nat. Semi. PC87591 Super IO' which doesn't have a
> driver and never will.
> 
> So, if I'm correct, this modules is totally useless for me and I
> better compile it out. Am I correct?

Yes you are. If you don't need i2c-i801 on this machine, best is to not
build it or to prevent it from loading. Or you can boot with
acpi_enforce_resources=strict to prevent the i2c-i801 driver from
attaching to the device.

I am a bit curious though, why ACPI would declare an opregion for a
device that isn't used. Might be yet another case of BIOS copied from
another machine and not cleaned up appropriately.

-- 
Jean Delvare
