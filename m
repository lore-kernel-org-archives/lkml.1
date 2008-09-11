Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYIKWIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYIKWIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 18:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYIKWHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 18:07:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbYIKWHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:07:53 -0400
Date: Thu, 11 Sep 2008 15:07:00 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-ID: <20080911220700.GD5823@kroah.com>
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com> <1221151165.6309.55.camel@californication> <20080911201541.GA18518@kroah.com> <1221165518.4077.17.camel@macbook.infradead.org> <20080911205738.GB11708@kroah.com> <1221167725.4077.34.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221167725.4077.34.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 02:15:25PM -0700, David Woodhouse wrote:
> On Thu, 2008-09-11 at 13:57 -0700, Greg KH wrote:
> > On Thu, Sep 11, 2008 at 01:38:38PM -0700, David Woodhouse wrote:
> > > On Thu, 2008-09-11 at 13:15 -0700, Greg KH wrote:
> > > > This is the firmware that is in the kernel source tree, that has been
> > > > moved to use request_firmware, and was originally tied tightly to the
> > > > kernel drivers themselves.
> > > 
> > > Not really. Most of it hasn't changed for years; it isn't _really_ tied
> > > that closely to the kernel. 
> > 
> > Some are and some aren't (I have two in my -staging tree that are
> > changing as the driver changes, so it does happen.)
> 
> That's fine. Just make sure the filename changes when an incompatible
> change is made to the firmware -- just like you handle sonames in
> libraries. It's not hard, and you should _always_ have been doing it.
> 
> And it's a completely bogus example _anyway_, because you're not adding
> this extra firmware to the kernel tree.

No, it shows that the firmware does change over time.

> All I've done _recently_ is a bit of a sweep on the stragglers. And
> because of the amount of stupid whining, I made it possible to keep it
> in the kernel tree rather than just evicting it, as we did in the past.

But it was that "sweep" that has caused problems by having the kernel
put these files into the lib/firmware directory, without any version
information unlike any other file that our kernel installs.

That's the only point here.

It seems that the point that it is a bad thing for multiple kernel
packages to be installing into the same location, no matter if the file
has the same content or not (date will change which will cause
problems) isn't coming across here.  Why is that?

Think of the very real example here:

	rpm -Uhv kernel-2.6.27.1.rpm
	rpm -Uhv kernel-2.6.27.2.rpm
	rpm -e kernel-2.6.28.1

Now what just happened to the firmware that the 2.6.27.2 kernel package
had installed into lib/firmware?  It would be gone.  That is if rpm even
_allowed_ the second kernel package to be installed due to the
conflicting files.

So distros _HAVE_ to install the kernel-based firmware into
lib/firmware/uname-r/ to get their packaging to work, and to prevent bad
things from happening if a user installs their own kernel by hand and
then removes the kernel package.

That is why this patch was submitted, it is necessary.  If every distro
has to carry it on their own, due to packaging requirements, don't you
think that it should be in the main kernel tree as well?

> > > You can just ignore what the kernel ships with, and install the firmware
> > > from the linux-firmware.git repository instead.
> > 
> > So you are now forcing distros to ship the linux-firmware.git repo
> > instead?  That's not nice and is a totally new dependancy for them to
> > handle.
> 
> Not at all; that's the ideal situation, but nobody's forced to do it
> that way.

It's either use that package or add a patch that upstream seems to be
objecting to.  That seems a bit "forced".

> > What about the very basic fact that kernel versions will stomp on files
> > from other kernel versions if you install multiple kernels on the same
> > machine?  That's just bad and ripe for problems in any package
> > management system.
> 
> Only if you do stupid things in your packaging. So don't do that.

How do you expect anyone to package this up so that no conflicts occur?

thanks,

greg k-h
