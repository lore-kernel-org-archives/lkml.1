Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbXCLVZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbXCLVZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXCLVZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:25:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38637 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752435AbXCLVZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:25:11 -0400
Date: Mon, 12 Mar 2007 17:25:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: rmmod uhci_hcd -> BUG: atomic counter underflow
In-Reply-To: <45F584CB.3050800@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703121715490.2480-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Jiri Slaby wrote:

> Jiri Slaby napsal(a):
> > Alan Stern napsal(a):
> >> On Mon, 12 Mar 2007, Jiri Slaby wrote:
> >>> After rmmoding of uhci_hcd on fresh booted 2.6.21-rc3-mm2 I got this:
> >>>
> >>> BUG: atomic counter underflow at:
> > [...]
> >>>   [<c01db754>] kobject_put+0x14/0x16
> >>>   [<c01db8a3>] kobject_unregister+0x22/0x25
> >>>   [<c024c987>] bus_remove_driver+0x75/0x82
> >>>   [<c024d3b8>] driver_unregister+0xb/0x18
> >>>   [<c01e7020>] pci_unregister_driver+0x13/0x73
> >>>   [<f88dbbd9>] uhci_hcd_cleanup+0xd/0x2d [uhci_hcd]
> > [...]
> >> Would it be possible for you to add the atomic counter underflow check 
> >> to 2.6.21-rc3 and see if the problem still occurs?  If it doesn't, 
> >> that's a good indication the USB stack isn't guilty -- the bus 
> >> registration code hasn't changed for several kernel releases.
> > 
> > Yes.
> 
> I can confirm, that this issue went upstream and is currently present there.

I found the problem, but I don't know how to fix it.  Hopefully Greg or 
Rusty will know.

There are two bugs in kernel/module.c:module_remove_driver(), right at the 
end of the routine:

	/*
	 * Undo the additional reference we added in module_add_driver()
	 * via kset_find_obj()
	 */
	if (drv->mod_name)
		kobject_put(&drv->kobj);

It's supposed to undo this code in module_add_driver():

	if (mod)
		mk = &mod->mkobj;
	else if (drv->mod_name) {
		struct kobject *mkobj;

		/* Lookup built-in module entry in /sys/modules */
		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
		if (mkobj)
			mk = container_of(mkobj, struct module_kobject, kobj);
	}

The first bug is in the condition of the "if (drv->mod_name)" statement.  
If "mod" isn't NULL then kset_find_obj() doesn't get called, but the "if" 
can succeed anyway.  (Maybe this isn't a real bug -- it would depend on 
all the callers; I don't know.)

The second bug is the argument to kobject_put().  drv->kobj is _not_ the 
kobject whose refcount gets incremented by the kset_find_obj() call.  
That's why the BUG occurred; the kobject's refcount was getting 
decremented without being incremented first.

Alan Stern

