Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbZFMWcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbZFMWcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZFMWci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:32:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZFMWch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:32:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 06/27] score: create head files delay.h device.h div64.h dma-mapping.h dma.h
Date: Sun, 14 Jun 2009 00:31:54 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <OF676F75F6.AE51CF2E-ON482575D4.00241202-482575D4.0024AEE4@sunplusct.com>
In-Reply-To: <OF676F75F6.AE51CF2E-ON482575D4.00241202-482575D4.0024AEE4@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
Message-Id: <200906140031.55091.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18wZLM7Jvd1SmKtEJrGXxs2odDdxEskeBSDGFZ
 zfrOyANY9V/i8Ki5wbMBcfp0mTafjvim20CuOIbXoOKgZAeV/y
 E++zZb5Y+jqSM5M0u2jx3w+L81NG98y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, liqin.chen@sunplusct.com wrote:
> Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-06-10 01:18:20:
> 
> > On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> > 
> > Having a working udelay() function is required for many
> > drivers that are sensitive to timing, you should probably
> > implement that at some point in the future.
> 
> Add udelay() implement in code.

so you use 

static inline void __delay(unsigned long loops)
{
        __asm__ __volatile__ (
                "1:\tsubi\t%0,1\n\t"
                "cmpz.c\t%0\n\t"
                "bne\t1b\n\t"
                : "=r" (loops)
                : "0" (loops));
}

static inline void __udelay(unsigned long usecs)
{
        __delay(usecs);
}


This is much better than before, but is far from exact in the __udelay()
case. Please take a look at init/calibrate.c and how other architectures
use loops_per_jiffy if you don't have an exact time source you can use.

If you have a time source with microsecond resolution or better, just loop
until the amount of microseconds has expired.

	Arnd <><
