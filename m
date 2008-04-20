Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYDTIme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYDTIme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYDTImY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:42:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51491 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbYDTImX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:42:23 -0400
Message-Id: <1208680941.5276.1248837773@webmail.messagingengine.com>
X-Sasl-Enc: mRqIPEfMQj/PO8KgMrYrivD7PZgG7URQPTUZjNT4Xi1L 1208680941
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Joe Perches" <joe@perches.com>, "Matti Aarnio" <matti.aarnio@zmailer.org>
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
   <1207563950.7880.1246457209@webmail.messagingengine.com>
   <20080418201809.GA5036@mailshack.com>
   <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
   <1208563762.10414.19.camel@brick>
   <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
   <1208566724.4891.25.camel@localhost>
   <1208567093.10414.20.camel@brick>
   <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
   <1208573728.11990.14.camel@localhost>
   <20080419222911.GJ3700@mea-ext.zmailer.org>
   <1208660817.12388.40.camel@localhost>
Subject: Re: Alternative implementation of the generic __ffs
In-Reply-To: <1208660817.12388.40.camel@localhost>
Date: Sun, 20 Apr 2008 10:42:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 20:06:57 -0700, "Joe Perches" <joe@perches.com>
said:
> On Sun, 2008-04-20 at 01:29 +0300, Matti Aarnio wrote:
> > I am curious, why not take the code already in glibc ffs() for ARM ?
> > That is, if the ffs() is all that important detail in kernel ?

Hi,

The glibc version is based on a table-lookup. This makes it
behave differently in hot and cold cache situations. That's
fine if __ffs is used in tight loops, but in the kernel such
use of __ffs is avoided because it might be slow. I added it
to the benchmark, but it would need testing for the cold
cache case too.

As for the importance of __ffs in the kernel: as far as I
know the hot-spots in the kernel using __ffs are the
schedular (sched_find_first_bit) and the cpu mask walking
code (for_each_cpu_mask).

Greetings,
    Alexander

> Here's test results with the glibc ffs implementation.
> (small const is still using slower add rather than or)

Added, thanks.

> $ gcc -Os -fomit-frame-pointer ffs.c
> $ ./a.out
> Original:       3155 tics,  8331 tics
> New:            4211 tics,  8793 tics
> Smallest:       4019 tics,  7754 tics
> Small const:    3552 tics,  6308 tics
> glibc:          2816 tics,  6911 tics
> Empty loop:     1516 tics,  2244 tics
> 
> $ gcc -O2 -fomit-frame-pointer ffs.c
> $ ./a.out
> Original:       3155 tics,  7828 tics
> New:            4792 tics,  8825 tics
> Smallest:       4401 tics,  7155 tics
> Small const:    3539 tics,  5805 tics
> glibc:          2720 tics,  7061 tics
> Empty loop:     1516 tics,  2148 tics
> 
> $ gcc -O3 -fomit-frame-pointer ffs.c
> $ ./a.out
> Original:       3080 tics,  7706 tics
> New:            4721 tics,  8663 tics
> Smallest:       4334 tics,  7116 tics
> Small const:    3466 tics,  5672 tics
> glibc:          2649 tics,  6939 tics
> Empty loop:     1444 tics,  2012 tics
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

