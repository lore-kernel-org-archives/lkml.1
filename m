Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXKJH2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXKJH2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 02:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXKJH2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 02:28:04 -0500
Received: from ozlabs.org ([203.10.76.45]:33747 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXKJH2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 02:28:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: Module init call vs symbols exporting race?
Date: Sat, 10 Nov 2007 18:27:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jon Masters <jonathan@jonmasters.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>
References: <473031FA.2060707@openvz.org> <1194608640.9377.104.camel@perihelion> <1194610607.5000.9.camel@localhost.localdomain>
In-Reply-To: <1194610607.5000.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101827.47874.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 November 2007 23:16:47 Jan Glauber wrote:
> On Fri, 2007-11-09 at 06:44 -0500, Jon Masters wrote:
> > On Thu, 2007-11-08 at 13:10 +1100, Rusty Russell wrote:
> > > On Wednesday 07 November 2007 21:01:30 Jan Glauber wrote:
> > > > Hi Rusty,
> > > >
> > > > I've seen a symbol-resolving race on s390. The qeth module uses
> > > > symbols from qdio and although the loading order seems correct and
> > > > the qdio symbols should be available the following error appears:
> > > >
> > > > qdio: loading QDIO base support version 2
> > > > qeth: Unknown symbol qdio_synchronize
> > >
> > > Looks like qdio does something which triggers qeth to load, but of
> > > course qdio isn't finished initializing yet so its symbols aren't
> > > available.
> > >
> > > It's not obvious what's triggering the load, but you could probably
> > > find it by using printk's through qdio.c's init_QDIO().
> >
> > Jan - did you get anything?
>
> I still think this is a bug in the module loader since qdio does not
> depent on qeth, qdio can be modprobe'd without automatically loading
> qeth. Adding a printk to the end of init_QDIO() inidicates that
> qeth_init() runs _after_ init_QDIO() is finished.

Of course it does: it has to.

qeth needs qdio, and qdio hasn't finished init when qeth tries to load.  
Something tries to load qeth again, and this time it works (qdio's init has 
presumably finished).

We fail rather than sleep in the "dependency isn't ready" case.  Partially 
because it's not happened before, but partially because we risk nasty loops.

Cheers,
Rusty.
