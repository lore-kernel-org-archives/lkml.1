Return-Path: <linux-kernel-owner+w=401wt.eu-S2993316AbXDTSUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993316AbXDTSUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993315AbXDTSUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:20:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993313AbXDTSUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:20:51 -0400
Date: Fri, 20 Apr 2007 14:20:29 -0400
From: Dave Jones <davej@redhat.com>
To: "Preston A. Elder" <prez@goth.net>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420182029.GF20118@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org,
	greg@kroah.com
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462900BD.8020204@goth.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 02:04:45PM -0400, Preston A. Elder wrote:
 > Dave Jones wrote:
 > > On Fri, Apr 20, 2007 at 12:53:31PM -0400, Preston A. Elder wrote:
 > >
 > >  > Linux agpgart interface v0.101 (c) Dave Jones
 > >  > agpgart: DEBUG 0
 > >  > agpgart: DEBUG 1
 > >  > __pci_register_driver: In function
 > >  > __pci_register_driver: driver = agpgart-amdk7, multithread = 0
 > >  > __pci_register_driver: Before Spinlock
 > >  > __pci_register_driver: Before List Init
 > >  > __pci_register_driver: Before Driver Register
 > >  > __pci_register_driver: Error = 0
 > >  > __pci_register_driver: Returning 0
 > >  > 
 > >  > The DEBUG 0 and 1 are coming from agp_amdk7_init()
 > >  > There is a DEBUG 2 at the top of agp_amdk7_probe(), even before
 > >  > pci_find_capability, but the function never gets called.
 > >
 > > bus_add_driver() returns 0 on error, but there's a few different
 > > cases it can fail, which isn't helpful.

Actually I misparsed this function, see below..

 > > Add some printk's to
 > > the error cases there, and see if that gives any more clues.
 > >
 > Here you go:

This is odd..

 > >  > __pci_register_driver: Before Driver Register
 > >  > __pci_register_driver: Error = 0
 > >  > __pci_register_driver: Returning 0

That __pci_register_driver code is (presumably with your printk's added..)

        error = driver_register(&drv->driver);
	printk("Error = %d\n", error);
        if (error) {
		printk("Returning %d\n" error);
                return error;
	}

Which doesn't make much sense.  If 'error' is 0, we shouldn't be
taking that second printk & return. What compiler version is this?

btw Greg, wtf does driver_register return a 0 as 'success' if it
completes the function, and 0 as 'failure' if !bus ?
That seems doomed to failure.

 > Linux agpgart interface v0.101 (c) Dave Jones
 > agpgart: DEBUG 0
 > agpgart: DEBUG 1
 > __pci_register_driver: In function
 > __pci_register_driver: driver = agpgart-amdk7, multithread = 0
 > __pci_register_driver: Before Spinlock
 > __pci_register_driver: Before List Init
 > __pci_register_driver: Before Driver Register
 > bus_add_driver: In Function
 > bus_add_driver: Before kobject_set_name (agpgart-amdk7)
 > bus_add_driver: error = 0
 > bus_add_driver: Before kobject_register
 > bus_add_driver: error = 0
 > bus_add_driver: Before driver_attach
 > bus_add_driver: error = 0
 > bus_add_driver: Before klist_add_tail
 > bus_add_driver: Before module_add_driver
 > bus_add_driver: Before driver_add_attrs
 > bus_add_driver: error = 0
 > bus_add_driver: Before add_bind_files
 > bus_add_driver: error = 0
 > bus_add_driver: Returning 0
 > __pci_register_driver: Error = 0
 > __pci_register_driver: Returning 0

So we completed bus_add_driver without failing, then popped back
up to __pci_register_driver and were somehow treated as
if we failed.   *scratches head*

	Dave

-- 
http://www.codemonkey.org.uk
