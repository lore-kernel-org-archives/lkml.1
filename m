Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYEQNtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYEQNtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYEQNtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:49:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2675 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751937AbYEQNtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:49:06 -0400
Date: Sat, 17 May 2008 09:49:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
In-Reply-To: <8db1092f0805162359k2def1738s91cc78d48bea2581@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0805170933530.22979-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: 2.6.26-rc2 doesn't detect a USB drive's write-protect setting 
correctly.

On Sat, 17 May 2008, Maciej Rutecki wrote:

> 2.6.25.4 (works fine):
> http://unixy.pl/maciek/download/kernel/2.6.25.4/syslog_debug.txt
> http://unixy.pl/maciek/download/kernel/2.6.25.4/usbmon.txt
> 
> 2.6.26-rc2 ("write protect is on" problem; can't mount device):
> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/syslog_debug.txt
> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/usbmon.txt

I'm not sure exactly what changed to cause this regression, but the 
problem lies in the SCSI layer, not the USB layer.

The logs show that in response to the 192-byte MODE SENSE command (used
to read the write-protect status), the device sends back no data, good
status, and Residue = 192.  The SCSI core ignores the Residue and
thinks that the old left-over data in the buffer (in this case left
over from the READ CAPACITY command) actually indicates the
write-protect status -- which it obviously doesn't.

Boaz, is scsi_mode_sense() the right place to check for this sort of 
thing?  It probably should be treated the same as an Illegal Request 
error.

Alan Stern

