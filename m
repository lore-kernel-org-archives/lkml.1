Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYGCXKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYGCXKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYGCXKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:10:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:57799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbYGCXKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:10:11 -0400
Date: Thu, 3 Jul 2008 16:08:02 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Allow user-selection
Message-ID: <20080703230802.GB21898@kroah.com>
References: <200807022346.53222.mb@bu3sch.de> <200807022241.28046.david-b@pacbell.net> <20080703193755.GC14194@kroah.com> <200807031428.00765.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807031428.00765.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 02:28:00PM -0700, David Brownell wrote:
> On Thursday 03 July 2008, Greg KH wrote:
> > On Wed, Jul 02, 2008 at 10:41:27PM -0700, David Brownell wrote:
> > > The new "-next" process is still working out.  Backwards-incompatible
> > > changes will *always* make problems.  In this case there seem to
> > > have been three such changes:
> > > 
> > > 	- device_create() vanishing, even for users which did the
> > > 	  locking correctly ... this was at least something of a
> > > 	  graceful migration, although it would have been better
> > > 	  if it were deprecated first.  Change can work against
> > > 	  the current (2.6.26) code base.
> > 
> > device_create() did disappear in -next, but when it goes to Linus it
> > will not, it will come back as a #define and everything will be
> > converted back.  That was to catch the build errors when I audited the
> > whole tree.  The -rc1 merge cycle will handle this properly.
> 
> Hmm, that's a surprise.  Any reason that's not in "-next" already?

Because either way you are going to have to change your code to be able
to build properly on top of it.  So what could would the compatibility
macro do for you now.  With the code it way it is, you instantly see the
issue, instead of trying to figure out a warning or other parameter
error.

I was trying to make it obvious, which I guess worked :)

> > > 	- class.devices vanishing ... what I really needed was
> > > 	  more of a "is this class initialized yet" call, so
> > > 	  testing for class->devices.next non-null can be replaced
> > > 	  by a test for class->p non-null.  (Or maybe this should
> > > 	  be viewed as needing a "real" driver model call, so that
> > > 	  code which must run before driver model init can more
> > > 	  easily cooperate with driver model stuff that has to
> > > 	  run much later, after the guts are initialized.)
> > 
> > If you need such a function, please let me know and I can provide it, I
> > was not aware of anyone using class.devices, it is an
> > internal-to-the-driver-core field, and has moved private.
> 
> When the fields are there, it's hard to say what's "internal"
> in the absense of comments ... :)

That's why I have been commenting the changes :)

> The scenario is that gpios sometimes get initialized very early,
> as part of board setup before kmalloc or irqs work, so when they
> get registered sometimes there's work left over for later.  All
> that's needed is a predicate to test whether that class can be
> used as a parameter to stuff like device_create_drvdata() and
> sysfs_create_group().

If you want to see if a class has any devices in it, just do a search
for any device instead of poking into that field.  Or I can wrap that up
in the driver core if needed.

thanks,

greg k-h
