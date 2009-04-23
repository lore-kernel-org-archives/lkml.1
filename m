Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZDWCyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZDWCyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZDWCxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:53:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50644 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752135AbZDWCxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:53:53 -0400
Date: Wed, 22 Apr 2009 22:53:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: Robert Hancock <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
In-Reply-To: <20090422220648.GB4066@ime.usp.br>
Message-ID: <Pine.LNX.4.44L0.0904222236440.23171-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, [utf-8] Rogério Brito wrote:

> > According to the EHCI spec, XactErr is "Set to a one by the Host  
> > Controller during status update in the case where the host did not  
> > receive a valid response from the device (Timeout, CRC, Bad PID,
> > etc.)"
> 
> Is there any way of controlling the number of retries in the host
> controller? Or, perhaps, of controlling the time between retries so that
> the device can shape it up again?

It's not all that simple.  The host controller allows the OS to set the
number of hardware retries to 1, 2, 3, or unlimited.  Linux uses 3;  
those XactErr debugging messages in your log show that the driver was
extending the number of retries in software.

It's not possible to change the time interval between retries done by
the hardware.  While it is possible in theory to change the interval
between retries done by the driver, it would be rather difficult and
so ehci-hcd doesn't attempt it.

The software retries were introduced to solve one particular problem:  
Many EHCI controllers will generate a transaction error if a data
transfer is occurring on one port at the same time as a device is being
unplugged on another port.  This is clearly a hardware bug, and the
software retries were intended to work around it.  In practice only a
couple of software retries are needed; if the transfer hasn't succeeded
by that point then it's never going to succeed.  I set the upper limit
to 32 retries just to be conservative.

Delaying longer in order to allow the device to shape itself up is
generally hopeless.  I've haven't seen more than one or two cases where
that would work -- and it's quite possible that those cases would have
worked out okay if the software retry mechanism had existed back when
they occurred.  If transaction errors aren't caused by noise in the
cable then they are almost always caused by bugs or failures in the
device.  Once a device's firmware has crashed, it doesn't magically fix
itself.

Alan Stern

