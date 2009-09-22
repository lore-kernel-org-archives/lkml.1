Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZIVPqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZIVPqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZIVPqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbZIVPqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:46:22 -0400
Date: Tue, 22 Sep 2009 21:15:49 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Cox <alan@linux.intel.com>, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090922154549.GA11379@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <200909221214.04340.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909221214.04340.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) Sep 22 2009 [12:14:04], Rusty Russell wrote:
> On Sat, 12 Sep 2009 01:30:10 am Alan Cox wrote:
> > > The interface presented to guest userspace is of a simple char
> > > device, so it can be used like this:
> > > 
> > >     fd = open("/dev/vcon2", O_RDWR);
> > >     ret = read(fd, buf, 100);
> > >     ret = write(fd, string, strlen(string));
> > > 
> > > Each port is to be assigned a unique function, for example, the
> > > first 4 ports may be reserved for libvirt usage, the next 4 for
> > > generic streaming data and so on. This port-function mapping
> > > isn't finalised yet.
> > 
> > Unless I am missing something this looks completely bonkers
> > 
> > Every time we have a table of numbers for functionality it ends in
> > tears. We have to keep tables up to date and managed, we have to
> > administer the magical number to name space.
> 
> The number comes from the ABI; we need some identifier for the different
> ports.  Amit started using names, and I said "just use numbers"; they have
> to be documented and agreed by all clients anyway.
> 
> ie. the host says "here's a port id 7", which might be the cut & paste
> port or whatever.

Yeah; port 0 has to be reserved for a console (and then we might need
to do a bit more for multiple consoles -- hvc operates on a 'vtermno',
so we need to allocate them as well).

Also, a 'name' property can be attached to ports, as has been suggested:

qemu ... -device virtconport,name=org.qemu.clipboard,port=3,...

spawns a port at id 3 and the guest will also place a file:

/sys/class/virtio-console/vcon3/name

which has "org.qemu.clipboard" as contents, so udev scripts could
create a symlink:

/dev/vcon/org.qemu.clipboard -> /dev/vcon3

		Amit
