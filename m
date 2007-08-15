Return-Path: <linux-kernel-owner+w=401wt.eu-S934964AbXHOSi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964AbXHOSi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbXHOSiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:38:13 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:43220 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXHOSiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:38:12 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=S7DS7EDJatZR0Is0BI7+COP5FKJduxeoWfXI1Gb3Pn/DYx7JGONc/xepV7KCbdLzXXVipCE+K/jnkgDJZ2wf2Hyf5/ge9dpQmrvlNsjd0vfi3Qzp1OBnarCNQW0uh+kl;
X-IronPort-AV: E=Sophos;i="4.19,268,1183352400"; 
   d="scan'208";a="318872454"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: EHCI Regression in 2.6.23-rc2
Date: Wed, 15 Aug 2007 13:38:09 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18E9B@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9B18E7F@ausx3mpc125.aus.amer.dell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: EHCI Regression in 2.6.23-rc2
Thread-Index: Acfeir7yhr2kq0PoSiaU2EBYlqjmxwALv1hQACvd/KA=
References: <200708101045.57166.dex@dragonslave.de> <200708140843.42196.webmaster@dragonslave.de> <200708140101.19651.david-b@pacbell.net> <200708141146.43215.webmaster@dragonslave.de> <DFEF91B22ED07447AB6AA4B237F913F9B18E53@ausx3mpc125.aus.amer.dell.com> <20070814154942.A544A2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <DFEF91B22ED07447AB6AA4B237F913F9B18E7F@ausx3mpc125.aus.amer.dell.com>
From: <Stuart_Hayes@Dell.com>
To: <david-b@pacbell.net>, <webmaster@dragonslave.de>
Cc: <linux-usb-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <jikos@jikos.cz>, <greg@kroah.com>
X-OriginalArrivalTime: 15 Aug 2007 18:38:10.0763 (UTC) FILETIME=[6E4181B0:01C7DF6B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes, Stuart wrote:
> David Brownell wrote:
>>> Hm... I've got a 0.95.  I'll try to get a Via EHCI 1.00 controller
>>> and make sure it's the same problem.
>> 
>> Yeah, for some reason way too many of the add-on PCI cards with VIA
>> chips use that pretty-broken VT6202 chip.  Ones with VT6212 are also
>> available, and work a lot better.
>> 
>> 
>>>> Regarding the option to blacklist VIA in the module:
>>>> I would prefer blacklisting VIA by default but giving the module
>>>> some parameter like "honours inactive bit" to override this.
>>>> 
>>>> Perhaps there are newer VIA Chips out there, that indeed do this
>>>> and some users trigger happy enough to test this. :)
>>> 
>>> That kernel parameter sounds like a reasonable idea to me.
>> 
>> Yes, IFF we know that the bug shows up in EHCI 1.00 chips rather than
>> just the already-known-to-be-buggy VT6202 chips.  (I think part of
>> the deal was that until the parts went through some conformance
>> testing, nobody could use the "1.0" label.  There were also a few
>> small feature updates and spec clarifications.  If anyone else
>> shipped silicon in volume that was as buggy as a VT6202, I didn't see
>> any.)
>> 
>> I'd be happy to see a warning come out whenever a VT6202 is found,
>> since its problems are NOT limited to this I-bit bug.
>> 
> 
> OK, I've got a VIA VT6212, and it's definitely not the same as the
> 6202--it's locking up my system, too, with my patch, and it is
> definitely not just ignoring the inactivate bit.  I'm still trying to
> figure out what's going on.   
> 
> The NEC controller (EHCI 1.00) seems to work fine, though.

OK... I see what's happening.  When the VIA VT6212 sees the "inactivate"
bit set, it will START the split transaction, but it doesn't finish it.
When I set the "I" bit--even if I set it like 50 uframes before the
transaction should start--the controller will set bit 1
(splitXstate--this means it's started the transaction) and clear bit 7
(active bit) in the token, when it comes time for the transaction to be
run.

This is a violation of EHCI 1.0 spec section 4.12.2.5, second bullet:

"If the Active bit is a one and the SplitXState is DoStart (regardless
of the value of S-mask), the host
controller will simply set Active bit to a zero... the host controller
must not issue the start-split bus transaction."

With an analyzer, I've observed that the controller is indeed issuing
"start split" without issuing "complete split", and I'm losing
keystrokes if I type when this is happening, as expected.

So... I still think blacklisting the VIA controllers from this CPU
frequency stuff is the best option.  It is unlikely that any real issues
will be seen during CPU frequency transitions with these controllers
anyway, because they claim to cache 8 uframes of the periodic schedule.

