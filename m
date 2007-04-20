Return-Path: <linux-kernel-owner+w=401wt.eu-S1767174AbXDTSbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767174AbXDTSbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767177AbXDTSbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:31:41 -0400
Received: from sanctuary.goth.net ([64.27.17.130]:56027 "EHLO mail.goth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767174AbXDTSbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:31:41 -0400
Message-ID: <462906E5.8060609@goth.net>
Date: Fri, 20 Apr 2007 14:31:01 -0400
From: "Preston A. Elder" <prez@goth.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: AGPGart / AMD K7
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com>
In-Reply-To: <20070420182029.GF20118@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Apr 20, 2007 at 02:04:45PM -0400, Preston A. Elder wrote:
>  > Dave Jones wrote:
>  > > On Fri, Apr 20, 2007 at 12:53:31PM -0400, Preston A. Elder wrote:
>  > >
>  > >  > Linux agpgart interface v0.101 (c) Dave Jones
>  > >  > agpgart: DEBUG 0
>  > >  > agpgart: DEBUG 1
>  > >  > __pci_register_driver: In function
>  > >  > __pci_register_driver: driver = agpgart-amdk7, multithread = 0
>  > >  > __pci_register_driver: Before Spinlock
>  > >  > __pci_register_driver: Before List Init
>  > >  > __pci_register_driver: Before Driver Register
>  > >  > __pci_register_driver: Error = 0
>  > >  > __pci_register_driver: Returning 0
>  > >  > 
>  > >  > The DEBUG 0 and 1 are coming from agp_amdk7_init()
>  > >  > There is a DEBUG 2 at the top of agp_amdk7_probe(), even before
>  > >  > pci_find_capability, but the function never gets called.
>  > >
>  > > bus_add_driver() returns 0 on error, but there's a few different
>  > > cases it can fail, which isn't helpful.
>
> Actually I misparsed this function, see below..
>
>  > > Add some printk's to
>  > > the error cases there, and see if that gives any more clues.
>  > >
>  > Here you go:
>
> This is odd..
>
>  > >  > __pci_register_driver: Before Driver Register
>  > >  > __pci_register_driver: Error = 0
>  > >  > __pci_register_driver: Returning 0
>
> That __pci_register_driver code is (presumably with your printk's added..)
>
>         error = driver_register(&drv->driver);
> 	printk("Error = %d\n", error);
>         if (error) {
> 		printk("Returning %d\n" error);
>                 return error;
> 	}
>
> Which doesn't make much sense.  If 'error' is 0, we shouldn't be
> taking that second printk & return. What compiler version is this?
>
> btw Greg, wtf does driver_register return a 0 as 'success' if it
> completes the function, and 0 as 'failure' if !bus ?
> That seems doomed to failure.
>
>  > Linux agpgart interface v0.101 (c) Dave Jones
>  > agpgart: DEBUG 0
>  > agpgart: DEBUG 1
>  > __pci_register_driver: In function
>  > __pci_register_driver: driver = agpgart-amdk7, multithread = 0
>  > __pci_register_driver: Before Spinlock
>  > __pci_register_driver: Before List Init
>  > __pci_register_driver: Before Driver Register
>  > bus_add_driver: In Function
>  > bus_add_driver: Before kobject_set_name (agpgart-amdk7)
>  > bus_add_driver: error = 0
>  > bus_add_driver: Before kobject_register
>  > bus_add_driver: error = 0
>  > bus_add_driver: Before driver_attach
>  > bus_add_driver: error = 0
>  > bus_add_driver: Before klist_add_tail
>  > bus_add_driver: Before module_add_driver
>  > bus_add_driver: Before driver_add_attrs
>  > bus_add_driver: error = 0
>  > bus_add_driver: Before add_bind_files
>  > bus_add_driver: error = 0
>  > bus_add_driver: Returning 0
>  > __pci_register_driver: Error = 0
>  > __pci_register_driver: Returning 0
>
> So we completed bus_add_driver without failing, then popped back
> up to __pci_register_driver and were somehow treated as
> if we failed.   *scratches head*
>
> 	Dave
>
>   
Dave,

Here is the code for __pci_register_driver:

  int __pci_register_driver(struct pci_driver *drv, struct module *owner)
  {
      int error;

  printk(KERN_INFO "__pci_register_driver: In function\n");
      /* initialize common driver fields */
      drv->driver.name = drv->name;
      drv->driver.bus = &pci_bus_type;
      drv->driver.owner = owner;
      drv->driver.kobj.ktype = &pci_driver_kobj_type;

  printk(KERN_INFO "__pci_register_driver: driver = %s, multithread = %d\n",
            drv->name, pci_multithread_probe);
      if (pci_multithread_probe)
          drv->driver.multithread_probe = pci_multithread_probe;
      else
          drv->driver.multithread_probe = drv->multithread_probe;

  printk(KERN_INFO "__pci_register_driver: Before Spinlock\n");
      spin_lock_init(&drv->dynids.lock);
  printk(KERN_INFO "__pci_register_driver: Before List Init\n");
     INIT_LIST_HEAD(&drv->dynids.list);

  printk(KERN_INFO "__pci_register_driver: Before Driver Register\n");
      /* register with core */
      error = driver_register(&drv->driver);

  printk(KERN_INFO "__pci_register_driver: Error = %d\n", error);
      if (!error)
          error = pci_create_newid_file(drv);

  printk(KERN_INFO "__pci_register_driver: Returning %d\n", error);
      return error;
  }

So in the above case, we ARE saying if driver_register returns 0 then
pci_create_newid_file.

Is it different to the code you have?  As I said, this IS 2.6.19.

PreZ :)

