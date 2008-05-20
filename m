Return-Path: <linux-kernel-owner+w=401wt.eu-S1763224AbYETKvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763224AbYETKvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYETKvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:51:06 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:35300 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYETKvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:51:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=JEEJ7eRS4disRtkHqfKpotcdD8yc9Mx2OrnZJ8LCIcFj43+ao/Te8smLVVIvJ
	vAlnpYkDcEIEBlAFlzRLEkI8Q==
Date: Tue, 20 May 2008 12:50:54 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, nico@cam.org
Subject: [PATCH] Re: [Bug #10713] ehci splatter in 2.6.26-rc2
Message-ID: <20080520105054.GA23368@xi.wantstofly.org>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.nUH.-rBMIB@albercik> <20080519231126.GA15099@xi.wantstofly.org> <20080520001824.GA15878@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520001824.GA15878@xi.wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 02:18:24AM +0200, Lennert Buytenhek wrote:

> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10713
> > > Subject		: ehci splatter in 2.6.26-rc2
> > > Submitter	: Lennert Buytenhek <buytenh@wantstofly.org>
> > > Date		: 2008-05-14 11:24 (5 days old)
> > > References	: http://marc.info/?l=linux-kernel&amp;m=121076435420129&amp;w=4
> > > Handled-By	: David Brownell <david-b@pacbell.net>
> > 
> > Just re-checked, and this device (a USB to dual PS/2 cable) works
> > fine on 2.6.25 on this hardware:
> > 
> > 	usb 1-1: new low speed USB device using orion-ehci and address 2
> > 	usb 1-1: configuration #1 chosen from 1 choice
> > 	input: PS2 to USB AdapterA3 as /class/input/input0
> > 	input: USB HID v1.10 Keyboard [PS2 to USB AdapterA3] on usb-orion-ehci.0-1
> > 	input: PS2 to USB AdapterA3 as /class/input/input1
> > 	input: USB HID v1.10 Mouse [PS2 to USB AdapterA3] on usb-orion-ehci.0-1
> > 
> > But on 2.6.26-rc3 it just gives me:
> > 
> > 	usb 1-1: new low speed USB device using orion-ehci and address 2
> > 	Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > 	pgd = c0004000
> > 	[00000000] *pgd=00000000
> > 	Internal error: Oops: 5 [#1] PREEMPT
> > 	Modules linked in:
> > 	CPU: 0    Not tainted  (2.6.26-rc3 #347)
> > 	PC is at qh_append_tds+0x24c/0x47c
> > 	LR is at ehci_qtd_alloc+0x30/0x5c
> > 	pc : [<c0242374>]    lr : [<c0241d48>]    psr: 00000093
> > 	sp : c7cfdcb0  ip : c7e3c4c0  fp : c7cfdcfc
> > 	r10: ffc83080  r9 : 00000008  r8 : c7d12240
> > 	r7 : 80000080  r6 : 00000080  r5 : 00000000  r4 : 00000002
> > 	r3 : c7d3f000  r2 : 00000000  r1 : 40800000  r0 : 08085000
> > 	Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> > 	Control: 0005317f  Table: 00004000  DAC: 00000017
> > 	Process khubd (pid: 79, stack limit = 0xc7cfc268)
> > 	Stack: (0xc7cfdcb0 to 0xc7cfe000)
> > 	[...]
> > 	Backtrace:
> > 	[<c0242128>] (qh_append_tds+0x0/0x47c) from [<c0243ca0>] (ehci_urb_enqueue+0x100/0xff4)
> > 	[<c0243ba0>] (ehci_urb_enqueue+0x0/0xff4) from [<c0234c30>] (usb_hcd_submit_urb+0x824/0x91c)
> > 	[<c023440c>] (usb_hcd_submit_urb+0x0/0x91c) from [<c0235098>] (usb_submit_urb+0x224/0x260)
> > 	[<c0234e74>] (usb_submit_urb+0x0/0x260) from [<c0235b5c>] (usb_start_wait_urb+0x44/0xac)
> > 	 r6:c7d12240 r5:c7cfde80 r4:00000000
> > 	[<c0235b18>] (usb_start_wait_urb+0x0/0xac) from [<c0235dac>] (usb_control_msg+0xc8/0xec)
> > 	 r8:00000000 r7:00000100 r6:fffffff4 r5:00000040 r4:c7e3dc20
> > 	[<c0235ce4>] (usb_control_msg+0x0/0xec) from [<c0230854>] (hub_port_init+0x274/0x5e4)
> > 	[<c02305e0>] (hub_port_init+0x0/0x5e4) from [<c0231bec>] (hub_thread+0x608/0xc10)
> > 	[<c02315e4>] (hub_thread+0x0/0xc10) from [<c0059e20>] (kthread+0x5c/0x94)
> > 	[<c0059dc4>] (kthread+0x0/0x94) from [<c0047908>] (do_exit+0x0/0x67c)
> > 	 r6:00000000 r5:00000000 r4:00000000
> > 	Code: e51bc040 e5932000 e51c309c e1520003 (15923000)
> > 	---[ end trace ce1992535f2e8e4d ]---
> > 	note: khubd[79] exited with preempt_count 1
> > 
> > If you have no idea what might have caused this to creep in, I guess
> > I'll have to bisect it?
> 
> A bisect turns up this:
> 
> 	7329e211b987a493cbcfca0e98c60eb108ab42df is first bad commit
> 	commit 7329e211b987a493cbcfca0e98c60eb108ab42df
> 	Author: Alan Stern <stern@rowland.harvard.edu>
> 	Date:   Thu Apr 3 18:02:56 2008 -0400
> 
> 	    USB: root hubs don't lie about their number of TTs
> 	    
> 	    Currently EHCI root hubs enumerate with a bDeviceProtocol code
> 	    indicating that they possess a Transaction Translator.  However the
> 	    vast majority of controllers do not; they rely on a companion
> 	    controller to handle full- and low-speed communications.  This patch
> 	    (as1064) changes the root-hub device descriptor to match the actual
> 	    situation.
> 	    
> 	    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 	    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> And indeed, reverting this commit from 2.6.26-rc3 makes my system
> stop oopsing when I plug in the USB-PS/2 adapter (a low speed device),
> and makes it work again as it did in 2.6.25.

This patch appears to fix it:


The Orion EHCI root hub does have a built-in Transaction Translator.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>

Index: linux-2.6.26-rc3/drivers/usb/host/ehci-orion.c
===================================================================
--- linux-2.6.26-rc3.orig/drivers/usb/host/ehci-orion.c
+++ linux-2.6.26-rc3/drivers/usb/host/ehci-orion.c
@@ -115,6 +115,8 @@ static int ehci_orion_setup(struct usb_h
 	if (retval)
 		return retval;
 
+	hcd->has_tt = 1;
+
 	ehci_reset(ehci);
 	ehci_port_power(ehci, 0);
 


---
