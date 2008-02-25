Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYBYBP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYBYBP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYBYBPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:15:19 -0500
Received: from smtp3.clear.net.nz ([203.97.33.64]:35619 "EHLO
	smtp3.clear.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYBYBPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:15:18 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 20:15:17 EST
Date: Mon, 25 Feb 2008 14:04:01 +1300
From: Eliot Blennerhassett <linux@audioscience.com>
Subject: Q: volatile vs barriers to access memory data changed by device DMA
To: linux-kernel@vger.kernel.org
Message-id: <200802251404.01874.linux@audioscience.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Currently I have a driver that uses "volatile", which I want to remove.
As others have said "volatile is useless"
Heres the relevant source.
http://hg.alsa-project.org/alsa-driver/file/89222d702376/pci/asihpi/hpi6205.c

There's quite a bit written about barriers, but most seems to be assuming SMP 
situation or memory mapped devices. Not much about devices doing DMA.
I.e I have read Documentation/memory-barriers.txt, and some of the threads in 
lkml, but still am unsure.

The "volatile" is applied to structures that are either read or written by 
device DMA.  Certainly the driver in its current state doesn't work without 
volatile qualifier. (BTW the device doesn't use host interrupts)

Now, I want to get rid of the volatile, and replace it with ?some kind of 
barrier?

In the following, am I using the barriers correctly?

Note that structures ("interface") used for dma are allocated with 
dma_alloc_coherent()

1) Reading something updated by DMA
Here the volatile or barrier is needed or the loop gets optimised away.

=== current code
volatile struct bus_master_interface *interface;
while (interface->ack != OK) { 
        delay(a short while)          
        [ after X loops device changes interface->ack by dma ]
};

=== after conversion
struct bus_master_interface *interface;
while (interface->ack != OK) { 
        delay(a short while);
        rmb(); 
        [ after X loops device changes interface->ack by dma ]
};

All I need is for the read of interface->ack in the loop not to be optimised 
away - is rmb() the appropriate incantation to achieve this?

2) Writing to memory, interrupt device
Need command to be in memory for device to read by DMA before device gets 
interrupted.

=== current code ===
volatile struct bus_master_interface *interface;
interface->cmd = command;
iowrite(device_interrupt, 1);
[device reads interface->cmd by dma]

=== after conversion ===
struct bus_master_interface *interface;
interface->cmd = command;
wmb();
iowrite(device_interrupt, 1);
[device reads interface->cmd by dma]

Is the wmb() a guarantee that the command will be in memory visible to the 
device when the driver informs it of a new command?
Is it even needed? I.e. does iowrite() effectively form a barrier?

regards

--
Eliot Blennerhassett
www.audioscience.com
