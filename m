Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYISJET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYISJET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 05:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYISJEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 05:04:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:53624 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYISJEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 05:04:04 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Greg KH <greg@kroah.com>
Subject: Re: Laptop shock detection and harddisk protection
Date: Fri, 19 Sep 2008 11:03:58 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Tejun Heo <tj@kernel.org>,
       Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
References: <48C7FCEE.8060404@kernel.org> <20080917180405.GB3162@kroah.com> <20080918111845.GH27832@elf.ucw.cz>
In-Reply-To: <20080918111845.GH27832@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809191104.00171.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2008 13:18:45 Pavel Machek wrote:
> On Wed 2008-09-17 11:04:05, Greg KH wrote:
> > On Sun, Aug 17, 2008 at 09:45:21PM +0200, Pavel Machek wrote:
> > > On Fri 2008-09-12 09:59:47, Greg KH wrote:
> > > > On Fri, Sep 12, 2008 at 01:35:54AM +0200, Tejun Heo wrote:
> > > > > Shem Multinymous wrote:
> > > > > >> That reduction comes because input device supports poll and
> > > > > >> sysfs_notify_event() does about the same thing.  The uesrland
> > > > > >> daemon can just poll on a node and read data nodes when poll
> > > > > >> event on the node triggeres.
> > > > > >
> > > > > > Agreed.
> > > > > > There's another issue with the current sysfs interface, though:
> > > > > > hdapsd needs to read (x,y,timestamp) tuples, whereas sysfs
> > > > > > provides just x and y in separate attributes which cannot be read
> > > > > > atomically together. We can add a sysfs file with "x y timestamp"
> > > > > > readouts, though this is unusual for sysfs (and certainly
> > > > > > incompatible with hwmon).
> > > > >
> > > > > Yes, right.  Forgot about the atomicity part altogether.  Thanks
> > > > > for bringing it up.
> > > > >
> > > > > >> Unloading heads will be simple.  Just echoing timeout in ms to
> > > > > >> sysfs nodes, so I don't think it's a good idea to push out
> > > > > >> actual unloading to another process especially as fork doesn't
> > > > > >> inherit mlockall.
> > > > > >
> > > > > > I had in mind another daemon listening for "unload now" events,
> > > > > > so no forking needed.
> > > > > > This second daemon might make sense if we push the logic of
> > > > > > deciding *which* disks to unload into userspace, since this logic
> > > > > > is the same for the ThinkPad style and the HP style.
> > > > >
> > > > > Hmmm... I can't (yet) see the benefit of having two separate
> > > > > userland daemons.
> > > > >
> > > > > >> On a related note, is there any plan to merge tp_smapi to
> > > > > >> mainline? It seems you put a lot of work into it and I don't
> > > > > >> really see why it should stay out of tree.
> > > > > >
> > > > > > The only issue I'm aware of is finding a reasonably-named
> > > > > > maintainer. On the technical side, the reviews on my lkml
> > > > > > submission of thinkpad_ec+hdaps seemed good and all technical
> > > > > > comments are since addressed. The code has been stable,
> > > > > > well-tested and packaged by major distros for years.
> > > > >
> > > > > Cool, can you please post the patch to the lkml and cc Greg
> > > > > Kroah-Hartman <gregkh@suse.de>, Andrew Morton
> > > > > <akpm@linux-foundation.org> and me?
> > > >
> > > > Sorry, but no, I can't accept this code as it is coming from a "known
> > > > anonymous" person containing information that it is not known where
> > > > it came from.
> > >
> > > So... what are you worried about?
> >
> > Code created by access to specs that were not allowed to be published in
> > GPL form by someone who wants to remain anonymous.
>
> That anonymous person may have problems if they signed NDA.
>
> I don't think they did, they even list the sources:
>
>  *  The embedded controller on ThinkPad laptops has a non-standard
> interface, *  where LPC channel 3 of the H8S EC chip is hooked up to IO
> ports *  0x1600-0x161F and implements (a special case of) the H8S LPC
> protocol. *  The EC LPC interface provides various system management
> services (currently *  known: battery information and accelerometer
> readouts). This driver *  provides access and mutual exclusion for the EC
> interface.
> *
>  *  The LPC protocol and terminology is documented here:
>  *  "H8S/2104B Group Hardware Manual",
>  * 
> http://documentation.renesas.com/eng/products/mpumcu/rej09b0300_2140bhm.pdf
>
> H8S chip seems to be documented.
Hmm, the EC is not directly used, but ACPI functions of the HP device are 
used.
For the HP ACPI device: the ACPI functions can *very easily* be re-engineered
(which is common for all laptop_acpi.ko drivers):
ALRD -> is used by the driver to read out registers of the accelerometer
ALWR -> is used by the driver to write a registers of the accelerometer
BTW: HP likes to have support for their device.

The acceleromter chip itself is docuemented in detail here:
http://www.st.com/stonline/products/literature/ds/12094/lis3lv02dl.pdf

I also do not see any concerns.
Greg: Can you please add this one or explain in more detail what else you like 
to see to get this integerated.

Thanks,

      Thomas
