Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbZHLVKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbZHLVKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZHLVKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:10:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36208 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZHLVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:10:48 -0400
Date: Wed, 12 Aug 2009 23:10:33 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: RFC: Merge strategy for Industrial I/O (staging?)
Message-ID: <20090812211033.GX13320@pengutronix.de>
References: <4A828AE9.9090807@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A828AE9.9090807@cam.ac.uk>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 21:33:09 up 7 days,  6:52, 11 users,  load average: 0.01, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Wed, Aug 12, 2009 at 09:27:05AM +0000, Jonathan Cameron wrote:
> The last couple of versions of IIO have recieved some useful feedback
> from a number of people, and feedback from various users has led to a
> number of recent bug fixes. Unfortunately, full reviews of any given
> element have not be forthcoming. Several people who have in principle
> offered to help haven't had the time as yet.

Uuuh, sorry, same here. Wanted to check your code and docs for quite
some time now. So I'll try to at least give you a brain dump on that
topic here.

A driver framework for industrial I/O would be quite welcome; we
constantly see a need for something like that in our automation &
control projects. However, I see some requirements which are currently
not fully addressed by your code.

I'll try to outline the requirements (as I see them) below:

- "process variables" contain the actual data (voltage, temperature etc)
  from the in/outputs. However, process variables need some additional
  meta data to be attached to them, like min/max, unit, scale etc. This
  could be done in userspace, but some cards can provide that
  information directly from the hardware.

- The memory layout of process data is dictated by the transportation
  model. Most modern industrial I/O systems are not based on single-
  channel local I/Os, but on fieldbus I/Os. So for example, if we
  get an EtherCAT frame, we want to push the whole frame into memory
  by DMA, without copying the actual data any more. Let's say that
  several process variables in a block of memory are a "transportation
  unit".

  All these "simple" I/O sources like I2C or SPI based ADCs,
  acceleration devices etc. are just a simplified case of the above.
  For example, acceleration devices often have a three-register process
  data block which contains the three accel values, and the
  transportation unit could be the SPI transfer.

  Events may happen when transportation units arrive; either because
  the hardware does it automatically (i.e. Hilscher CIF(x) cards can
  trigger an interrupt if they have done their bus cycles), or by
  an artificial software event (i.e. in Modbus/TCP you have to decide
  about the "cycle" in software, simply because there is no cycle).

- Applications need to access the process data asynchronously. As
  process data will come from several sources, it can not be expected
  that there is any synchronisation mechanism. So how to synchronize
  the data? I assume some kind of RCU mechanism would be great. For
  each Transportation Unit, there is one producer (the driver) and
  many consumers (the applications). New data which comes in from
  the data source will superseed old data, but for applications
  which didn't finish their cycle yet, the old data needs to stay
  consistent (with all meta data, min/max etc).

  However, I'm not sure if the RCU based process image handling
  should be done in kernel or user space. From the code management view,
  it would be great to have an infrastructure in the kernel.
  Technically, I'm not sure.

  Is something like RCU protected objects in a shared memory space
  possible between kernel and userspace?

- Synchronisation on the application level is coupled to the I/O layer.
  For example, in CANopen networks you have a "sync" message. In Sercos
  III you have the network cycle (MTs/ATs). These may want to trigger an
  application cycle (i.e. PLC cycle) which needs access to the data. So
  what we need is a possibility to let userspace apps sleep until the
  process data layer triggers an event (netlink?).

- We need persistence in the framework. PLCs have the requirement to be
  power-fail safe. Let's assume you have a transportation belt and get
  information about the position of a "thing" on the belt, then the
  power fails and comes back (box boots), you want to continue with the
  old position of the "thing". So the process data backing store
  must be able to live for example on a battery backed SRAM, and all
  transactions need to be atomic.

- Process data access has realtime requirements, but only during an
  "operational" state of an application data block. A usual pattern is
  that, while being in non-operational mode, an application does some
  preparation work, like mapping it's process data, initializing
  things etc. Then it enters operational-mode. During that phase,
  hard realtime conditions may have to be fulfilled. So no memory
  allocation is allowed, mlockall(), priorities must be taken care of
  etc.

- The application "blocks" probably want to live in userspace, but the
  layer that provides the process data should be the kernel.

So in conclusion, I think that before discussing the I/O layer we need
to address the process data handling first. If we start with the
drivers, it won't be possible to add features like persistence any more.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
