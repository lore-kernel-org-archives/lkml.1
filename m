Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZIRMGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZIRMGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZIRMGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:06:39 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62118 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbZIRMGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=I9x5T857mkHgf1GBDjWh86+PZ35MilkO6is1TK74SzhqAmjciQn8wJNs2ZDXoAP3Qc
         3/g+neolS4Mf5MRxq17F1A3b/YAZ1ePjKAG002jxCmCxA6KwOC9xQ4XJ0+RwJF/2aK0Y
         KsnVvnokLGUtuy71uVlRfNqkm4WzXZ7AnMne8=
MIME-Version: 1.0
In-Reply-To: <778490.95843.qm@web50204.mail.re2.yahoo.com>
References: <778490.95843.qm@web50204.mail.re2.yahoo.com>
Date: Fri, 18 Sep 2009 13:06:39 +0100
Message-ID: <9b2b86520909180506n667b161esca739811d8604d49@mail.gmail.com>
Subject: Re: Auto loading of kernel modules COLD/HOT BOOT
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: vprabu vprabu <prabu_online2005@yahoo.com>
Cc: linux-hotplug@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-usb@vger.kernel.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/09, vprabu vprabu <prabu_online2005@yahoo.com> wrote:
> Hi All,
>
> This is prabu .

Hi

> I am new to kernel hacking ; i had been an application guy; now focusing
> into the fundamentals of linux kernel. I really have little knowledge about
> the kernel, modules and auto loading of modules.After a lot of googling ,i
> am now much perplexed :-).
>
>  Most of the articles are contradictory to each
> other and not very clear ( or not so simple at my level to comprehend)

Heh, I think that's a common reaction.  I don't know where there is a
good introduction.

What I would suggest is that you look at a working system.  Any modern
distro - although it may be better to avoid Debian since it alone uses
its own rules, and Arch Linux, which has funky extra stuff for
modules.  If you have a concrete working system you can ask concrete
questions of it :-).

> 1. How does a linux distribution know which feature is to be set in kernel
> and which one as a module.

It varies.  The distributions used to do modules for everything to
avoid wasting memory.  More recently, Moblin showed that you can boot
faster by making some common drivers (and other features like
filesystems) built in.

It doesn't matter if a module might be required to boot less common
systems (e.g. a specific ATA driver), because modules can be included
in the initramfs, which is loaded alongside the kernel by the boot
loader.

> 2. Now after installation, i reboot the server ....( COLDPLUG )
>
> *. Does the hardware probing is done first and then the relevant drivers are
> loaded for the hardware found. If so how is this achieved.
>
> ( or )
>
> *. Else if the hardware driver is loaded FIRST from modprobe.conf and does
> it go in search of a corresponding device supported by the driver?
>
> ie. Need to know a device is found first and its corresponding driver is
> loaded or the driver is loaded first which brings up the device

The first one (for modern buses).  Each device has an identifier in a
standard format and location, e.g. on the PCI bus, each device has a
vendor and device ID.  The bus code reads all these IDs, and is then
causes the appropriate modules to be loaded.

Look in sysfs under /sys/bus/*/devices; each device has a "modalias"
file.  That's short for "module alias".  Search /lib/udev/rules.d for
this; you will see an invocation of "modprobe" to load the module with
this alias.

In udev coldplug the rules are processed for each hardware device;
this is achieved by the command "udevadm trigger".

> 3. HOTPLUG ......
>
>
> *. I now add a new network card to the PCI slot. ( 2.6 )
>
> *. I assume that the PCI controller sends a signal to the kernel that a new
> device is added
>
> *. The new device's firmware details like vendor id, prod id is propogated
> to /sys file system.
>
> *. udevd tries to load the device drivers containing that particular vendor
> id in /lib/modules/kernel.xx/net
>
> i have a doubt ... like.. does it search only /etc/modprobe.conf or all the
> modules under /lib/modules.

All modules under /lib/modules.

The "modalias"es are built into the modules.  They are extracted by
the "depmod" command into /lib/modules/*/module.aliases.bin, which
"modprobe" can then search efficiently.  You can see these builtin
aliases using "modinfo".

(the .bin files were added recently; previously the search was not
quite so efficient :-).

>
>
> 4. How does the same hotplug and cold plug happen in case of 2.4 kernels.
>
> where does kmod , kerneld come into picture

We're not interested in them, it is too long ago and no-one supports it.

> 5.  What is the main role of rc.sysinit -- does this handle device and
> drivers.

Dunno, this probably varies between distros.

> 6. Dont know when to put an entry in modprobe.conf and when not to.

Don't :-).

a) Don't use modprobe.conf. use /etc/modprobe.d/some-file-here.conf
b) The modaliases used to load drivers should be built into the
modules, as described above.  There may be some exceptions where this
is still not done.  The situation has improved better recently; if you
find such a case you should consider it a bug.

> 7. why does lsmod show something different from modprobe -c

There is no obvious connection between these two, please elaborate as
to what you are expecting.  lsmod lists loaded modules.  modprobe -c
dumps the entire configuration, including /etc/modprobe.d and
/lib/modules/$version/modules.alias etc.

> 8. How does modprobe -c get those values. why does it vary with lsmod output

See above

> 9. There are two SCSI hostadapters of same type. Do i need  to load the
> module twice for it or once?

Once.

> In simple words how a device driver is loaded at boot/hotplug for 2.4 and
> 2.6 kernels
>
>
> I know each one is inter-related but dont know how they are?.

Very.  "Coldplug" i.e. "udevadm trigger" simply synthesizes hotplug
events.  It replays the events which happened earlier, i.e. before
userspace was up and running.

Both cases look the same to the main udev daemon.

> I cant find
> any good article to explain the
>
> working of modules in simple words (both 2.4 / 2.6 with examples)
>
> Any help in this regard is much appreciated....
>
> Prabu

Best wishes, hope this helps.
Alan
