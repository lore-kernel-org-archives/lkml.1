Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbYA2OU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbYA2OU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbYA2OUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:20:13 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:38388 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYA2OUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:20:10 -0500
In-Reply-To: <20080129132309.GA10898@kroah.com>
References: <20080108163305.GB10026@in.ibm.com> <20080128182423.GC28861@kroah.com> <20080128192204.GO14201@localdomain> <200801291112.41337.ossthema@de.ibm.com> <20080129132309.GA10898@kroah.com>
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, Jan-Bernd Themann <THEMANN@de.ibm.com>,
       linux-kernel@vger.kernel.org, Nathan Lynch <ntl@pobox.com>,
       ossthema@linux.vnet.ibm.com, sam@ravnborg.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Joachim Fenkes <FENKES@de.ibm.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OFB2A9433F.35E00CA4-ONC12573DF.0049FB58-C12573DF.005988BA@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Tue, 29 Jan 2008 15:20:20 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 29/01/2008 15:20:07
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote on 29.01.2008 14:23:09:

> On Tue, Jan 29, 2008 at 11:12:40AM +0100, Jan-Bernd Themann wrote:
...
> > The sym-link is not gereated automatically as the device for portX is
added
> > to the eHEA device (as subnode) where the eHEA device is not a bus.
>
> Then please fix that, no other driver has this kind of problem, right?
> Are you just passing the wrong "device" to the networking subsystem?
>
> > If this sym-link is of interest (which I guess is the case as most
devices
> > have it) we have to create it somehow.
>
> Why would you have to do this by hand?  What makes this driver so unique
> in the kernel that it would have to do this?  We have lots of other
> multi-port ethernet drivers today without this issue, right?
>
> confused,
>
> greg k-h

well, the major difference is hea is not PCI.
All PCI cards we checked have a 1:1 relationship between PCI function (PCI
config space)
and a single ethernet port.
Even if the same Ethernet chip has two ports, it shows up as two separate
adapters from the PCI perspective (two PCI entries in /sys/bus/pci/devices

host:/ # ls -l /sys/bus/pci/devices/0000\:c8\:01.0/
total 0
lrwxrwxrwx 1 root root      0 2008-01-28 14:59 bus -> ../../../../bus/pci
-r--r--r-- 1 root root   4096 2008-01-28 14:59 class
-rw-r--r-- 1 root root    256 2008-01-28 14:59 config
-r--r--r-- 1 root root   4096 2008-01-28 14:59 device
-r--r--r-- 1 root root   4096 2008-01-29 14:26 devspec
lrwxrwxrwx 1 root root      0 2008-01-28 14:59 driver ->
../../../../bus/pci/drivers/e1000
-r--r--r-- 1 root root   4096 2008-01-28 14:59 irq
-r--r--r-- 1 root root   4096 2008-01-29 14:26 local_cpus
-r--r--r-- 1 root root   4096 2008-01-28 14:59 modalias
lrwxrwxrwx 1 root root      0 2008-01-29 14:26 net:eth1 ->
../../../../class/net/eth1
-r--r--r-- 1 root root   4096 2008-01-28 14:59 resource
....
host:/ # ls -l /sys/bus/pci/devices/0000\:c8\:01.1/
total 0
lrwxrwxrwx 1 root root      0 2008-01-28 14:59 bus -> ../../../../bus/pci
-r--r--r-- 1 root root   4096 2008-01-28 14:59 class
-rw-r--r-- 1 root root    256 2008-01-28 14:59 config
-r--r--r-- 1 root root   4096 2008-01-28 14:59 device
-r--r--r-- 1 root root   4096 2008-01-29 14:29 devspec
lrwxrwxrwx 1 root root      0 2008-01-28 14:59 driver ->
../../../../bus/pci/drivers/e1000
-r--r--r-- 1 root root   4096 2008-01-28 14:59 irq
-r--r--r-- 1 root root   4096 2008-01-29 14:29 local_cpus
-r--r--r-- 1 root root   4096 2008-01-28 14:59 modalias
lrwxrwxrwx 1 root root      0 2008-01-29 14:29 net:eth2 ->
../../../../class/net/eth2
...

These pci functions corresponds to a
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port0
and
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port1

The busdriver currently does not find out, how many ports are in a
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1.
This is up to the hardware specific driver responsible for ehea or ehca.
Think of a PCI card where the PCI busdriver
can not determine how many ports are implemented on the card.

How should this be mapped to /sys ?

Should we try to "flatten" the ports to something like
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1_port0
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1_port1
...which means physical hierarchy information would look a bit strange,
but could be the simpler one.

The way which corresponds to the hardware would be to
improve the kernel in such a way that hierarchical ports also wortk for
netdev_register.
Then we could keep this structure
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port0
/sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port1


So, which way should we try?

Gruss / Regards
Christoph Raisch


