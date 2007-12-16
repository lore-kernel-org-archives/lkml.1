Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbXLPAYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbXLPAYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbXLPAYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:24:32 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:51833 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbXLPAYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:24:31 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/4LOodnstoNZDVm6PxO3GR
Message-ID: <47647017.60909@reed.com>
Date: Sat, 15 Dec 2007 19:23:51 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, rol@witbe.net,
       Allen Martin <AMartin@nvidia.com>
Subject: Re: [PATCH] x86: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com>
In-Reply-To: <476462BE.3030701@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we go.

# dmidecode -s baseboard-manufacturer
Quanta
# dmidecode -s baseboard-product-name
30B9

There do seem to be other systems, besides mine, that have the same 
problem.  I think it's pretty likely that other machines that have this 
problem are Quanta machines, since Quanta is one of the primary ODM's 
that does HP laptops.   Don't know about the product-name being common 
with the HP dv6000z family, which is another one reported to have this 
problem.  We could try to ask all the reporters of hwclock freezes to 
report their results from dmidecode.


Rene Herman wrote:
> On 15-12-07 21:27, H. Peter Anvin wrote:
>
>> Rene Herman wrote:
>>>
>>> Yes, just posted a Patch-For-Comments that switches on the 
>>> availability of a TSC (tsc_init sets tsc_disable also for 
>>> !cpu_has_tsc) which would mean that only really old stuff would be 
>>> using the outb still. A TSC is really all we need to have a sensible 
>>> udelay().
>>
>> Uhm, no.  You have no clue what the speed of the TSC is until you 
>> have been able to calibrate it against a fixed timesource - like the 
>> PIT.
>
> Yes. Hnng. Okay, this is going nowhere in a hurry, so back to the very 
> first suggestion in this thread. How about this? This allows to switch 
> from port 0x80 to port 0xed based on DMI.
>
> David: I plugged in my own DMI values for testing, but obviously yours 
> are needed. The values that are needed are retrieved by the 
> "dmidecode" program which you will probably have installed (it might 
> be in an sbin directory) or will be able to install through whatever 
> package manager you use.
>
> dmidecode -s baseboard-manufacturer
> dmidecode -s baseboard-product-name
>
> are the values you should plug into the .matches field in the 
> dmi_system_id struct in this. It would be great if you could do that, 
> test, and post back with those values. .ident should be a nice human 
> name.
>
> It's been tested on x86-32 and seems to work fine. It's not been 
> tested on x86-64 but seems to stand a fair chance of working similarly.
>
> It ofcourse remains possible to switch to a udelay() based method 
> later on anyways but with all the pre-calibratin trouble, this might 
> be the lowest risk method in the short run.
>
> This is partly based on previous patches by Pavel Machek and David P. 
> Reed.
>
> I hope this is considered half-way correct/sane (note by the way that 
> it's not a good idea to switch a "native_io_delay_port" value since 
> plugging in a variable port would clobber register dx for every 
> outb_p, which would then have to be reloaded for the next outb again). 
> Comments appreciated.
>
> Signed-off-by: Rene Herman <rene.herman@gmail.com>
>
>  arch/x86/boot/compressed/misc_32.c |    8 ++---
>  arch/x86/boot/compressed/misc_64.c |    8 ++---
>  arch/x86/kernel/Makefile_32        |    2 -
>  arch/x86/kernel/Makefile_64        |    2 -
>  arch/x86/kernel/io_delay.c         |   53 
> +++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/setup_32.c         |    2 +
>  arch/x86/kernel/setup_64.c         |    2 +
>  include/asm-x86/io_32.h            |   17 ++---------
>  include/asm-x86/io_64.h            |   23 ++++++----------
>
