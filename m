Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZGUMK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZGUMK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZGUMKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:10:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43624 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbZGUMKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:10:24 -0400
Date: Tue, 21 Jul 2009 13:10:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
Message-ID: <20090721131026.12107411@lxorguk.ukuu.org.uk>
In-Reply-To: <200907211324.26617.arnd@arndb.de>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com>
	<200907211324.26617.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The naming is unfortunate, because IPC in our context normally
> refers to Inter-Process-Communication, which is very different

Actually its also various other things in the kernel already - including
a type of Sparc system. The device is an "IPC" and calling it something
else is going to confuse. The code uses mrst_ipc_ as a prefix not ipc_
for good reason.

> > +u32 mrst_ipc_batt_read(u8 ioc, int *err);
> > +int mrst_ipc_batt_write(u8 ioc, u32 value);
> > +int mrst_ipc_get_batt_properties(struct mrst_ipc_batt_prop_data *prop_data);
> > +int mrst_ipc_set_watchdog(struct watchdog_reg_data *p_watchdog_data);
> > +int mrst_ipc_program_io_bus_master(struct mrst_ipc_io_bus_master_regs
> > +                       *p_reg_data);
> > +int lnw_ipc_single_cmd(u8 cmd_id, u8 sub_id, int size, int msi);
> 
> As mentioned, these all don't seem to belong in the base driver.

There are differences between how the various things talk over the IPC.
There are also locking rules such as the mutex for a single message/reply
at a time. I think it would actually get horribly ugly if stuff got
abstracted too much out of the mrst ipc code.

> Hmm, so your driver can by design only work with a single
> instance of the hardware. Normally, the recommendation is
> to put all these variables into a structure that you pass
> around between all functions.

"There can be only one", which isn't to say it might not be bad
futureproofing.

> This function looks really strange, it is not called anywhere in your
> driver, is not exported for modules and does not make sense as a
> library interface. The lock does not appear to protect anything
> either.

Agreed the lock isn't needed in the init/setup function.

> You really should not hardcode I/O addresses like IPC_BASE_ADDRESS
> and I2C_SER_BUS. These normally come from some kind of bus probing
> or from a firmware table. Again, like for the PCI stuff, the virtual

They are hardcoded.

> It seems like the calling conventions for mrst_pmic_ioread are
> unnecessarily complicated. r_data.num_entries is always 1, so
> why pass a variable-length array?

mrst_pmic_ioread is also exported for external users. The ioread8/write8
helpers are for the normal case.

> > +#define LNW_IPC1_BASE          0xff11c000
> > +#define LNW_IPC1_MMAP_SIZE     1024
> 
> As mentioned before, don't hardcode but read from
> an appropriate interface.

These are hardcoded - kind of like the APIC and stuff are. Remember
Moorestown is not a PC.

As regards device instances the devices that use it generally create
their own because they want to be devices like watchdogs, thermal
monitors or input devices. The IPC itself could probably be a platform
device with no real problem although I don't think it would actually gain
anything ?

Alan
