Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZIRGHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZIRGHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZIRGH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:07:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:47006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZIRGH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:07:26 -0400
Date: Thu, 17 Sep 2009 23:02:10 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
	(Was: Re: [PATCH] Remove broken by design and by implementation
	devtmpfs maintenance disaster)
Message-ID: <20090918060210.GC7104@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> <1253238637.4071.10.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253238637.4071.10.camel@yio.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 03:50:36AM +0200, Kay Sievers wrote:
> On Thu, 2009-09-17 at 17:18 -0700, Linus Torvalds wrote:
> > 
> > On Fri, 18 Sep 2009, Kay Sievers wrote:
> > > 
> > > > So I suspect /dev/null and /dev/zero should be special - just make them
> > > > have 0666 permissions. Because they really _are_ special, and no other
> > > > permissions ever make sense for them.
> > > 
> > > That's true. I guess there are a few more devices that need special
> > > permissions.
> > 
> > /dev/tty is probably the only remaining one - I don't think there should 
> > be any other devices that are so special that normal programs expect them 
> > to be there, and expect to be able to open them.
> > 
> > /dev/null (and to a lesser degree /dev/zero) really are special, and they 
> > are special not so much because they are special devices, but because they 
> > are part of the unix environment in rather deep ways. For example, mmap() 
> > on /dev/zero is deeply special, and really is about shm rather than any 
> > devices, so it's a VM thing with an odd special case.
> > 
> > And /dev/tty is special in that you'd expected to be able to open it even 
> > if you can't open the device that it points to - you may have inherited a 
> > tty from a program that _used_ to have permission to the underlying 
> > /dev/ttyxyz thing, but even if you no longer can open that device, 
> > /dev/tty still works.
> > 
> > The rest of /dev really should be rather esoteric, or it should be about 
> > real devices. So I do think that with just null, zero and tty having 0666 
> > permissions, a "normal UNIX" program is supposed to work. That should be 
> > the minimal set, but also the maximal set of devices that people should 
> > _expect_ to work.
> 
> Here is a quick hack to allow subsystems to provide a mode for their
> devices. It uses the callback that can provide custom non-default device
> names. Ingo, maybe you can give it a try?
> 
> To see how it works, it currently includes access to: null, zero, full,
> random, urandom, tty, ptmx. Also the USB /dev nodes have the same
> permissions as the USB /proc nodes always had. That's basically what
> udev does today for non-root users.

Ick, I don't think we should do something like this, it starts putting
the mode policy back into the kernel.  What's next, owner and group?  :)

I think the udev version in older Fedora releases can't handle this
kernel option, which is fine, just don't enable it.  Newer versions can
handle it, right?

thanks,

greg k-h
