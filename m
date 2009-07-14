Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZGNQnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZGNQnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbZGNQnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:43:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbZGNQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:43:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: access_ok macor
Date: Tue, 14 Jul 2009 18:43:05 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
References: <4A5C8068.6020203@monstr.eu> <200907141652.59049.arnd@arndb.de> <4A5CAEFF.9080206@monstr.eu>
In-Reply-To: <4A5CAEFF.9080206@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907141843.05629.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18yCWut4FgRdRI6YJfKYJ55V5bBFb2Z6Crlo+Y
 GNbGy3JaEtjT4OO83ahhXuZSifj4BlvTdkFvfGMCSW996KZL9e
 8w/jue4NcL+02L0v05qHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 July 2009, Michal Simek wrote:
> Arnd Bergmann wrote:

> >>  r29=00000000, r30=00000000, r31=CE9759A4, rPC=C000123C
> >>  msr=800045AE, ear=00000001, esr=000000B2, fsr=000080D0
> >> Segmentation fault
> >>
> > 
> > I guess then you should check if 0xc000123c is in your
> > exception table, or why it is not.
> 
> on that address is load instruction for unaligned exception because addr is odd number
> that's why is called unaligned exception handler and from this function
> is called load instruction which failed. :-(
> 
> Currently this make more sense why that tests failed. If that pointers are
> even number exception is not taken and exception sure don't have fixup for it because
> this is generic code. :-(
> 
> That's the problem because we are looking for regs->pc but this point to unaligned exception
> handler.

Ok, that makes a lot of sense.

The solution then is to handle fixups from the unaligned exception handler
if you come from the kernel. That should fix the three text cases.

I don't fully understand your exception handling there, but I think you
also need to add code checking for __range_ok() to your unaligned handler,
to prevent malicious user space code from accessing the kernel through
unaligned pointers.

	Arnd <><
