Return-Path: <linux-kernel-owner+w=401wt.eu-S932670AbZHGO54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbZHGO54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbZHGO5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:57:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbZHGO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:57:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 4/7] vbus-proxy: add a pci-to-vbus bridge
Date: Fri, 7 Aug 2009 16:57:32 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: alacrityvm-devel@lists.sourceforge.net,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <200908070057.54795.arnd@arndb.de> <4A7B78580200005A00051D50@sinclair.provo.novell.com>
In-Reply-To: <4A7B78580200005A00051D50@sinclair.provo.novell.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908071657.32858.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX194QYhYTmZsqVH/tScS0zCEE3Wp79Vo2Ef2KjH
 fgGPrTMKSbhJMz+yR3/dj/AD3yPTNOKHLIw/01gRlAr7GMZwQt
 TWvqArgyBr5s1lqLMC7Gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Gregory Haskins wrote:
> >>> Arnd Bergmann <arnd@arndb.de> wrote: 
> > On Thursday 06 August 2009, Gregory Haskins wrote:
> > 
> > >     2b) I also want to collapse multiple interrupts together so as to 
> > > minimize the context switch rate (inject + EIO overhead).  My design 
> > > effectively has "NAPI" for interrupt handling.  This helps when the system 
> > > needs it the most: heavy IO.
> > 
> > That sounds like a very useful concept in general, but this seems to be a
> > detail of the interrupt controller implementation. If the IO-APIC cannot
> > do what you want here, maybe we just need a paravirtual IRQ controller
> > driver, like e.g. the PS3 has.
> 
> Yeah, I agree this could be a function of the APIC code.  Do note that I
> mentioned this in passing to Avi a few months ago but FWIW he indicated
> at that time that he is not interested in making the APIC PV.
> 
> Also, I almost forgot an important one.  Add:
> 
>    2c) Interrupt prioritization.  I want to be able to assign priority
>    to interrupts and handle them in priority order.

I think this part of the interface has developed into the wrong direction
because you confused two questions:

1. should you build an advanced interrupt mechanism for virtual drivers?
2. how should you build an advanced interrupt mechanism for virtual drivers?

My guess is that when Avi said he did not want a paravirtual IO-APIC,
he implied that the existing one is good enough (maybe Avi can clarify that
point himself) answering question 1, while you took that as an indication
that the code should live elsewhere instead, answering question 2.

What you built with the shm-signal code is essentially a paravirtual nested
interrupt controller by another name, and deeply integrated into a new
bigger subsystem. I believe that this has significant disadvantages
over the approach of making it a standard interrupt controller driver:

* It completely avoids the infrastructure that we have built into Linux
  to deal with interrupts, e.g. /proc/interrupts statistics, IRQ
  balancing and CPU affinity.

* It makes it impossible to quantify the value of the feature to start with,
  which could be used to answer question 1 above.

* Less importantly, it does not work with any other drivers that might
  also benefit from a new interrupt controller -- if it is indeed better
  than the one we already have.

	Arnd <><
