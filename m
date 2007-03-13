Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbXCMKPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbXCMKPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXCMKPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:15:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:51333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXCMKPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:15:03 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Jim Radford <radford@blackbean.org>
Subject: Re: [PATCH] usb-serial regression fix
Date: Tue, 13 Mar 2007 11:14:46 +0100
User-Agent: KMail/1.9.1
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45F57F63.7010308@rtr.ca> <45F60482.6010501@rtr.ca> <20070313091408.GA7205@blackbean.org>
In-Reply-To: <20070313091408.GA7205@blackbean.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703131114.48068.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. März 2007 10:14 schrieb Jim Radford:

> > So where does the memory get freed -- the structure pointed at
> > by the serial->port[i] thingie ?  It's not a leak, is it?
> 
> It gets free'd through device_unregister
> 
>     for (i = 0; i < num_ports; ++i) {
>        ...
>        port->dev.release = &port_release;
>        ...
>        retval = device_register(&port->dev);
> 
> which means that until all the drivers get converted to use
> ->port_probe() and ->port_remove() (which gets called by
> device_unregister) and stop using the ->port[] array in ->shutdown()
> we need to have ->shutdown() called before device_unregister.
> 
> > > > > Look at changeset d9a7ecacac5f8274d2afce09aadcf37bdb42b93a in Linus's
> > > > > tree from Jim Radford:
> 
> > > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
> 
> So, this patch should be reverted for now.

While we are at it, is there a reason we call return_serial() late in the
sequence? Making sure the device is not reopened should be the
first measure. Are we protected by hanging up the tty?

Secondly, what is this code supposed to do:

	for (i = 0; i < serial->num_ports; ++i)
		serial->port[i]->open_count = 0;

If we get to destroy_serial(), how can ports still be open?

	Regards
		Oliver
