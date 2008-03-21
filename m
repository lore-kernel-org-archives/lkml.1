Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYCUAhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYCUAhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYCUAhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:37:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38183 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbYCUAhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:37:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Fri, 21 Mar 2008 01:36:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
References: <200803202345.25083.rjw@sisk.pl> <20080320232205.GF17431@elf.ucw.cz> <200803210040.33982.rjw@sisk.pl>
In-Reply-To: <200803210040.33982.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803210136.52310.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Rafael J. Wysocki wrote:
> On Friday, 21 of March 2008, Pavel Machek wrote:
> > On Thu 2008-03-20 19:01:56, Alan Stern wrote:
> > > On Thu, 20 Mar 2008, Rafael J. Wysocki wrote:
> > > 
> > > > > > >> Well, I've been saying that for I-don't-remember-how-long: on my box, if you
> > > > > > >> use S5 instead of entering S4, the fan doesn't work correctly after the
> > > > > > >> resume.  Plain and simple.
> > > > > > >> 
> > > > > > >> Perhaps there's a problem with our ACPI drivers that causes this to happen,
> > > > > > >> but I have no idea what that can be at the moment.
> > > > > > >
> > > > > > > IMO it would be worthwhile to track this down.  It's a clear indication 
> > > > > > > that something is wrong somewhere.
> > > > > > >
> > > > > > > Could it be connected with the way the boot kernel hands control over
> > > > > > > to the image kernel?  Presumably ACPI isn't prepared to deal with that
> > > > > > > sort of thing during a boot from S5.  It would have to be fooled into
> > > > > > > thinking the two kernels were one and the same.
> > > > > > 
> > > > > > It should be easy to test if it is a hand over problem, by turning off
> > > > > > the laptop by placing it in S5 (shutdown -h now) and then booting same
> > > > > > kernel again.
> > > > > 
> > > > > Feel free to help with testing.
> > > > > 
> > > > > I believe ACPI is simply getting confused by us overwriting memory
> > > > > with that from old image. I don't see how you can emulate it with
> > > > > shutdown.
> > > > 
> > > > Well, in fact ACPI has something called the NVS memory, which we're supposed
> > > > to restore during the resume and which we're not doing.  The problem may be
> > > > related to this.
> > > 
> > > No, it can't be.  ACPI won't expect the NVS memory to be restored 
> > > following an S5-shutdown.  In fact, as far as ACPI is concerned, 
> > > resuming from an S5-type hibernation should not be considered a resume 
> > > at all but just an ordinary reboot.
> 
> I agree here.
> 
> > > All ACPI-related memory areas in the boot kernel should be passed directly
> > > through to the image kernel.
> 
> However, the image kernel is supposed to restore the NVS area (from the
> image) before executing _WAK.
> 
> > How can we pass interpretter state? I do not think we do this kind of
> > passing.
> 
> The interpreter state is passed withing the image.  The platform state is not.
> 
> > If it was enough to pass some static area, we could just mark it
> > nosave...
> > 
> > Len: Is ACPI AML permitted to allocate memory (like in ACPI_ALLOC or
> > something)? Could we easily identify BIOS data so we could mark them
> > nosave?
> 
> This wouldn't work even if we could (at least on x86-64).

Ah, I misunderstood your comment, sorry.

The regions used by ACPI are registered as 'nosave' by the arch code and
we don't save them.  However, the ACPI NVS area is exceptional in that we
are supposed to save and restore it.  The problem is to restore it at the right
time and it's quite hard to figure out from the spec what time is the right
one (the only thing it says is we should do that before calling _WAK).

Thanks,
Rafael
