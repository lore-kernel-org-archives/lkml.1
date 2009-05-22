Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZEVPMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZEVPMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbZEVPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:12:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55015 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755483AbZEVPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:12:29 -0400
Date: Fri, 22 May 2009 11:12:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
In-Reply-To: <20090522105313.63e309f0@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0905221051350.3006-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Alan Cox wrote:

> > the OP), is to make there be a global "prevent kernel drivers from
> > autobinding to  devices on his port" flag, and manage the rest with
> > lockfiles in userspace.
> 
> Your "practical example" seems to bear no relation to the other stuff,
> its a separate topic altogether.
> 
> Yes a "don't probe this port" would make sense. The fact kernel space
> probes the USB devices by default like the fact we probe partitions by
> default and scan scsi busses by default are all really mistakes inherited
> from traditional OS designs which also mess up virtualisation the same
> way.

I don't understand this comment.  By "probe" I assume you mean
"initialize and enumerate", as opposed to calling various drivers'
probe() routines -- let me know if this isn't what you meant.  If the
kernel didn't initialize and enumerate devices by default, then when
would they get initialized and enumerated?

If your answer is "When requested by a user process", then I'll go on
to ask: What about devices containing the root filesystem, the system 
console, and so on?

And just how does initialization and enumeration mess up 
virtualization?

> So add a skip_ports= facility to the usb core code (or a general
> auto_enumerate=0 and a udev interface to trigger scanning so your udev
> rules can enumerate just the ports you want). That is probably cleaner
> because it makes the identification of ports rather cleaner and clearer.

Anyway, enumeration isn't the problem.  The real problem has two parts:

	Automatic probing and binding of kernel drivers, including
	selection and installation of a configuration (this really
	_does_ mess up virtualization).

	The fact that a window exists immediately after the 
	registration of a newly-detected device before a user
	process can lock the device file.  During this window,
	other processes could open the file.

The second part can be solved (among cooperating processes) by use of
port-lock files, with no kernel involvement.  The first part does
require a kernel interface of some sort, but it wouldn't have to be
complicated.  The mere fact that a port-lock file was open could be
enough to prevent automatic configuration, probing, and binding.

Does this seem like reasonable approach?

Alan Stern

