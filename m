Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbZCXQjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbZCXQjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758995AbZCXQjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:39:02 -0400
Received: from stinky.trash.net ([213.144.137.162]:38322 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762811AbZCXQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:38:57 -0400
Message-ID: <49C90C99.30805@trash.net>
Date: Tue, 24 Mar 2009 17:38:49 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Matt Domsch <Matt_Domsch@dell.com>, netdev@vger.kernel.org,
       linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
References: <20090324154617.GA16332@auslistsprd01.us.dell.com>	 <49C9087C.5070907@trash.net> <ac3eb2510903240928s6c42bc32pa0cd8a7f0e69b731@mail.gmail.com>
In-Reply-To: <ac3eb2510903240928s6c42bc32pa0cd8a7f0e69b731@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Tue, Mar 24, 2009 at 17:21, Patrick McHardy <kaber@trash.net> wrote:
>> Matt Domsch wrote:
>>>   c) udev may not always be able to change a device's name.  If udev
>>>      uses the kernel assignment namespace (ethN), then a rename of
>>>      eth0->eth1 may require renaming eth1->eth0 (or something else).
>>>      Udev operates on a single device instance at a time, it becomes
>>>      difficult to switch names around for multiple devices, within
>>>      the single namespace.
>> I would classify this as a bug, especially the fact that udev doesn't
>> undo a failed rename, so you end up with ethX_rename. Virtual devices
>> using the same MAC address trigger this reliably unless you add
>> exceptions to the udev rules.
> 
> This is handled in most cases. Virtual interfaces claiming a
> configured name and created before the "hardware" interface are not
> handled, that's right, but pretty uncommon.

I don't remember the exact circumstances, but I've seen it quite a few
times. I'll gather some information next time.

>> You state that it only operates on one device at a time. If that is
>> correct, I'm not sure why the _rename suffix is used at all instead
>> of simply trying to assign the final name, which would avoid this
>> problem.
> 
> How? The kernel assignes the names and the configured names may
> conflict. So you possibly can not rename a device to the target name
> when it's name is already taken. I don't see how to avoid this.

Sure, you can't rename it when the name is taken. But what udev
apparently does when renaming a device is:

- rename eth0 to eth0_rename
- rename eth0_rename to eth2
- rename returns -EEXISTS: udev keeps eth0_rename

What it could do is:

- rename eth0 to eth2
- rename returns -EEXISTS: device at least still has a proper name

Alternatively it should unroll the rename and hope that the
old name is still free. But I don't see why the _rename step
would do any good, assuming only a single device is handled at
a time, it can't prevent clashes.
