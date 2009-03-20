Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZCTPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZCTPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZCTPQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:16:50 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:39559 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZCTPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:16:49 -0400
Message-ID: <49C3B33F.1020905@systec-electronic.com>
Date: Fri, 20 Mar 2009 16:16:15 +0100
From: =?ISO-8859-15?Q?Daniel_Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Michael Olbrich <mol@pengutronix.de>,
       Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320100146.6599f671@lxorguk.ukuu.org.uk> <20090320103545.GQ5367@pengutronix.de> <20090320105556.4375176d@lxorguk.ukuu.org.uk> <20090320111552.GS5367@pengutronix.de>
In-Reply-To: <20090320111552.GS5367@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel schrieb:
> On Fri, Mar 20, 2009 at 10:55:56AM +0000, Alan Cox wrote:
>> It depends where you split the stack between kernel and user space. There
>> needs to be enough in the kernel to allow reasonably efficient
>> multi-process models but that can be a small part of the stack. The
>> Appletalk stack is a good example. Appletalk has a single address/port
>> system for all higher level protocols and the higher level protocols
>> don't interact much with each other. It's actually very elegant in that
>> way. One result of this is that the AF_APPLETALK kernel stack deals only
>> with low level packet routing and delivery. It doesn't have to care about
>> higher stuff to provide the needed separation and sharing. IP by
>> comparison has all sorts of interactions, multiple port addressing
>> schemes and ICMP interactions which mean the kernel has to hold the
>> entire TCP and UDP layers.
> 
> So what "layers" do we have for CANopen, EtherCAT and PowerLink?
> 
> - the lower api is getting ethernet frames
> - the stack itself is a state machine that pushes things to objdict
> - objdict needs to notify applications on certain changes
> - userspace needs to trigger state machine on certain objcict changes by
>   the application
> 
> We can either put the state machine into the kernel or into userspace;
> if userspace, the kernel API is already there (socket), if kernel we
> would need an objdict API.

My understanding of an object dictionary is that it is only a structured 
view to a set of configuration variables, process variables and 
diagnostic information. It could also be an XML file or a simple C 
struct. In our implementation the object dictionary is not necessarily 
the backing store of the data. The process variables for example are 
just linked into the objdict. The application or the process image 
provides the backing store. In the end we can find any appropriate 
structure to pass the configuration from userspace to the data link 
layer and the PDO module in the kernel.

The PDO module is in fact a programmable scatter-gather copy machine 
(like DMA) between process image and Ethernet frames and vice-versa. The 
information of what to copy to where comes from the object dictionary. 
But it is possible to extract this information from the objdict and pass 
it via generic structures (e.g. something like IO vectors) to the PDO 
module in kernel. The information flow of the configuration data is 
one-way only, from userspace to kernel. This is what I plan to implement 
in openPOWERLINK, because the copy information can also be passed to a 
special hardware like a DMA controller.

So you can implement the objdict in userspace and access the process 
image via mmap (e.g. libpv).

cu,
   Daniel

--
SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Telefon  : +49 (0) 3661 6279 0
Fax      : +49 (0) 3661 6279 99
Email    : daniel.krueger@systec-electronic.com
Internet : http://www.systec-electronic.com

Managing Director   : Dipl.-Phys. Siegmar Schmidt
Commercial registry : Amtsgericht Jena, HRB 205563
