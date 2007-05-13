Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbXEMLpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbXEMLpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 07:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbXEMLpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 07:45:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43346 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbXEMLpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 07:45:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4646F9F6.3040308@s5r6.in-berlin.de>
Date: Sun, 13 May 2007 13:43:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Ismail D?nmez <ismail@pardus.org.tr>, Adrian Bunk <bunk@stusta.de>,
       Thomas Meyer <thomas@m3y3r.de>, Tobias Diedrich <ranma@tdiedrich.de>
Subject: Re: [PATCH 2.6.21-rc4] ieee1394: fix oops on "modprobe -r ohci1394"
 after network class_device conversion
References: <200703140642.28390.ismail@pardus.org.tr> <200703150051.29945.ismail@pardus.org.tr> <45F88E8B.90403@s5r6.in-berlin.de> <200703150249.04169.ismail@pardus.org.tr> <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de> <20070320233432.GA20228@kroah.com> <tkrat.f2e7e842cff5a275@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f2e7e842cff5a275@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote on 2007-03-21:
> On 20 Mar, Greg KH wrote:
>> On Tue, Mar 20, 2007 at 10:43:22PM +0100, Stefan Richter wrote:
>>> @@ -586,7 +586,10 @@ static void ether1394_add_host (struct h
>>>          }
>>>  
>>>  	SET_MODULE_OWNER(dev);
>>> +#if 0
>>> +	/* FIXME - Is this the correct parent device anyway? */
>>>  	SET_NETDEV_DEV(dev, &host->device);
>>> +#endif
>> That's interesting.  What does 'tree /sys/class/net/' look like with
>> this patch applied?  Does the eth1394 device now live off in
>> /sys/device/virtual?
> 
> Yes.
> 
> lrwxrwxrwx  1 root root 0 Mär 21 01:02 eth0 -> ../../devices/pci0000:00/0000:00:0b.0/eth0/
> lrwxrwxrwx  1 root root 0 Mär 21 01:02 eth1 -> ../../devices/virtual/net/eth1/
> lrwxrwxrwx  1 root root 0 Mär 21 01:02 lo -> ../../devices/virtual/net/lo/
> 
> (eth1 is IP over 1394 alias eth1394. eth0 is an actual ethernet
> interface.)
> 
> And eth1/device (ex -> ../../../devices/pci*___*/fw-host*) is now gone.
> Would anybody miss it?
> 
>> If so, I guess this is ok for now as we can wait for the rewrite of the
>> ieee1394 subsystem to get the linking done correctly :)
> 
> That's my hope too.

Alas there is some userspace breakage:
https://bugs.gentoo.org/show_bug.cgi?id=177199

| Ethernet over firewire devices (driver: eth1394) have - starting with
kernel
| 2.6.21 - no longer a proper parent-device/subsystem in sysfs.
|
| The code change resulting in this is:
[...]
| This missing parent-device breaks persistence-net, as that adds
DRIVERS=="?*"
| to the generated rules, but the driver-attribute resides in the
parent-device
| that no longer is available now.
|
| This leads to not matching the existing rule, but at every boot
running into
| the code to get a new number for the interface, and thus enlarging the
ruleset
| with one line at every boot.

I didn't notice this problem on my own Gentoo box here.  But then I
rarely reboot and don't automatically load eth1394 anymore since I
applied a post-2.6.21 patch which uncouples ieee1394 from eth1394.  I
still load it manually for frequent testing though.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
