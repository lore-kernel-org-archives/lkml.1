Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbXEUBWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbXEUBWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXEUBWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:22:33 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:43924 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754235AbXEUBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:22:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iWbSmaAxBcBV7BtRd+hlkhxEjJcJWBFCt1QtL28mP+5KuxHgCe49OZ0XaZ3mafE0pgtAZZ1aJnXz1e7jHs/Y4Cpm1RRMFdjxdKWedQYo8EPDyHuc0Zyl+1Z3TiM7QtVgEPasK7WRN4bvcdjpJpEXvAasLeo0zAReD8vwAdX7tUQ=  ;
X-YMail-OSG: SpvXtyQVM1kwyKVzyV2sWcD4oVDhMwg3yE_QDYLyvMHhLRhkVttsy8fPf46XH6cyYo8Pw1eGsQ--
From: David Brownell <david-b@pacbell.net>
To: Mattia Dongili <malattia@linux.it>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR
Date: Sun, 20 May 2007 18:22:23 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>
References: <20070518071523.GA3195@inferi.kami.home> <200705201138.05146.david-b@pacbell.net> <20070521004119.GA3103@inferi.kami.home>
In-Reply-To: <20070521004119.GA3103@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201822.24138.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2007, Mattia Dongili wrote:
> 
> $ cat /proc/acpi/wakeup
> Device	S-state	  Status   Sysfs node
> PWRB	  S4	*enabled   
> S1F0	  S4	 disabled  
> S1F1	  S4	 disabled  
> S1F2	  S4	 disabled  
> S1F3	  S4	 disabled  
> S1F4	  S4	 disabled  
> S1F5	  S4	 disabled  
> S1F6	  S4	 disabled  
> S1F7	  S4	 disabled  
> TLAN	  S3	 disabled  pci:0000:07:00.0
> DLAN	  S3	 disabled  
> S6F0	  S4	 disabled  
> S6F1	  S4	 disabled  
> S6F2	  S4	 disabled  
> S6F3	  S4	 disabled  
> S6F4	  S4	 disabled  
> S6F5	  S4	 disabled  
> S6F6	  S4	 disabled  
> S6F7	  S4	 disabled  
> USB1	  S3	 disabled  pci:0000:00:1d.0
> USB2	  S3	 disabled  pci:0000:00:1d.1
> USB3	  S3	 disabled  pci:0000:00:1d.2
> USB4	  S3	 disabled  pci:0000:00:1d.3
> USB7	  S3	 disabled  pci:0000:00:1d.7
> SLT0	  S4	 disabled  
> LANC	  S3	 disabled  
> EC0	  S5	 disabled  

That's strangely busy ... what ARE all those devices?  :)

But only the PCI ones -- or certain devices connected to USB
root hubs -- could be affected by that patch.

So another experiment you could do, if you want faster info
than "git bisect" can provide, is building drivers for those
PCI devices as modules (ehci-hcd, uhci-hcd, sky2) and then
finding which one causes the trouble by removing them before
STR.


> $ cat /proc/bus/usb/devices
> 
> T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
> B:  Alloc= 45/900 us ( 5%), #Int=  1, #Iso=  1
> D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=0000 ProdID=0000 Rev= 2.06
> S:  Manufacturer=Linux 2.6.22-rc1-mm1-bisect uhci_hcd
> S:  Product=UHCI Host Controller
> S:  SerialNumber=0000:00:1d.3
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
                          ^^
Just FYI, any USB device with the 0x20 bit set could in
some cases become a wakeup event source.  All hubs (root
and otherwise) set that.  So do a couple of the devices
you show ...

> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
> 
> ...
> 
> T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
> D:  Ver= 1.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=0483 ProdID=2016 Rev= 0.01
> S:  Manufacturer=STMicroelectronics
> S:  Product=Biometric Coprocessor
> C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
                          ^^
This one does.  I seem to recall hearing about some trouble associated
with this and sleep/wakeup processing, but I forget about the
details.


> I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=83(I) Atr=03(Int.) MxPS=   4 Ivl=20ms
> 
> ...
> 
> 
> $ sudo ethtool eth0
> Settings for eth0:
> 	Supported ports: [ TP ]
> 	Supported link modes:   10baseT/Half 10baseT/Full 
> 	                        100baseT/Half 100baseT/Full 
> 	                        1000baseT/Half 1000baseT/Full 
> 	Supports auto-negotiation: Yes
> 	Advertised link modes:  10baseT/Half 10baseT/Full 
> 	                        100baseT/Half 100baseT/Full 
> 	Advertised auto-negotiation: Yes
> 	Speed: 100Mb/s
> 	Duplex: Full
> 	Port: Twisted Pair
> 	PHYAD: 0
> 	Transceiver: internal
> 	Auto-negotiation: on
> 	Supports Wake-on: pg
> 	Wake-on: d

So wake-on-LAN is disabled here ... it *should* avoid
turning on the PCI wake mechanisms.  On the other hand,
a quick look at that driver shows that it's rather
broken in how it calls pci_enable_wake().


> 	Current message level: 0x000000ff (255)
> 	Link detected: yes
> 
> $ sudo ethtool -i eth0
> driver: sky2
> version: 1.14
> firmware-version: N/A
> bus-info: 0000:07:00.0
> 
> > And, for a bit more info, the output of the appended script.
> 
>            on  acpi_system:00/device:00/PNP0C0C:00
>            on  pci0000:00/0000:00:1d.7/usb1
>            on  pci0000:00/0000:00:1d.7
>            on  pci0000:00/0000:00:1d.3/usb5
>            on  pci0000:00/0000:00:1d.3
>            on  pci0000:00/0000:00:1d.2/usb4/4-1
>            on  pci0000:00/0000:00:1d.2/usb4
>            on  pci0000:00/0000:00:1d.2
>            on  pci0000:00/0000:00:1d.1/usb3
>            on  pci0000:00/0000:00:1d.1
>            on  pci0000:00/0000:00:1d.0/usb2
>            on  pci0000:00/0000:00:1d.0
>            on  pci0000:00/0000:00:1c.2/0000:07:00.0

Other than the curious lack of labeling on the USB and
network nodes there (maybe the script cares about the
legacy sysfs files? it's a couple years old now) that
doesn't say anything new.


> > My suspicion, based on the dmesg and seeing what drivers actually
> > try to enable wakeup, would be the 'sky2' driver.  The other two
> 
> FWIW the sky2 is never functional upon resume, I need to ifdown, rmmod,
> modprobe and ifup again to get some networking...

Try "rmmod sky2" *before* suspend, to see if that matters.

Also "rmmod uhci-hcd", which will keep USB from doing anything
with that biometric thingie.

I suspect one or the other of those will be the issue.

- Dave

