Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbXKBAjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbXKBAjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXKBAjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:39:33 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:56525 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXKBAjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:39:33 -0400
Date: Thu, 1 Nov 2007 17:39:32 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [v4l-dvb-maintainer] bttv build error (CONFIG_NET=n)
In-Reply-To: <1193905709.8587.24.camel@gaivota>
Message-ID: <Pine.LNX.4.58.0711011713260.18400@shell2.speakeasy.net>
References: <20071030221508.3139ea5c.randy.dunlap@oracle.com> 
 <Pine.LNX.4.58.0710310345160.19072@shell4.speakeasy.net> 
 <20071031092350.91eae067.randy.dunlap@oracle.com> <1193905709.8587.24.camel@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Mauro Carvalho Chehab wrote:
> Randy,
> > > The only reason the net stuff works, is because CONFIG_NET includes igmp.c,
> > > which can't be compiled as a module.  That means ip_compute_csum() will get
> > > pulled out of the lib.a file for igmp, and thus be present for the net modules
> > > that use it too.  If igmp could be turned off, made a module, or stopped using
> > > ip_compute_csum(), then the users of ip_compute_csum() that do depend on
> > > CONFIG_NET would have the same problem as bttv does.
> >
> > Thanks for the analysis and summary.
> > (I'm still waiting for those lkml.org links to load... timed out)
> >
> > > It seems a shame to create a new ip checksum function in the bttv driver when
> > > a perfectly good one already exists and will already be present in just about
> > > every kernel out there.  Honestly, how common is NET=n and VIDEO_BT848=m
> > > outside of randconfig?
>
> This might happen on embedded devices, like a set top box or a PVR,
> using a bttv hardware.
>
> > so just adding "depends on NET" should be OK then?
>
> Seems very weird to have bttv module dependent on NET, just because a
> checksum calculus function is defined there.

Mauro, read the first message I linked too:
http://lkml.org/lkml/2007/4/3/209 or http://article.gmane.org/gmane.linux.kernel/511684

Randy had this exact same problem with the md driver and a different ip
checksum function.

ip_compute_csum() _isn't_ defined under NET.  It's part of the kernel's
arch specific library.  So it should be available for all modules to use as
part of the kernel core.  Except due to a flaw in the build system, symbols
that are part of a library can't be used by modules unless there is at
least one non-module user.  There would be the same problem with strcat()
or tons of other functions, if one were able to compile all users of these
functions are modules.

I wonder if the build system could be modified to take every object that's
part of lib-y an turn it into a .ko file?

The process would be something like this:
build lib-y objects like they are and make lib.a

filter out of lib-y all objects that don't export symbols.  Since the
objects are already compiled, this shouldn't be hard.

obj-m += lib-y

Now all the lib files will be modules, and if any module needs a symbol
from one and it's not in the kernel, modprobe will load it.  Minimum bloat,
since the library code isn't loaded into the kernel until something is in
the kernel that needs it.  And we don't need to create kconfig symbols for
library functions and remember to select them.  Let depmod keep track of
what library functions a module needs.
