Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZGUPBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZGUPBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZGUPBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:01:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZGUPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:01:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
Date: Tue, 21 Jul 2009 17:00:20 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com> <200907211324.26617.arnd@arndb.de> <20090721131026.12107411@lxorguk.ukuu.org.uk>
In-Reply-To: <20090721131026.12107411@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907211700.21059.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/YFNaUvNyoJkWke1s4B6rbWM4xk46q2Y/eB7Y
 5H+uJRp91H8eVIUpEzOYzv2zG7xwiMN/YYCfEG4sy3hFJe3zAJ
 fMHar5q0vWoCSVTbQzZig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Alan Cox wrote:
> > The naming is unfortunate, because IPC in our context normally
> > refers to Inter-Process-Communication, which is very different
> 
> Actually its also various other things in the kernel already - including
> a type of Sparc system. The device is an "IPC" and calling it something
> else is going to confuse. The code uses mrst_ipc_ as a prefix not ipc_
> for good reason.

Ok. I was hoping that the device is also known by another name that
could be used.

> > > +u32 mrst_ipc_batt_read(u8 ioc, int *err);
> > > +int mrst_ipc_batt_write(u8 ioc, u32 value);
> > > +int mrst_ipc_get_batt_properties(struct mrst_ipc_batt_prop_data *prop_data);
> > > +int mrst_ipc_set_watchdog(struct watchdog_reg_data *p_watchdog_data);
> > > +int mrst_ipc_program_io_bus_master(struct mrst_ipc_io_bus_master_regs
> > > +                       *p_reg_data);
> > > +int lnw_ipc_single_cmd(u8 cmd_id, u8 sub_id, int size, int msi);
> > 
> > As mentioned, these all don't seem to belong in the base driver.
> 
> There are differences between how the various things talk over the IPC.
> There are also locking rules such as the mutex for a single message/reply
> at a time. I think it would actually get horribly ugly if stuff got
> abstracted too much out of the mrst ipc code.

Well, as I said, that is hard to tell without seeing what the drivers
using this do ;-)

> > You really should not hardcode I/O addresses like IPC_BASE_ADDRESS
> > and I2C_SER_BUS. These normally come from some kind of bus probing
> > or from a firmware table. Again, like for the PCI stuff, the virtual
> 
> They are hardcoded.

Well, the experience on other embedded systems shows that hardcoded
addresses in one version change in the next version by one of

- duplication of hardware blocks to provide more of the same stuff
- incompatible registers at the same place
- reorganization of the address layout
- someone deciding to put the whole chip on a PCIe card attached
  to another machine

To handle this, I'd suggest using a set of platform_devices for
this, with one place in the code listing the set of devices with
their addresses, and the other drivers using these on the machines
that have them.

> > > +#define LNW_IPC1_BASE          0xff11c000
> > > +#define LNW_IPC1_MMAP_SIZE     1024
> > 
> > As mentioned before, don't hardcode but read from
> > an appropriate interface.
> 
> These are hardcoded - kind of like the APIC and stuff are. Remember
> Moorestown is not a PC.
> 
> As regards device instances the devices that use it generally create
> their own because they want to be devices like watchdogs, thermal
> monitors or input devices. The IPC itself could probably be a platform
> device with no real problem although I don't think it would actually gain
> anything ?

Most other subsystems do this the other way round -- you have a bus
driver that probes devices (or has a known list of devices), and drivers
that bind to their devices. This allows you to do autoloading of
drivers based on the devices that are there. Of course, this is not
that interesting if there is only a single combination of hardware,
but if you have a common kernel for Moorestown an for PCs, you could
do something like:

1. built-in code adds platform-device for mrst_ipc
2. user space auto-loads the mrst_ipc driver
3. mrst_ipc driver creates child devices for each of its attached
   devices
4. all drivers for the device get loaded if they are loadable
   modules.

	Arnd <><
