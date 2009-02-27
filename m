Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZB0Tlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZB0Tlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbZB0Tl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:41:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:39509 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbZB0Tl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:41:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,278,1233561600"; 
   d="scan'208";a="434794830"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "jeremy@goop.org" <jeremy@goop.org>,
       "cpw@sgi.com" <cpw@sgi.com>, "mingo@elte.hu" <mingo@elte.hu>
Date: Fri, 27 Feb 2009 11:41:19 -0800
Subject: RE: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Thread-Topic: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Thread-Index: AcmXwM5l8v/kfNxlSNimiu+apqx0GABUFi5Q
Message-ID: <57C9024A16AD2D4C97DC78E552063EA361A02359@orsmsx505.amr.corp.intel.com>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
 <200902192221.52835.rusty@rustcorp.com.au> <499E1D01.2040408@kernel.org>
 <200902241326.23605.rusty@rustcorp.com.au> <49A389F7.9030002@kernel.org>
 <57C9024A16AD2D4C97DC78E552063EA361924956@orsmsx505.amr.corp.intel.com>
 <49A609E0.5040807@kernel.org>
In-Reply-To: <49A609E0.5040807@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah... I see, so the 64k limit for small offset.  I think what we can

The 64k currently in use is detemined by the TLB page size that was chosen
for the percpu area.  We can move up to a larger size (but supported page
sizes increase in even powers of two, so next up from 64K is 256K, then 1M).
Just changing PERCPU_PAGE_SHIFT in asm/page.h is sufficient to use a different
page size.

> do is using the first chunk for static percpu variables.  We'll still
> be able to use the same accessor by doing something like...
>
> #define unified_percpu_accessor(ptr) ({ \
>       if (__builtin_constant_p(ptr)) \
>               return r0 - unit_size + ptr; \
>       else \
>               do ar.k3 + ptr; \
>       })
>
> So, dynamic ones will be slower than normal ones but faster than what
> we currently have (it will be faster than indirect pointer
> derferencing, right?)

Depends on how many dynamic percpu accesses are being done, and how close
together they are.  The read of ar.k3 looks to take about 30ns on my test
machine.  Faster than a memory access, but slower than a cache-hit. So
a small sequence of close together dynamic percpu accesses will go
faster with dereferencing than looking at ar.k3 for each one.

 while keeping static accesses fast.  Does it
> sound okay to you?  Also, does anyone know whether there's a working
> ia64 emulator?  There doesn't seem to be any and it seems almost
> impossible to get hold of an actual ia64 machine over here.  :-(

The HP "ski" simulator: http://www.hpl.hp.com/research/linux/ski/ might
do what you want ... but I haven't actually booted a kernel on it in
a very long time.

-Tony

