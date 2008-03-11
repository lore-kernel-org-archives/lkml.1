Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYCKUW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYCKUW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYCKUWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:22:20 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:60838 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbYCKUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:22:19 -0400
X-Belgacom-Dynamic: yes
Date: Tue, 11 Mar 2008 21:22:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Samuel Tardieu <sam@rfc1149.net>, junker@anduras.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: w83697hf_wdt.c stops watchdog on load
Message-ID: <20080311202214.GA7505@infomag.infomag.iguana.be>
References: <47D564CA.1040507@draigBrady.com> <2008-03-10-18-48-16+trackit+sam@rfc1149.net> <47D5C1DC.6080808@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47D5C1DC.6080808@draigBrady.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pádraig, Samuel,

> > | I noticed that this driver (which is based on my w83627hf_wdt.c driver)
> > | stops the watchdog when the driver is loaded.
> > | 
> > | This seems like the wrong thing to do.
> > | What happens if the watchdog is enabled in the BIOS which is very common,
> > | and the software crashes between the watchdog module being loaded,
> > | and the watchdog being pinged?

Let's take a step back and look at the "API". The watchdog drivers in Linux
were developed when BIOSses only coped with the basic stuff. The API that
was created is basically the following:
* The watchdog device-driver loads your watchdog driver and does the
initialization of the watchdog and then enables user-space access via
/dev/watchdog.
* the userspace watchdog daemon then
	1) starts the watchdog by opening /dev/watchdog
	2) pings the watchdog (by writing to /dev/watchdog or by using a
	ioctl command on /dev/watchdog).
	3) stops the watchdog by closing the /dev/watchdog "device".

This means that the /dev/watchdog interface is the key in controlling the
watchdog driver. The default behaviour is and was that the watchdog does not
work/run. Why? Simply because the userspace daemon has to have control
over when the watchdog is started, stopped and pinged and also because you
don't want the system to reboot before the watchdog-userspace-daemon has been
activated. The system operator off-course can decide when he wants to start
the userspace watchdog daemon (before loading other processes or after the
web-server is up because it also monitors the web-server, ...).

Based on the above explanation and API, I can acknowledge that the normal
behaviour is that the watchdog device driver stops the watchdog when loaded.
(Please also bear in mind that certain watchdog devices can only be started
and not stopped).

So the driver has the correct behaviour.

> > During the test phase of the module with users of the French servers
> > at dedibox.fr, I had one report of a bios-enabled watchdog which seemed
> > to be rebooting the machine during a long fsck (the module was compiled
> > in the kernel if I remember correctly).
> > 
> > Isn't it a two-edged sword?
> 
> True, but one should be able to set things up so that there is no race.
> I.E. if you add the autodisable, it should only be done as an option.
> Best have it =no by default, but as least one could turn this off.

In my opinion it should be the other way around: the default behaviour is to
stop the watchdog and to let userspace (the watchdog-daemon) control the
watchdog. So if we add a module parameter to take over the watchdog's
bios-setting, then the default behaviour should be to stop the watchdog and
add an option that takes the value from the bios.

> A more general question though. Do any other watchdogs do this?
> Seems fundamentally wrong to me. Also aren't all long running operations
> like fsck done in userspace? (where the watchdog process can run in parallel).
> If you really can't get userspace running within 4 mins say, then
> I would suggest that you just disable the watchdog in the BIOS.

Yes, almost all watchdog drivers do this. Do not forget that there are also watchdog
devices around that have a timeout/keepalive value from only a few seconds till
+-60 seconds. so waiting 4 minutes is not do-able for them.

Greetings,
Wim.


