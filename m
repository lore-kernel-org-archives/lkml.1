Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXBYTFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXBYTFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965111AbXBYTFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:05:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56372 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965107AbXBYTFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:05:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.19: ACPI reports AC not present after resume from STD
Date: Sun, 25 Feb 2007 19:58:36 +0100
User-Agent: KMail/1.9.5
Cc: "Lebedev, Vladimir P" <vladimir.p.lebedev@intel.com>,
       "Karasyov, Konstantin A" <konstantin.a.karasyov@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@osdl.org>
References: <8E389A5F2FEABA4CB1DEC35A25CB39CE82FE9F@mssmsx411> <200702251151.12107.rjw@sisk.pl> <200702252014.26110.arvidjaar@mail.ru>
In-Reply-To: <200702252014.26110.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702251958.37315.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 February 2007 18:14, Andrey Borzenkov wrote:
> On Воскресенье 25 февраля 2007, Rafael J. Wysocki wrote:
> > On Sunday, 25 February 2007 11:37, Andrey Borzenkov wrote:
> > > On Воскресенье 25 февраля 2007, Rafael J. Wysocki wrote:
> > > > On Sunday, 25 February 2007 00:26, Andrey Borzenkov wrote:
> > > > > On Суббота 24 февраля 2007, Rafael J. Wysocki wrote:
> > > > > > Hi,
> > > > > >
> > > > > > On Saturday, 24 February 2007 10:55, Andrey Borzenkov wrote:
> > > > > > > On Вторник 13 февраля 2007, Andrey Borzenkov wrote:
> > > > > > > > On Четверг 07 декабря 2006, Lebedev, Vladimir P wrote:
> > > > > > > > > Please register new bug, attach acpidump and dmesg.
> > > > > > > >
> > > > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=7995
> > > > > > > >
> > > > > > > > regards
> > > > > > >
> > > > > > > Well, this starts looking like ACPI is not at fault.
> > > > > > >
> > > > > > > When reporting AC state ACPI just reads contents of system memory
> > > > > > > (I presume it gets updated by BIOS/ACPI when AC state changes).
> > > > > > > It looks like this memory area is restored during resume from
> > > > > > > STD. I updated mentioned bug report with more detailed
> > > > > > > description. Now if someone could suggest a way to catch if
> > > > > > > specific physical address gets saved/restored this would finally
> > > > > > > explain it.
> > > > > >
> > > > > > First, if you want the reserved memory areas to be left alone by
> > > > > > swsusp, you need to mark them as 'nosave'.  On x86_64 this is done
> > > > > > by the function e820_mark_nosave_range() in
> > > > > > arch/x86_64/kernel/e820.c that can be ported to i386 with no
> > > > > > problems.  However, we haven't found that very useful, so far,
> > > > > > since no one has ever reported any problems with the current
> > > > > > approach, which is to save and restore them.
> > > > >
> > > > > Well, the following proof of concept patch fixes this issue for me.
> > > > > Please notice that original version of e820_mark_nosave_range() could
> > > > > fail to exclude some areas due to alignment issues (exactly what
> > > > > happened to me on first try) so it still can explain your problem
> > > > > too.
> > > >
> > > > Great job, thanks for the patch!  It looks good, so I'm going to
> > > > forward it for merging.
> > >
> > > Please no; I'm currently testing slightly more polished version; I will
> > > send it later.
> >
> > OK
> >
> > > Could anybody explain (or give pointer to) what happens which region that
> > > is not page-aligned? In particular, the very first one:
> > >
> > >  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> > >  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> > >
> > > Will the kernel allocate partial page (how?) or will the kernel ignore
> > > last (first) incomplete page? In the former case how those incomplete
> > > pages can be detected?
> >
> > Well, on x86_64, if I understand e820_register_active_regions() correctly,
> > the partial pages won't be registered.
> >
> 
> It appears that for low memory kernel will ignore incomplete pages for sure. I 
> hope it does the same for high memory - but for now I just throw this in and 
> pray :)

You don't need to do this for highmem, because swsusp won't save reserved
highmem pages anyway.

> This also significantly simplifies patch. 
> 
> As this touches quite sensitive field, I Cc Andrew - if he considers this 
> appropriate for mm; or would you do it as part of your tree? Also he probably 
> can easily clarify memory allocation questions :p

The patch looks good, but the changelog does not.  First, AFAICT, the x86_64
code doesn't touch anything outside the e820 map.  Why do you think it does?

Second, it is not true that the region in question is at 0xee00 on x86_64.
At least on my box it's above the end of RAM.

I think the x86_64 version is correct too.

Greetings,
Rafael
