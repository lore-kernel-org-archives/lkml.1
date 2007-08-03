Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbXHCQD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbXHCQD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761210AbXHCQDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:03:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:54090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761064AbXHCQDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:03:50 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX19EzFN6E35EUI2SZjBfhYvRXUbMYHQRFj4G6h7ya0
	of0Aqd/rMyLRsR
Message-ID: <46B351FB.1000507@gmx.net>
Date: Fri, 03 Aug 2007 18:04:11 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Gabriel C <nix.or.die@googlemail.com>, Sasa Ostrouska <casaxa@gmail.com>,
       Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: forcedeth ?
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>	 <46AE6029.60308@googlemail.com> <46AE6372.20808@googlemail.com>	 <46AE9221.70302@gmx.net>	 <3ae72650707301852p7289cc42of3e2a0ec2c62a5e1@mail.gmail.com> <3ae72650708020433u2f423862t973dff85f85870a0@mail.gmail.com>
In-Reply-To: <3ae72650708020433u2f423862t973dff85f85870a0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.2007 13:33, Kay Sievers wrote:
> On 7/31/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On 7/31/07, Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net> wrote:
>>> On 31.07.2007 00:17, Gabriel C wrote:
>>>> Sasa Ostrouska wrote:
>>>>
>>>>> Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
>>>>> to check that, thx for the tip.
>>>> Yes udev does this based on the MAC address but AFAIK forcedeth is 'special' for some reason
>>>> ( which I can really remember now and gets on each boot a new MAC address or alike )
>>> Ah yes, that's a workaround for certain buggy boards to make sure you're
>>> not left without networking even if the MAC address stored on the board
>>> is bogus.
>>>
>>> Basically, forcedeth checks if the MAC address supplied by your
>>> mainboard is bogus and autogenerates a random MAC address from a private
>>> range (prefix 00:00:6c) as workaround. However, it will complain loudly
>>> if it has to do that.
>>>
>>> Quoting from forcedeth.c:
>>>> if (!is_valid_ether_addr(dev->perm_addr)) {
>>>>       /*
>>>>        * Bad mac address. At least one bios sets the mac address
>>>>        * to 01:23:45:67:89:ab
>>>>        */
>>>>       printk(KERN_ERR "%s: Invalid Mac address detected: %02x:%02x:%02x:%02x:%02x:%02x\n",
>>>>               pci_name(pci_dev),
>>>>               dev->dev_addr[0], dev->dev_addr[1], dev->dev_addr[2],
>>>>               dev->dev_addr[3], dev->dev_addr[4], dev->dev_addr[5]);
>>>>       printk(KERN_ERR "Please complain to your hardware vendor. Switching to a random MAC.\n");
>>>>       dev->dev_addr[0] = 0x00;
>>>>       dev->dev_addr[1] = 0x00;
>>>>       dev->dev_addr[2] = 0x6c;
>>>>       get_random_bytes(&dev->dev_addr[3], 3);
>>>> }
>>> Sometimes it helps to update the BIOS and/or set the MAC address which
>>> is printed on the board as MAC address in the BIOS.
>> In any case, it would be nice if the network core could add something like:
>>   MAC_ORIGIN=device
>>   MAC_ORIGIN=user
>>   MAC_ORIGIN=random
>> or whatever makes sense here, to the uevent environment. So userspace
>> can handle according to that, like falling back using the
>> bus-slot-number to lookup the persistent name, or whatever is
>> appropriate.
> 
> Can't we use the "locally administered" bit in the MAC address? By
> checking for ENV{address}=="?[2367abef]:*", we would skip the
> persistent rule generation based on the MAC address?

Yes and no. Theoretically, that would work. However, there are two
problems with your rule specification:
- ENV{address}=="?[13579bdf]:*" are multicast addresses, so you wouldn't
want them tobe part of a network card MAC address at all.
- http://standards.ieee.org/regauth/oui/oui.txt tells us that the
following OIDs would be excluded by your rule:
02-07-01   (hex)                RACAL-DATACOM
02-1C-7C   (hex)                PERQ SYSTEMS CORPORATION
02-60-86   (hex)                LOGIC REPLACEMENT TECH. LTD.
02-60-8C   (hex)                3COM CORPORATION
02-70-01   (hex)                RACAL-DATACOM
02-70-B0   (hex)                M/A-COM INC. COMPANIES
02-70-B3   (hex)                DATA RECALL LTD
02-9D-8E   (hex)                CARDIAC RECORDERS INC.
02-AA-3C   (hex)                OLIVETTI TELECOMM SPA (OLTECO)
02-BB-01   (hex)                OCTOTHORPE CORP.
02-C0-8C   (hex)                3COM CORPORATION
02-CF-1C   (hex)                COMMUNICATION MACHINERY CORP.
02-E6-D3   (hex)                NIXDORF COMPUTER CORPORATION
AA-00-00   (hex)                DIGITAL EQUIPMENT CORPORATION
AA-00-01   (hex)                DIGITAL EQUIPMENT CORPORATION
AA-00-02   (hex)                DIGITAL EQUIPMENT CORPORATION
AA-00-03   (hex)                DIGITAL EQUIPMENT CORPORATION
AA-00-04   (hex)                DIGITAL EQUIPMENT CORPORATION

Since it seems that real OIDs conflict with the "locally adminstered"
bit of the MAC address, I don't see a way to use the MAC address as
indicator for persistent rule eligibility.


Regards,
Carl-Daniel
