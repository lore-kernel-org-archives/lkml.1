Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbXGYMhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbXGYMhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXGYMhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:37:37 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:4426 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbXGYMhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mUBaIhh8ZCq3ahSNdKIwvPGXZIDnHEe6am3H+psT9BNslWbYFETSDuc15cMQpMQkJ+LoZJ7YmuRnd6PvKCNL80/W6GDcYV/Hh/JAOLnYlpr7DZrWrJZ7u4EcplNRqgw4c1CpZRRZh/OPkIJkKWws5TAt9ePhE9S8X91uusOZWfk=
Message-ID: <a781481a0707250537h41f8fc0dy234743c6492a8403@mail.gmail.com>
Date: Wed, 25 Jul 2007 18:07:31 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Print utsname on Oops on all architectures
Cc: "Joshua Wise" <jwise@google.com>, linux-kernel@vger.kernel.org,
       "Tim Hockin" <thockin@google.com>, "Mike Waychison" <mikew@google.com>,
       "Masoud Asgharifard Sharbiani" <masouds@google.com>
In-Reply-To: <20070724224209.5dd511b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707051847030.617@internets.corp.google.com>
	 <20070724224209.5dd511b3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 5 Jul 2007 18:52:27 -0700 (PDT) Joshua Wise <jwise@google.com> wrote:
>
> > Background:
> >  This patch is a follow-on to "Info dump on Oops or panic()" [1].
> >
> >  On some architectures, the kernel printed some information on the running
> >  kernel, but not on all architectures. The information printed was generally
> >  the version and build number, but it was not located in a consistant place,
> >  and some architectures did not print it at all.
> >
> > Description:
> >  This patch uses the already-existing die_chain to print utsname information
> >  on Oops. This patch also removes the architecture-specific utsname
> >  printers. To avoid crashing the system further (and hence not printing the
> >  Oops) in the case where the system is so hopelessly smashed that utsname
> >  might be destroyed, we vsprintf the utsname data into a static buffer
> >  first, and then just print that on crash.
> >
> > Testing:
> >  I wrote a module that does a *(int*)0 = 0; and observed that I got my
> >  utsname data printed.
> >
> > Potential impact:
> >  This adds another line to the Oops output, causing the first few lines to
> >  potentially scroll off the screen. This also adds a few more pointer
> >  dereferences in the Oops path, because it adds to the die_chain notifier
> >  chain, reducing the likelihood that the Oops will be printed if there is
> >  very bad memory corruption.
>
> There are strange happenings due to this patch on i386:
>
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> hdc: max request size: 128KiB
> hdc: 156355584 sectors (80054 MB) w/1819KiB Cache, CHS=65535/16/63, UDMA(33)
> hdc: cache flushes supported
>  hdc:<0>Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
>  hdc1 hdc2 hdc3 hdc4 <<0>Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
>  hdc5<0>Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
>  hdc6 >
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> initcall 0xc052a060: idedisk_init+0x0/0x10() returned 0.
> initcall 0xc052a060 ran for 38 msecs: idedisk_init+0x0/0x10()
> Calling initcall 0xc052a070: ide_cdrom_init+0x0/0x10()
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> initcall 0xc052a070: ide_cdrom_init+0x0/0x10() returned 0.
> initcall 0xc052a070 ran for 3 msecs: ide_cdrom_init+0x0/0x10()
> Calling initcall 0xc052a080: idetape_init+0x0/0x90()
> initcall 0xc052a080: idetape_init+0x0/0x90() returned 0.
> initcall 0xc052a080 ran for 0 msecs: idetape_init+0x0/0x90()
> Calling initcall 0xc052a110: idefloppy_init+0x0/0x20()
> ide-floppy driver 0.99.newide
> initcall 0xc052a110: idefloppy_init+0x0/0x20() returned 0.
> initcall 0xc052a110 ran for 0 msecs: idefloppy_init+0x0/0x20()
> Calling initcall 0xc052a3e0: spi_transport_init+0x0/0x30()
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
> initcall 0xc052a3e0: spi_transport_init+0x0/0x30() returned 0.
> initcall 0xc052a3e0 ran for 3 msecs: spi_transport_init+0x0/0x30()
> Calling initcall 0xc052a410: fc_transport_init+0x0/0x50()
> initcall 0xc052a410: fc_transport_init+0x0/0x50() returned 0.
> initcall 0xc052a410 ran for 0 msecs: fc_transport_init+0x0/0x50()
> Calling initcall 0xc052a460: init_sd+0x0/0x90()
> initcall 0xc052a460: init_sd+0x0/0x90() returned 0.
> initcall 0xc052a460 ran for 0 msecs: init_sd+0x0/0x90()
>
> and it gets no further.
>
> I'll drop it - let's start again?

Ugh, there's a silly mistake there -- the notifier call function is missing a
(diecode == DIE_OOPS) check. Not all die notifications are oopsen -- we
need to filter out the cases we don't care about.


Satyam
