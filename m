Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZGLPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZGLPQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 11:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZGLPQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 11:16:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37978 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753804AbZGLPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 11:16:32 -0400
Date: Sun, 12 Jul 2009 11:16:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: uhci_hcd fails to off-line device/hub on error condition
In-Reply-To: <200907111407.54152.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907121104360.17691-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Michael S. Zick wrote:

> - - Megabytes of the same snipped - -
> uhci_hcd 0000:00:10.2: host controller process error, something bad happened!
> uhci_hcd 0000:00:10.1: host system error, PCI problems?
> uhci_hcd 0000:00:10.1: host controller process error, something bad happened!
> uhci_hcd 0000:00:10.2: host system error, PCI problems?
> uhci_hcd 0000:00:10.2: host controller process error, something bad happened!
> 
> - - driver can detect unexpected behavior sufficent to post the messages - -
> 
> uhci_hcd 0000:00:10.1: host system error, PCI problems?
> uhci_hcd 0000:00:10.1: host controller process error, something bad happened!
> 
> - - but never does anything about it - other than bitch - -

Yep.  The problem identified by those messages is supposed to be very
rare -- they mean that the PCI bus is overloaded and consequently the
USB controller wasn't able to transfer the data it needed sufficiently
rapidly.  (Except in your case, where they really mean that something
is wrong with the hardware.  But how can the kernel be expected to
realize this?)

The driver doesn't do anything about it because there's nothing to be
done.  Bus overloads are very rare and quickly go away by themselves.  
It isn't a fatal error.

Now, I suppose we could add a test for badly misbehaving hardware.  
You can do it yourself: In drivers/usb/host/uhci-hcd.c, find the big
"if" statement in uhci_irq() that tests for any unexpected bits in
the "status" variable.  Try printing out the value of status; if it
turns out to be 0xffff then we can detect your problem and take the
controller offline.

Alan Stern

