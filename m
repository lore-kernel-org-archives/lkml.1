Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYAJOnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYAJOnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbYAJOnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:43:09 -0500
Received: from aleve.media.mit.edu ([18.85.2.171]:1204 "EHLO
	aleve.media.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYAJOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:43:07 -0500
Message-ID: <47862E92.8010003@reed.com>
Date: Thu, 10 Jan 2008 09:41:22 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Robert Hancock <hancockr@shaw.ca>,
       Christer Weinigel <christer@weinigel.se>,
       Zachary Amsden <zach@vmware.com>, Avi Kivity <avi@quramnet.com>,
       Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <fa.u5p8NBl8IjcycTVVtf0K+YtqNQc@ifi.uio.no> <fa.NOJkdyuk0c8CAqzZcG+pF1TzhJM@ifi.uio.no> <fa.YLAHN7jSUo9phsICUHnxilN7/lk@ifi.uio.no> <fa.SvgVgdNA9oz4F+tQ9MB2VRwr8ck@ifi.uio.no> <fa.By1MDYK0MY/fwkCWWrAiQCxl5KM@ifi.uio.no> <fa.97XrGLIGlvAy4P/TB5vHHrfBrIw@ifi.uio.no> <478568E3.6040409@shaw.ca> <47856A69.1090500@keyaccess.nl>
In-Reply-To: <47856A69.1090500@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rene Herman wrote:
> On 10-01-08 01:37, Robert Hancock wrote:
>>
>> I agree. In this case the BIOS on these laptops is trying to tell us 
>> "port 80 is used for our purposes, do not touch it". We should be 
>> listening.
>
> Listening is fine but what are you going to do after you have 
> listened? Right, not use port 0x80 but since that's the current idea 
> anyway outside of legacy drivers, you don't actually need to listen.
>
> If the quirk-to-0xed or similar was to stay, it's a much better 
> switching point than DMI strings but if not, it's not actually important.
Well, I was just suggesting a warning that would come up when a driver 
that still used port 80 was initialized...
I think that is what Alan Cox and others suggest for legacy drivers that 
have worked - I agree that it may not be the right thing to screw them 
up, especially since my laptop, and probably most machines that might 
start using port 80 or other "legacy ports" won't ever need those drivers.

I thought more about a complete solution last night.   A clean idea that 
really fits the linux design might be the following outline of a patch. 
I suspect it might seem far less ugly, and probably would meet Alan 
Cox's needs, too - I am very sympathetic about not breaking 8390's, etc.

Define a "motherboard resources" driver that claims all the resources 
defined for PNP0C02 devices during the pnp process.   I think Windoze 
actually does something quite similar.   This would claim port 80.

Define an iodelay driver.  This driver exists largely to claim port 80 
for the iodelay operation  (you could even define an option for other 
ports).  Legacy drivers would be modified to require iodelay.  The 
iodelay driver would set up the iodelay mechanism to do something other 
than the "boot time" default - which could be no delay, or udelay.  It 
would also set a flag that says "_b operations are safe".

Put a WARN_ONCE() in the in/out*_b operations that checks the flag that 
is set by the iodelay driver.  This would only trigger in the case that 
80 or whatever was reserved by some other device driver - such as the 
motherboard resources driver above.  Modern machines won't do that.

Finally, anything that happens before the motherboard resources and 
iodelay drivers are initialized cannot use in*_p or out*_p (whether they 
can be loadable modules rather than built in is a question).  This is a 
very small set, and I believe with the exception of the PIT (8253/4) are 
very safe.

Note that this idea is also compatible with rewriting all drivers to use 
"iodelay()" explicitly instead of _p().  But it doesn't require that.

>
> Rene.
>
