Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYAHAMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYAHAMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbYAHAL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:11:57 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61616 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbYAHALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:11:55 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ZFAAggQUbzQCKA0Cc/Tvx
Message-ID: <4782BF77.80703@reed.com>
Date: Mon, 07 Jan 2008 19:10:31 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl> <4782B4B9.2020608@zytor.com> <4782B515.3010008@keyaccess.nl>
In-Reply-To: <4782B515.3010008@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On another topic.  I have indeed determined what device uses port 80 on 
Quanta AMD64 laptops from HP.

I had lunch with Jim Gettys of OLPC a week ago; he's an old friend since 
he worked on the original X windows system.   After telling him my story 
about port 80, he mentioned that the OLPC XO machine had some issues 
with port 80 which was by design handled by the ENE KBC device on its 
motherboard.   He said the ENE was a very desirable chipset for AMD 
designs recommended by Quanta.  Richard Smith of OLPC explained to me 
how the KB3700 they use works, and that they use the KB3700 to send POST 
codes out over a serial link during boot up.

This gave me a reason to take apart my laptop, to discover that it has 
an ENE KB3920 B0 as its EC and KBC.  The port interface for the KB3920 
includes listening to port 80 which is then made available to firmware 
on the EC.  It is recognized and decoded on the LPC bus, only for 
writes, and optionally can generate an interrupt in the 8051.

Dumping both the ENE chip, and looking at the DSDT.dsl for my machine, I 
discovered that port 80 is used as an additional parameter for various 
DSDT methods that communicate to the EC, when it is operating in ACPI mode.

More work is in progress as I play around with this.  But the key thing 
is that ACPI and perhaps SMM both use port 80 as part of the base 
function of the chipset.

And actually, if I had looked at the /sys/bus/pnp definitions, rather 
than /proc/ioports, I would have noticed that port 80 was part of a 
PNP0C02 resource set.   That means exactly one thing:  ACPI says that 
port 80 is NOT free to be used, for delays or anything else.

This should make no difference here: it's just one more reason to stop 
using port 80 for delays on modern machines.

