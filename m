Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYABR0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYABR0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbYABR03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:26:29 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:31227 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752339AbYABR02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:26:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=c495ejbFROvVZmex/TGYx/S0uqtj383vUJCK44jZ97gAJOcZpzql0o9I9g2mUg6QOgwSyChjHFJ8iMxH477ShIJQzOdltEFGIrvSdU6tH0TitqSW80gL3ElAxZ4pZBeMSB7dIjEAyegDf7hTcaw0cKU8p010Ac79LCNLjWDosJE=  ;
X-YMail-OSG: oHUw3mAVM1mKxCYLZT_03SL_G1moYbLUG4LIyI9sUcdptGKcsOtB.evoipWCMdYsu25z9oI_IQ--
Date: Wed, 02 Jan 2008 09:26:25 -0800
From: David Brownell <david-b@pacbell.net>
To: rjw@sisk.pl, mingo@elte.hu
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended 
 (rev. 2)
Cc: a.zummo@towertech.it, stern@rowland.harvard.edu, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org, gregkh@suse.de,
       akpm@linux-foundation.org
References: <200801020032.45529.rjw@sisk.pl>
 <20080102105217.GA14731@elte.hu> <200801021356.59865.rjw@sisk.pl>
 <20080102131529.GA32160@elte.hu>
In-Reply-To: <20080102131529.GA32160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080102172625.CE0C2F6DFE@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Alessandro Zummo Cc:-ed too -- RTC subsystem maintainer)

> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> > Well, we have the following test script in the userland suspend 
> > package that is supposed to work right now:
> > 
> > #!/bin/bash
> > date
> > cd /sys/class/rtc/rtc0
> > echo $(( $(cat since_epoch) + 20 )) > wakealarm
> > s2ram
> > date
> > 
> > provided that the new rtc driver code is compiled (and the old one is not).

Eventually, swapping driver modules ought to work too.  The
legacy /proc/acpi/wakeup files would ISTR cause problems in
current code.

Of course, one reason to want to use the RTC framework code
is to stop depending on x86-isms like ACPI or "s2ram", and
thus to work on more Linux platforms.  ;)


> ok, will try that. A stupid question. The old RTC driver is in 
> drivers/char/rtc.c, and maps to:
>
>   crw-r--r-- 1 root root  10, 135 Oct 25 18:02 /dev/rtc
>
> the new driver is in drivers/rtc/*, and maps to:
>
>   crw-r--r-- 1 root root 254,   0 Dec 12 02:30 /dev/rtc0
>
> but all the x86 distro boxes i have access to make use of /dev/rtc. 
> There's no symlink set up from /dev/rtc to /dev/rtc0 either.

Current util-linux-ng code uses either RTC device file; and udev
sets up /dev/rtc0 as needed.  (But not /dev/rtc, as I recall...)
Have distros switched away from the old unmaintained util-linux?


>	So it 
> appears to me that the new RTC driver isnt actually utilized on most 
> distributions.

That might be so.  There are some HPET issues, but those show up with
both drivers.

The main other issue I know about which would seem to argue for using
the legacy driver, instead of the RTC framework, is that some BIOSes
don't seem to provide PNPACPI entries for their RTCs.  I got one report
of a newish HP Opteron system that doesn't.  I have no idea how common
that is.  The drivers/acpi/glue.c code could detect that, but maybe a
better place to address that would be in PNP code; in that case, ISTR
that PNP0c01 claimed the RTC ioports, and so would be the natural place
to make provide a real driver model node for that hardware.



> shouldnt we provide a Kconfig way of replacing dev 10:135 with the new 
> driver's 254:0 device? (while keeping all the current modes of operation 
> as well, of course.)

The major number 254 is not statically allocated, ISTR; that should
be managed only by udev.


> 			 It's all supposed to be 100% ioctl ABI compatible 
> with the old driver, right? That way distros could start migrating to it 
> as well, without depending on any udev hackery.

I don't know of any ioctl differences userspace would care about.

- Dave

