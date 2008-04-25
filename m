Return-Path: <linux-kernel-owner+w=401wt.eu-S933398AbYDYWow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbYDYWow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYDYWom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:44:42 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:12179 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbYDYWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:44:41 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: MSI, fun for the whole family
References: <20080422221733.GA16260@havoc.gtf.org>
	<480E6DE5.6010103@garzik.org>
	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
	<480E796E.4070001@garzik.org>
	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
	<20080423000529.GG28933@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
	<m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>
	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
	<4810A9E6.1080201@garzik.org>
	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
	<m1r6cvgpw2.fsf@frodo.ebiederm.org> <4810C3B5.3020605@garzik.org>
	<m11w4u8x1c.fsf@frodo.ebiederm.org> <481150EE.3040103@garzik.org>
	<adaiqy67fib.fsf@cisco.com> <48115F90.1030100@garzik.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 25 Apr 2008 15:44:40 -0700
In-Reply-To: <48115F90.1030100@garzik.org> (Jeff Garzik's message of "Fri, 25
	Apr 2008 00:35:28 -0400")
Message-ID: <adamynh5zc7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2008 22:44:40.0551 (UTC) FILETIME=[F2948F70:01C8A725]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The answer is:  the driver might prefer to see the message as it
 > arrived, rather than dividing it up into independent vectors.  The
 > message itself is a unit of data consistency, and there is value in
 > letting the driver see the bounds of that unit.

I can't really understand what this is about.  As things stand now, each
MSI message results in an interrupt, which results in calling the
interrupt handler.  What information from "the message as it arrived" is
being lost other than the precise contents of the PCI transaction, which
is system dependent and of no more interest to the driver than what ball
number a PCI wire interrupt is hooked up to?

 > Additionally the bitmask-friendly multi-port architecture of these
 > SATA controllers matches nicely with an activity (event) status mask
 > we already obtain in almost every driver.

I also don't know what you mean about "bitmask-friendly".  The AHCI spec
that you mentioned pretty clearly talks about having an MSI message per
port, rather than putting a bitmask of ports in the message.  Given that
AHCI supports 32 ports, and MSI messages only are 16 bits long (of which
only 5 bits can be changed by the device), I don't see how you expect
this bitmask to be encoded.

It seems to me that if the kernel supported multiple MSI messages in the
same way it handles multiple MSI-X messages, by giving a different IRQ
number for each message, this would be ideal for a driver... you would
basically do

	for (i = 0; i < dev->num_ports; i++)
		request_irq(dev->msi_vector[i],
			    port_irq_handler, 0,
			    "name", &dev->port[i]);

and then your interrupt handler could look like

irqreturn_t port_irq_handler(int irq, void *port_ptr)
{
	struct my_port *port = port_ptr;
	//...

which is very clean and saves you from having to look up any mask of
ports.

So it might be nice to handle multiple MSI messages, but it's fairly
ugly (both because of the current Linux interrupt handling structure and
also because the MSI spec is somewhat broken), but given that most
devices are moving to MSI-X, it's not clear that it's worth working on
this.  And I don't see any reason why MSI would require changes to the
IRQ handler prototype.

 > Don't assume that the way Linux supports this stuff today is the best,
 > or the only way to do things.  It's not "collapsing all these
 > interrupt vectors" -- remember that an expansion occurred, and
 > /avoiding expansion/ into multiple vectors for multiple messages may
 > be an optimal path for a specific driver application.

What expansion occurrs?  On x86, having a different vector for each MSI
message it pretty fundamental to the way the hardware handles interrupts.

 - R.
