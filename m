Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYHWLnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYHWLnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 07:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYHWLmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 07:42:54 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:26762 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752762AbYHWLmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 07:42:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=C2ul5Is97B89+79UIkr8DbqIIgGRyVdQFJ0YqKXbPOQeBQesBhxCcf7/uHfab99tvtIMAhbQHkJ6K1yRM6wmIde+Sy0FQo0DVWiORgVsIWfKfgh05+9Q7rmIXPLYMf3ZAQTiGS52bIehpzwcaYgJNj0/mbXSn2Rlkbm9qG9wSHY=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Sat, 23 Aug 2008 04:42:52 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
       Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <959691.49749.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> pnp 00:0d: mem resource (0xfed00000-0xfed000ff) overlaps 0000:00:14.0
> BAR 1 (0xfed00000-0xfed003ff), disabling
> request_resource: root: (PCI IO) [0, ffff], new: (0000:00:14.0) [fa00,
> fa0f] conflict 0
> request_resource: root: (PCI mem) [0, ffffffffffffffff], new:
> (0000:00:14.0) [fed00000, fed003ff] conflict 1
> pci 0000:00:14.0: BAR 1: can't allocate resource
> piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xfa00, revision 0
> 
> 
> because  (0000:00:14.0) [fed00000, fed003ff]  conflicts to (reserved)
> [fec00000, ffffffff] from e820.

[...]

> so old kernel lapic 0xfee0000, is insert at first, it will prevent
> 0xfec, ... 0xfffffff from e820 to be registered,
> then (0000:00:14.0) [fed00000, fed003ff] got chance to be
> registered..., timer will work...
> 
> 
> root cause could be the chipset BAR1
> request_resource: root: (PCI mem) [0, ffffffffffffffff], new:
> (0000:00:14.0) [fed00000, fed003ff] conflict 1
> is not handled properly...
> 
> guess when it can not get request_resource, it could clear that
> BAR1...may need one quirk to save that.
> just like we trust IO APIC addr in BAR for some devices.

Ahh, thank you for reviewing that with me.  It looks like you are
getting very close to a fix.

FYI, I have asked the other user who first reported a similar problem
(back in May) to try booting his kernel with "hpet=disable" and
report his results here.  We cannot be sure that his problem is
identical to mine, but I believe he has been compiling his own
kernels since May by manually reverting commit number 3def3d6d.

I'm hoping that he will be able to help us test patches which attempt
to fix the problem, but my understanding is that he is using the
machine quite heavily... so he may not be willing to do as much
testing as I.

I do know that his kernel hangs at a different point in the kernel
sources:  mine hangs before inet_init() returns, while his hangs
in ide_scan_pcibus() [or pci_init(), if he tried to add printk's
to the previous function, trying to get more info].

I'm hoping that the changes in 3def3d6d aren't going to force the
kernel team to create a different quirk for each motherboard that
experiences kernel hangs!  Once 2.6.26, there is some possibility
that you will start seeing a lot more reports of it.  (I'm hoping
not, though.)


Thanks,
Dave W.
