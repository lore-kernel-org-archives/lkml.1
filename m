Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYBAOiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYBAOiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYBAOh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:37:56 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:31067 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYBAOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:37:54 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Christoph Raisch <RAISCH@de.ibm.com>
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
Date: Fri, 1 Feb 2008 15:37:51 +0100
User-Agent: KMail/1.8.2
Cc: Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, linux-kernel@vger.kernel.org,
       Nathan Lynch <ntl@pobox.com>, ossthema@linux.vnet.ibm.com,
       sam@ravnborg.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Joachim Fenkes <FENKES@de.ibm.com>
References: <20080108163305.GB10026@in.ibm.com> <20080129132309.GA10898@kroah.com>  <OFB2A9433F.35E00CA4-ONC12573DF.0049FB58-C12573DF.005988BA@de.ibm.com>
In-Reply-To: <OFB2A9433F.35E00CA4-ONC12573DF.0049FB58-C12573DF.005988BA@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011537.52003.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 15:20, Christoph Raisch wrote:

> These pci functions corresponds to a
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port0
> and
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port1
> 
> The busdriver currently does not find out, how many ports are in a
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1.
> This is up to the hardware specific driver responsible for ehea or ehca.
> Think of a PCI card where the PCI busdriver
> can not determine how many ports are implemented on the card.
> 
> How should this be mapped to /sys ?
> 
> Should we try to "flatten" the ports to something like
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1_port0
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1_port1
> ...which means physical hierarchy information would look a bit strange,
> but could be the simpler one.
> 
> The way which corresponds to the hardware would be to
> improve the kernel in such a way that hierarchical ports also wortk for
> netdev_register.
> Then we could keep this structure
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port0
> /sys/bus/ibmebus/devices/789D.001.XXXXXX-P1/port1
> 
> 
> So, which way should we try?
> 
> Gruss / Regards
> Christoph Raisch
> 
> 
> 

Hi,

so far we fould 2 options. The ibmebus manages (add / remove)
ONLY eHEA adapters (not ehea ethernet ports).
All ethernet ports have to be added / removed by the eHEA device driver when
an eHEA adapter has been added by the ibmebus as a new device.
This means the sysfs-links "driver" for our eHEA ethernet devices (ports) 
are not automatically generated.

Option 1)
- We can create then ourselves. Therefore we would 
  need two functions exported and included in the proper header file:
    - static int driver_sysfs_add(struct device *dev)
    - static void driver_sysfs_remove(struct device *dev)

Option 2)
- we just leave it out which would be inconsistent with
  other pci based ethernet adapters.

So far we prefer option 1. 
Do you see any other ways we should investigate? 

To resolve the build issue I've posted a first patch to remove the
old sysfs links. 


Regards, 
Jan-Bernd & Christoph
