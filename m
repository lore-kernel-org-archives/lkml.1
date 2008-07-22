Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYGVIIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYGVIIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYGVIIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:08:37 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:45094 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbYGVIIf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:08:35 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 10:08:26 +0200
User-Agent: KMail/1.9.9
Cc: Samuel Sieb <samuel@sieb.net>
References: <48841A92.4020301@sieb.net> <200807210828.56821.jbe@pengutronix.de> <48856D32.1070101@sieb.net>
In-Reply-To: <48856D32.1070101@sieb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807221008.27867.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

On Dienstag, 22. Juli 2008, Samuel Sieb wrote:
> Juergen Beisert wrote:
> > On Montag, 21. Juli 2008, Samuel Sieb wrote:
> >> I have a computer here with a CPU that the BIOS identifies as:
> >> Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
> >>
> >> I can't boot any kernel later than 2.6.22 on it.  Anything later either
> >> hangs or gives random kernel panics while booting.  I tracked down the
> >> problem to a specific commit:
> >>
> >> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> >
> > Yes. My patch makes some chipset tweaks working as expected. Or at least
> > it makes them work. It seems nobody ever tested them before. Remove the
> > following line (or change it to meet your CPU clock frequency):
>
> This system is kind of an embedded one and it's been working fine, so I
> haven't bothered upgrading the OS for a long time.  Once I get this
> working I will be keeping it more up to date.
>
> > linux-2.6.25/arch/x86/kernel/cyrix.c, line 151. Disable this line or
> > change the value 0x04 according to the speed of your CPU. This tweak
> > helps others with random hangs of their system.
>
> I tried various values and various combinations of commenting out lines
> and the only one that worked for me was to comment out the PCR1 line
> just above it.  With that line commented out (or both of them), it
> boots.

Hmm, then your BIOS does know more about your hardware than the kernel. ;-)
The PCR1 line enables the incrementor. If disabled the value in PCR0 doesn't 
matter.

> I do get a message about the TSC clocksource being unstable, 
> which is a new feature as well.

Its the "stop the clock if the CPU runs into a halt instruction" feature.
Saves power and keeps your CPU cold. Side effect: It also stops the TSC, while 
the CPU is idle.
You can disable this feature by commenting out the line Ingo mentioned. In the 
case one of these bits was set by your BIOS, your can also revert it:

   setCx86(CX86_CCR2, getCx86(CX86_CCR2) & ~0x88);

This will prevent your CPU from stopping its clock and the TSC should be 
stable. But: It will also disable the clockfrequency driver from work.

Juergen

-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
