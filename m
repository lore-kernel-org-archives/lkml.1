Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbXHYDDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbXHYDDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 23:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXHYDCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 23:02:54 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:61426 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbXHYDCx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 23:02:53 -0400
Date: Fri, 24 Aug 2007 23:02:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
Message-ID: <20070825030251.GA15827@Krystal>
References: <20070824224707.GA7275@Krystal> <20070824161029.6236a5f4.akpm@linux-foundation.org> <20070825001638.GB9811@Krystal> <20070824174450.70337f4f.akpm@linux-foundation.org> <20070825004640.GA21756@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070825004640.GA21756@kroah.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:43:21 up 26 days,  3:02,  4 users,  load average: 0.33, 0.12, 0.08
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Fri, Aug 24, 2007 at 05:44:50PM -0700, Andrew Morton wrote:
> > On Fri, 24 Aug 2007 20:16:38 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > > On Fri, 24 Aug 2007 18:47:07 -0400
> > > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > > 
> > > > > Hi Andrew,
> > > > > 
> > > > > I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> > > > > you would have some ideas about what is causing this problem. I'll start
> > > > > bissecting it soon. I seems to be caused by an buggy skb_put call in
> > > > > kobject_uevent_env.
> > > > > 
> > > > > Thanks,
> > > > > 
> > > > > Mathieu
> > > > > 
> > > > > 
> > > > 
> > > > hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
> > > > much all of the fixes were in rc3-mm1 anyway.
> > > > 
> > > > I doubt if bisection will tell us a lot: it'll probably point at
> > > > gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
> > > > 
> > > > What we _would_ like to know is which sysfs file is being written to.  We
> > > > used to have a debug patch to exactly address this problem but it got
> > > > transferred into Greg's tree from whence it mysteriously disappeared.
> > > > 
> > > 
> > > Ok, here it is:
> > > 
> > > filename :
> > > 
> > > /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev
> > 
> > Bah.  I've never found a sane way of going from a sysfs pathname back to the
> > code which implements that pathname :(
> > 
> > <greps the tree for '"rev"'>
> > 
> > <comes up with zilch>
> 
> It's a scsi file, as the above is a scsi device.  It's created in the
> drivers/scsi/scsi_sysfs.c file.
> 
> Kay, did you miss this set of attributes somehow?
> 
> thanks,
> 
> greg k-h

Hi Greg,

I think I am slowly getting there.. it looks like an off-by-one in
lib/kobject_uevent.c: add_uevent_var

when testing the return value of vsnprintf

if (len + 1 >= (sizeof(env->buf) - env->buflen))

should be

if (len >= (sizeof(env->buf) - env->buflen))

And then the problem underneath is that the array is too short for some
values. Since the return value of add_uevent_var is always ignored (why?)
from its callers, fixing the off-by-one will just fail silently, which is
almost worse.

I think we should find some better way of handling full static arrays.

And the bug is still there even if I fix these. So I'll continue my
investigation.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
