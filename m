Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbZFRGtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbZFRGtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZFRGti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:49:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZFRGti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:49:38 -0400
Date: Thu, 18 Jun 2009 09:49:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
	of an explicit ioctl
Message-ID: <20090618064908.GB11155@redhat.com>
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <4A3639B2.7080006@novell.com> <20090615125439.GI6351@redhat.com> <200906181446.31373.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906181446.31373.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 02:46:30PM +0930, Rusty Russell wrote:
> On Mon, 15 Jun 2009 10:24:39 pm Michael S. Tsirkin wrote:
> > On Mon, Jun 15, 2009 at 08:08:18AM -0400, Gregory Haskins wrote:
> > > Hmm.  I understand what you are saying conceptually (i.e. the .text
> > > could get yanked before we hit the next line of code, in this case the
> > > "return 0").  However, holding a reference when you _know_ someone else
> > > holds a reference to me says that one of the references is redundant.
> > > In addition, there is certainly plenty of precedence for
> > > module_put(THIS_MODULE) all throughout the kernel (including
> > > module_put_and_exit()).  Are those broken as well?
> >
> > Maybe not, but I don't know why. It works fine as long as you don't
> > unload any modules though :) Rusty, could you enlighten us please?
> 
> Yep, they're almost all broken.  A few have comments indicating that someone 
> else is holding a reference (eg. loopback).
> 
> But at some point you give up playing whack-a-mole for random drivers.
> 
> module_put_and_exit() does *not* have this problem, BTW.
> 
> Rusty.

I see that, the .text for module_put_and_exit is never modular itself.
Thanks, Rusty!

BTW, Gregory, this can be used to fix the race in the design: create a
thread and let it drop the module reference with module_put_and_exit.
Which will work, but I guess at this point we should ask ourselves
whether all the hearburn with srcu, threads and module references is
better than just asking the user to call and ioctl.

-- 
MST
