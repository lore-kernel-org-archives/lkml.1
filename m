Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbYDSMKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbYDSMKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 08:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYDSMKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 08:10:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42953 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150AbYDSMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 08:10:22 -0400
Message-Id: <1208607019.13829.1248748343@webmail.messagingengine.com>
X-Sasl-Enc: QY7X5PP9w75oGQqty9ZBfhOSDSGTxVRc/zUhp2YIL3yD 1208607019
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "dean gaudet" <dean@arctic.org>, "Joe Perches" <joe@perches.com>
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu>
   <20080401094618.GA24862@mailshack.com>
   <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
   <1207507897.18129.1246358115@webmail.messagingengine.com>
   <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
   <1207563950.7880.1246457209@webmail.messagingengine.com>
   <20080418201809.GA5036@mailshack.com>
   <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
   <1208563762.10414.19.camel@brick>
   <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
   <1208566724.4891.25.camel@localhost>
   <1208567093.10414.20.camel@brick>
   <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
   <1208573728.11990.14.camel@localhost>
   <alpine.DEB.1.10.0804182112360.6108@twinlark.arctic.org>
Subject: Re: Alternative implementation of the generic __ffs
In-Reply-To: <alpine.DEB.1.10.0804182112360.6108@twinlark.arctic.org>
Date: Sat, 19 Apr 2008 14:10:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 21:13:47 -0700 (PDT), "dean gaudet"
<dean@arctic.org> said:
> On Fri, 18 Apr 2008, Joe Perches wrote:
> > On Fri, 2008-04-18 at 18:11 -0700, dean gaudet wrote: 
> > > have you benchmarked it?
> > 
> > I modified Alexander's benchmark:
> > http://lkml.org/lkml/2008/4/18/267
> > to include 32 and 64 bit variants called smallest.
> > 
> > On an old ARM:
> 
> i'm guessing the 32-bit constants suck :(
> 
> the code could be modified to use 16-bit constants only -- it would add 
> some dependent operations though (to move the hot bit into the low 
> 16-bits).
> 
> -dean

That would look like this (although I chose to reduce to less than 128,
due to completely irrelevant x86 considerations ;) ).

static ATTR int __ffs32_smallconstant(unsigned int value)
{
        int x0, x1, x2, x3, x4;
        unsigned int t2, t4;

        value &= -value;
        t2 = value | (value >> 16);
        t4 = t2 | (t2 >> 8);
        x4 = (value << 16) ? 0 : 16;
        x3 = (t2 << 24) ? 0 : 8;
        x2 = (t4 & 0x0f) ? 0 : 4;
        x1 = (t4 & 0x33) ? 0 : 2;
        x0 = (t4 & 0x55) ? 0 : 1;

        return x4 | x3 | x2 | x1 | x0;
}

I've added that to the benchmark, which you can now find here:
http://heukelum.fastmail.fm/ffs/. Testing the same with 
"return x4 + x3 + x2 + x1 + x0;" as the last line would be
interesting too.

Greetings,
    Alexander

> > $ gcc --version gcc (GCC) 3.4.6
> > 
> > $ cat /proc/cpuinfo 
> > Processor	: Intel StrongARM-110 rev 4 (v4l)
> > BogoMIPS	: 262.14
> > Hardware	: Rebel-NetWinder
> > Revision	: 57ff
> > Serial		: 000000000000185c
> > 
> > $ gcc -Os -fomit-frame-pointer ffs.c
> > $ ./a.out
> > Original:       3180 tics,  8379 tics
> > New:            4280 tics,  8890 tics
> > Smallest:       4027 tics,  7835 tics
> > Empty loop:     1543 tics,  2260 tics
> > 
> > $ gcc -O2 -fomit-frame-pointer ffs.c
> > $ ./a.out
> > Original:       3161 tics,  7843 tics
> > New:            4778 tics,  8783 tics
> > Smallest:       4408 tics,  7149 tics
> > Empty loop:     1515 tics,  2140 tics
> > 
> > $ gcc -O3 -fomit-frame-pointer ffs.c
> > $ ./a.out
> > Original:       3078 tics,  7692 tics
> > New:            4714 tics,  8671 tics
> > Smallest:       4344 tics,  7117 tics
> > Empty loop:     1444 tics,  2024 tics

Thanks for testing, Harvey!
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - IMAP accessible web-mail

