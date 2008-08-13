Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYHMU0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYHMU0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHMUZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:25:54 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:23487 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbYHMUZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:25:53 -0400
Date: Wed, 13 Aug 2008 22:00:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jbaron@redhat.com,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, joe@perches.com,
       nick@nick-andrew.net
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080813200047.GA2053@uranus.ravnborg.org>
References: <20080808215153.GA16729@redhat.com> <20080808193851.24210bc4.randy.dunlap@oracle.com> <20080811173616.GC6103@redhat.com> <20080811223309.GD9810@kroah.com> <20080812194817.GD6056@redhat.com> <20080812200908.GA444@kroah.com> <20080812204619.GE6056@redhat.com> <20080813010804.GA17446@kroah.com> <20080812181653.32d6f373.akpm@linux-foundation.org> <20080813033859.GA9443@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813033859.GA9443@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 08:38:59PM -0700, Greg KH wrote:
> On Tue, Aug 12, 2008 at 06:16:53PM -0700, Andrew Morton wrote:
> > On Tue, 12 Aug 2008 18:08:04 -0700
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > On Tue, Aug 12, 2008 at 04:46:19PM -0400, Jason Baron wrote:
> > > > On Tue, Aug 12, 2008 at 01:09:08PM -0700, Greg KH wrote:
> > > > > So close, can I have a good changelog comment with the patch so people
> > > > > know what it is when they look in the logs?
> > > > > 
> > > > > Care to resend it with that?
> > > > > 
> > > > 
> > > > Base infrastructure to enable per-module debug messages.
> > > 
> > > Ah, so close...
> > > 
> > > With this patch, I get the following build error:
> > > 
> > >   CC [M]  drivers/usb/gadget/u_ether.o
> > > drivers/usb/gadget/u_ether.c: In function ___gether_setup___:
> > > drivers/usb/gadget/u_ether.c:787: error: ___KBUILD_MODNAME___ undeclared (first use in this function)
> > > drivers/usb/gadget/u_ether.c:787: error: (Each undeclared identifier is reported only once
> > > drivers/usb/gadget/u_ether.c:787: error: for each function it appears in.)
> > > drivers/usb/gadget/u_ether.c:787: error: unknown field ___Usage___ specified in initializer
> > > drivers/usb/gadget/u_ether.c:787: error: expected expression before ___.___ token
> > > drivers/usb/gadget/u_ether.c:787: error: initializer element is not constant
> > > drivers/usb/gadget/u_ether.c:787: error: (near initialization for ___descriptor.hash___)
> > > drivers/usb/gadget/u_ether.c:787: error: ___Usage___ undeclared (first use in this function)
> > > drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary << (have ___long long int___ and ___char *___)
> > > drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___:___ token
> > > drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary & (have ___long long int___ and ___char *___)
> > > drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary << (have ___long long int___ and ___char *___)
> > > drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___:___ token
> > > drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary & (have ___long long int___ and ___char *___)
> > > drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___:___ token
> > > drivers/usb/gadget/u_ether.c:787: warning: passing argument 4 of _____dynamic_dbg_enabled_helper___ makes integer from pointer without a cast
> > > drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___KBUILD_MODNAME___
> > 
> > (lol at gcc crap)
> > 
> > > drivers/usb/gadget/u_ether.c:787: warning: too few arguments for format
> > 
> > argh, not that again.  We had this with a patch from Jesse a while
> > back, which I fixed thusly:
> 
> <patch moving KBUILD_MODNAME from a inline function to a macro snipped>
> 
> Yeah, I remember that too, but in this case, KBUILD_MODNAME is being
> used in a macro, not an inline function, the exact opposite.
> 
> Sam, any ideas here?  I'll bounce the original patch at you if you
> missed it last time.

I have not looked into the particular error but what happens is
that u_ether.o is used by more than one module so kbuild does
not know what value to assign the KBUILD_MODNAME and therefore
decide not to assign KBUILD_MODNAME at all.

And because any usage of KBUILD_MODNAME is anyway flawed in u_ether.c
as we do not know for what module it is being used it makes sense for
kbuild to do so.

The above error happens because u_ether.c uses something that require KBUILD_MODNAME
to be define.
So the correct fix is to avid usage of this macro in the source.

Note: The old error Andrew mentions was caused by alpha indirectly
pulling in a inline function that used KBUILD_MODNAME - something
that did not happen on the other architectures.

	Sam
