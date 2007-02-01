Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbXBAAW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbXBAAW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933376AbXBAAW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:22:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60772 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933318AbXBAAW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:22:57 -0500
Date: Wed, 31 Jan 2007 16:19:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?Pawe=C5_Sikora?= <pluto@agmk.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Adrian Bunk <bunk@stusta.de>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Linux 2.6.20-rc7
In-Reply-To: <200702010037.48472.pluto@agmk.net>
Message-ID: <Pine.LNX.4.64.0701311609210.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
 <45C05150.6000802@agmk.net> <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
 <200702010037.48472.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-2110606773-1170289146=:3632"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-2110606773-1170289146=:3632
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Thu, 1 Feb 2007, PaweÅ Sikora wrote:
> 
> 2.6.18 works, 2.6.19-rc1 doesn't work.
> git bisect found this bad commit:

Git bisect rocks.

I'll give myself yet abother pat on the back for writing it. You can never 
encourage genius like that too much.

> commit e80ee884ae0e3794ef2b65a18a767d502ad712ee
> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> Date:   Wed Oct 4 02:15:23 2006 -0700
> 
>     [PATCH] mm: micro optimise zone_watermark_ok
>
> reverting mentioned commit removes the oops.

Ok, that commit is just totally broken.

If "free_pages" turns negative (which it can, since it's just doing a

	long free_pages = z->free_pages - (1 << order) + 1;

to initialize it, and for all we know, you have an empty or close-to-empty 
zone or two, the whole test to do

	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
		return 0;

gets broken, because the negative 'free_pages' will look like a huge 
unsigned positive number (and we'll make it unsigned becaue 'min' got 
turned unsigned). There was a reason that thing was signed in the first 
place, and neither me nor Andrew noticed.

Bad Nick. And bad me and Andrew for not noticing.

I should either revert that commit or just check for "free_pages" being 
negative. The latter, in many ways, is probably better, because generally 
we simply should never work with negative numbers in the kernel, so when 
something potentially goes negative, we're probably just better off always 
testing it explicitly anyway.

Nick, Andrew, any preferences? 

			Linus
---1463790079-2110606773-1170289146=:3632--
