Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYAIPUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYAIPUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYAIPTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:19:55 -0500
Received: from aleve.media.mit.edu ([18.85.2.171]:4623 "EHLO
	aleve.media.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYAIPTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:19:54 -0500
X-Greylist: delayed 1104 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 10:19:53 EST
Message-ID: <4784DD4B.1050101@reed.com>
Date: Wed, 09 Jan 2008 09:42:19 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Zachary Amsden <zach@vmware.com>, Avi Kivity <avi@quramnet.com>,
       Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com> <20080109063052.48a5709c@weinigel.se>
In-Reply-To: <20080109063052.48a5709c@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
>
> Did I miss anyting?
>
>   
Nothing that seems *crucial* going forward for Linux.  The fate of
"legacy machines" is really important to get right.

I have a small suggestion in mind that might be helpful in the future:
the  "motherboard resources" discovered as PNP0C02 devices in their _CRS
settings in ACPI during ACPI PnP startup should be reserved (or
checked), and any drivers that still use port 80 implicitly should
reserve that port.

This may be too late in the boot process to make a decision not to use 
port 80, and it
doesn't help decide a strategy to use an alternate port (0xED happens to
"work" on the dv9000 machines in the sense that it generates a bus
timeout on LPC, but there is no guarantee that 0xED is free on any 
particular motherboard, and "unusedness" is not declared in any 
BIOS/ACPI tables) or to use a udelay-based iodelay (but there is nothing 
in the BIOS tables that suggest the right delays for various I/O ports 
if any modern parts need them...which I question, but can't prove a 
negative in general).

However, doing the reservations on such resources could generate a 
warning that would help diagnose new current and future
designs including devices like the ENE KB3920 that have a port that is
defaulted to port 80 and routed to the EC for functions that the 
firmware and ACPI can agree to do.  Or any other ports used in new ways 
and properly notified to the OS via the now-standard Wintel BIOS functions.

I don't know if /proc/ioports is being maintained, but the fact that it
doesn't contain all of those PNP0C02 resources known on my machine seems 
to be a bug - which I am happy to code a patch or two for as a 
contribution back to Linux, if it isn't on the way out as the /sys 
hierarchy does a better job.
/sys/bus/pnp/... does get built properly and has port 80 described
properly - not as a DMA port, but as a port in use by device 05:00, 
which is the motherboard resource catchall.  Thus the patch would be small.


