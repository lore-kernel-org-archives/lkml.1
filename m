Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYH2QaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYH2QaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYH2QaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:30:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYH2QaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:30:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
Date: Fri, 29 Aug 2008 18:29:48 +0200
User-Agent: KMail/1.9.9
Cc: Scott Wood <scottwood@freescale.com>, dbrownell@users.sourceforge.net,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Li Yang <leoli@freescale.com>
References: <Pine.LNX.4.44L0.0808291202270.4447-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808291202270.4447-100000@netrider.rowland.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808291829.48939.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX183tloO5bu1XhvmMxAeSkEe7iBMGpCl8ElGSZ4
 nUOWvSqEKB8zAJAxgIBhbHwuIWkxF979ui/7B5DTeChyBgY3Nk
 wOwXanarlHB/sR2MIZSYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Alan Stern wrote:
> > The standard requires that there can only be one protocol handler
> > per physical interface, which is a reasonable limitation.
> 
> No, you've got it exactly backward.  There can be multiple protocol 
> handlers per physical interface, but there must be only one physical 
> interface per device.

Maybe I am using wrong terminology, but I still don't see how that
fits together. Let me try to explain what I have understood so far:

The physical device is identified by a struct usb_gadget is defined
statically in the driver that exports the
usb_gadget_{un,}register_driver() functions. Obviously there can only
be one physical interface per physical device, I was not arguing
against that.

The protocol handler is identified by a usb_gadget_driver and defined
in a driver that calls usb_gadget_register_driver().
You say that there can be multiple protocol handlers, which I don't
understand because the protocol handlers all call set_gadget_data,
which overwrites the previous driver_data field in struct usb_gadget,
making it impossible to load more than one simultaneously.
 
> > However, what the Linux implementation actually enforces is
> > that there can only be one hardware specific driver built or loaded
> > into the kernel, which just looks like an arbitrary restriction
> > that does not actually help.
> 
> Not at all -- it is an implementation of the constraint that there be 
> only one physical interface.

How that? Taking drivers/usb/gadget/fsl_usb2_udc.c as an example, it will
create a new fsl_udc structure for each matching platform_device it finds
(though it will leak every one except the last one), so the interface
does not limit the number of physical interfaces at all to this point,
the implementation of the every gadget hardware driver does this.

The real problem is that you cannot build a kernel that has both
fsl_usb2_udc.c and fsl_qe_udc.c built in. Having both drivers loaded
would not violate the one-interface rule, because only one of them
would find hardware to bind to on a given system, just like you can
load both the uhci and ohci drivers without them interfering.

	Arnd <><
