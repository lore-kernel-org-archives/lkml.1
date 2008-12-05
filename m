Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYLESrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYLESrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYLESrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:47:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:34668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYLESrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:47:31 -0500
Date: Fri, 5 Dec 2008 10:46:03 -0800
From: Greg KH <gregkh@suse.de>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
Message-ID: <20081205184603.GC13133@suse.de>
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com> <4938EE0B.8020501@msgid.tls.msk.ru> <493929D2.4070900@gmail.com> <1228488921.3858.25.camel@blaa> <493947EB.3050404@gmail.com> <20081205152644.GA27847@suse.de> <1228501817.3858.48.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228501817.3858.48.camel@blaa>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 06:30:17PM +0000, Mark McLoughlin wrote:
> On Fri, 2008-12-05 at 07:26 -0800, Greg KH wrote:
> > On Fri, Dec 05, 2008 at 04:25:31PM +0100, Jiri Slaby wrote:
> > > Mark McLoughlin wrote:
> > > >> Fix the virtio bus instead.
> > > > 
> > > > Yeah, the patch I posted wasn't meant as a fix for this traceback.
> > > 
> > > So what's the module_get patch needed for?
> > > 
> > > > Here's one that does fix it.
> > > ...
> > > > From: Mark McLoughlin <markmc@redhat.com>
> > > > Subject: [PATCH] virtio: add device release() function
> > > > 
> > > > Add a release() function for virtio_pci devices so as to avoid:
> > > > 
> > > >   Device 'virtio0' does not have a release() function, it is broken and must be fixed
> > 
> > Just providing an empty release function to the kernel is the complete
> > wrong thing.  Do you not think the kernel is actually trying to tell you
> > something here?  If it could test for an empty release function it would
> > complain about that as well, providing one is no "fix" at all.
> > 
> > You need to free your memory in the release function that is owned by
> > the device/structure.  Please read the file, Documentation/kobject.txt
> > for details as to what you need to do.
> 
> Okay, consider me "mocked mercilessly by the kobject maintainer" :-)

Heh, prepare for some more mocking below...

> Does this version look a bit more reasonable?
> 
> (The virtio_pci_root is statically allocated so I don't see how
> release() could be non-empty in this case, but let's debate whether we
> want to keep this dummy device at all)

You should NEVER declare a kobject statically.  There should be a check
in the kernel that complains about this on some arches in the -mm and
-next trees, I'm supprised you didn't hit it.

To quote from the kobject.txt documentation file:
	Because kobjects are dynamic, they must not be declared
	statically or on the stack, but instead, always allocated
	dynamically.  Future versions of the kernel will contain a
	run-time check for kobjects that are created statically and will
	warn the developer of this improper usage.

That is why you need a "real" release function.

So, care to respin this again please?

thanks,

greg k-h
