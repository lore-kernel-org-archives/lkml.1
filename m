Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZDNQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZDNQAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZDNQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:00:43 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:33570 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZDNQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:00:42 -0400
Subject: Re: [linux-pm] [RFC][PATCH] Add late pm notifiers for hibernate
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, schwidefsky@de.ibm.com,
       ubraun@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0904091414340.2992-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0904091414340.2992-100000@iolanthe.rowland.org>
Content-Type: text/plain
Organization: IBM
Date: Tue, 14 Apr 2009 18:00:43 +0200
Message-Id: <1239724843.4295.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Alan,

Am Donnerstag, den 09.04.2009, 14:17 -0400 schrieb Alan Stern:
> On Wed, 8 Apr 2009, Michael Holzheu wrote:
> 
> > From: Michael Holzheu <holzheu at linux.vnet.ibm.com>
> > 
> > This patch is a suggestion to solve the issue reported by Ursula Braun:
> > https://lists.linux-foundation.org/pipermail/linux-pm/2009-March/020443.html
> > 
> > On s390 we have device drivers that don't belong to a Linux bus. Therefore
> > we can't use the PM device callbacks (dev_pm_ops). The only way to get
> > informed that we hibernate or resume is the pm_notifier_call_chain.
> 
> I'm curious to know what device drivers these are that don't have a 
> bus.  Could they use the platform bus?  That's more or less what it's 
> intended for -- devices that don't fit anywhere else.

Examples are:

* xpram: drivers/s390/block/xpram.c - Block device driver that exports  
         expanded ram as block devices.
* sclp:  drivers/s390/char/sclp.c - Driver to talk to the s390
         service element. E.g. used to control the console.
* and some others like DCSS driver etc ...

Your suggestion with the platform bus looks good. Probably we can use it
for those drivers. At least for xpram and sclp. For the other device
drivers we are still discussing.

> > Unfortunately some of our drivers need a frozen userspace to do their
> > hibernate actions and the current notifiers are called before userspace is
> > frozen. Another point is that we want our console driver to suspend as late
> > as possible so that we can see all the hibernate progress messages on the
> > console.
> 
> It's possible to avoid suspending the console at all if you boot with
> "no_console_suspend" as a kernel parameter.

For s390 we have real console devices that do IO and get interrupts. We
have to suspend these devices. The problem is that when the console
device is suspended, we do not get any more messages - independent from
no_console_suspend.

In case of panic, we have implemented a hack, where we register a panic
notifier that enables the console again and writes out the last
messages. This ensures that when the kernel crashes during suspend or
resume we get at least the last messages. Not nice, but useful.

Michael

