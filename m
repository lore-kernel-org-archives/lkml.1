Return-Path: <linux-kernel-owner+w=401wt.eu-S2993326AbXDTUWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993326AbXDTUWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030980AbXDTUWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:22:45 -0400
Received: from sanctuary.goth.net ([64.27.17.130]:53435 "EHLO mail.goth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030866AbXDTUWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:22:44 -0400
Message-ID: <462920EE.2020202@goth.net>
Date: Fri, 20 Apr 2007 16:22:06 -0400
From: "Preston A. Elder" <prez@goth.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: AGPGart / AMD K7
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <462906E5.8060609@goth.net> <20070420184956.GD13939@redhat.com>
In-Reply-To: <20070420184956.GD13939@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, Greg,

Here is the trace with 2.6.20.6

I added back in my trace code, as you see.  As you can also see,
agp_amdk7_probe is still not called.

Linux agpgart interface v0.101 (c) Dave Jones
agp_amdk7_init: In function
agp_amdk7_init: Before pci_register_driver
__pci_register_driver: In Function (driver = agpgart-amdk7, multithread = 0)
__pci_register_driver: Before Spinlock
__pci_register_driver: Before Init List Head
__pci_register_driver: Before driver_register
bus_add_driver: In Function (c048e920)
bus_add_driver: Before kobject_set_name
bus_add_driver: error = 0
bus_add_driver: Before kobject_register
bus_add_driver: error = 0
bus_add_driver: Before driver_attach
bus_add_driver: error = 0
bus_add_driver: Before klist_add_tail
bus_add_driver: Before module_add_driver
bus_add_driver: Before driver_add_attrs
bus_add_driver: error = 0
bus_add_driver: Before add_bind_files
bus_add_driver: error = 0
bus_add_driver: Returning 0
__pci_register_driver: error = 0
__pci_register_driver: Before pci_create_newid_file
__pci_register_driver: error = 0
__pci_register_driver: Returning 0

Even when I start X (using the fglrx driver) I still do not see the
probe function being called.

Everything looks successful, too :(

I will try with 2.6.21rc7, but I don't hold out too much hope.

PreZ

Dave Jones wrote:
> On Fri, Apr 20, 2007 at 02:31:01PM -0400, Preston A. Elder wrote:
>
>  > Here is the code for __pci_register_driver:
>  > ...
>  > 
>  > So in the above case, we ARE saying if driver_register returns 0 then
>  > pci_create_newid_file.
>  > 
>  > Is it different to the code you have?  As I said, this IS 2.6.19.
>
> Yes, .20 changed this in this way..
>
> @@ -445,9 +442,12 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner)
>  
>         /* register with core */
>         error = driver_register(&drv->driver);
> +       if (error)
> +               return error;
>  
> -       if (!error)
> -               error = pci_create_newid_file(drv);
> +       error = pci_create_newid_file(drv);
> +       if (error)
> +               driver_unregister(&drv->driver);
>  
>         return error;
>  }
>
>
> Retry your tracing with .20 (or better yet, .21rc7/todays git)
>
> 	Dave
>
>   

