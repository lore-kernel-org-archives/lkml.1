Return-Path: <linux-kernel-owner+w=401wt.eu-S1762395AbXHNPYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762395AbXHNPYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXHNPX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:23:58 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:1709 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbXHNPX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:23:57 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 11:23:57 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=gl9xENJqlokrfaJjEsdOt+NMAuE9BD+qOKSlGYJynVjef8SRENWupnpMZONHgtZ6ziG6dveDkqyAcHxe7xJGX5gHsc5x1PavILYogfuZXwADtQd8syiNANGCEszFC5ml;
X-IronPort-AV: E=Sophos;i="4.19,260,1183352400"; 
   d="scan'208";a="317364717"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: EHCI Regression in 2.6.23-rc2
Date: Tue, 14 Aug 2007 10:13:41 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18E53@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <200708141146.43215.webmaster@dragonslave.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: EHCI Regression in 2.6.23-rc2
Thread-Index: AcfeWBsfyVB2/3MmQUGMPuqHx9Jk4gALGo+g
References: <200708101045.57166.dex@dragonslave.de> <200708140843.42196.webmaster@dragonslave.de> <200708140101.19651.david-b@pacbell.net> <200708141146.43215.webmaster@dragonslave.de>
From: <Stuart_Hayes@Dell.com>
To: <webmaster@dragonslave.de>, <david-b@pacbell.net>
Cc: <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>, <jikos@jikos.cz>
X-OriginalArrivalTime: 14 Aug 2007 15:14:18.0684 (UTC) FILETIME=[C8F49FC0:01C7DE85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Exner wrote:
> David Brownell wrote:
>> On Monday 13 August 2007, Daniel Exner wrote:
> [..]
>>> Where exactly should I search for this? Neither lspci nor lsusb
>>> showed any hint on the EHCI rev. the chip conforms to..
>> 
>> The driver logs that information as it starts; on this sytem:
>> 
>>  ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec
>> 2004 
>> 
>> vs "EHCI 0.95".
> ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> 
> Build into:
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge
> [K8T800/K8T890 South] 
> 

Hm... I've got a 0.95.  I'll try to get a Via EHCI 1.00 controller and
make sure it's the same problem.

>>>>> I've also acquired a card with an NEC EHCI controller on it,
>>>>> which I'm going to look at while I'm into it...
>>>> 
>>>> Another case where there are a lot of add-on "EHCI 0.95" cards;
>>>> but in this case the quirks were less significant.
>>> 
>>> Some guy donated me a PCMCIA card with one of those, cause it'll
>>> wont work in his Windows only Notebook :)
>> 
>> A NEC 0.95 ??  Should be fine with Linux.  Assuming no bugs have
>> crept in.
> Didn't test it yet with 2.6.23-rc2 or rc3, but up to 2.6.22 it was
> fine :) 
> 
> Regarding the option to blacklist VIA in the module:
> I would prefer blacklisting VIA by default but giving the module some
> parameter like "honours inactive bit" to override this. 
> 
> Perhaps there are newer VIA Chips out there, that indeed do this and
> some users trigger happy enough to test this. :) 

That kernel parameter sounds like a reasonable idea to me.  The problem
that the patch is trying to work around is that, while the CPUs are
changing frequency, the EHCI controller gets delayed trying to read main
memory (because CPU cache snoops have to wait until the CPU is
finished)... if this happens in the middle of a split transaction to a
low/full speed device, the transaction won't complete in time, and you
get an error and possible data loss.

If the EHCI controller caches ahead enough, it shouldn't need to read
main memory to be able to complete the split transaction... but, while
the controller does say how much ahead it may cache, it isn't clear to
me that it will always be able to cache that much, so I thought it would
be safe to go ahead and inactivate split transactions during CPU
frequency transitions regardless.

