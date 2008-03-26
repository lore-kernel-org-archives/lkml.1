Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbYCZA6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbYCZA6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYCZA6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:58:14 -0400
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:53720 "EHLO
	lemon.gelato.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYCZA6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:58:13 -0400
Date: Wed, 26 Mar 2008 11:57:23 +1100
Message-ID: <87lk465mks.wl%peter@chubb.wattle.id.au>
From: Peter Chubb <peterc@gelato.unsw.edu.au>
To: "David Mosberger-Tang" <dmosberger@gmail.com>
Cc: "Peter Chubb" <peterc@gelato.unsw.edu.au>,
       "David Miller" <davem@davemloft.net>, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org,
       ianw@gelato.unsw.edu.au
In-Reply-To: <ed5aea430803251734u70f199w10951bc4f0db6262@mail.gmail.com>
References: <Pine.LNX.4.64.0803241402060.7762@schroedinger.engr.sgi.com>
	<20080324.144356.104645106.davem@davemloft.net>
	<Pine.LNX.4.64.0803251045510.16206@schroedinger.engr.sgi.com>
	<20080325.162244.61337214.davem@davemloft.net>
	<87tziu5q37.wl%peter@chubb.wattle.id.au>
	<ed5aea430803251734u70f199w10951bc4f0db6262@mail.gmail.com>
User-Agent: Wanderlust/2.15.6 (Almost Unreal) SEMI/1.14.6 (Maruoka) FLIM/1.14.9 (Goj~) APEL/10.7 MULE XEmacs/21.4 (patch 20) (Double Solitaire) (i486-linux-gnu)
Organization: Gelato@UNSW
X-SA-Exim-Connect-IP: 203.143.174.121
X-SA-Exim-Mail-From: peterc@gelato.unsw.edu.au
Subject: Re: larger default page sizes...
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:39:27 +0000)
X-SA-Exim-Scanned: Yes (on lemon.gelato.unsw.edu.au)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "David" == David Mosberger-Tang <dmosberger@gmail.com> writes:

David> On Tue, Mar 25, 2008 at 5:41 PM, Peter Chubb
David> <peterc@gelato.unsw.edu.au> wrote:
>> The main issue is that, at least on Itanium, you have to turn off
>> the hardware page table walker for hugepages if you want to mix
>> superpages and standard pages in the same region. (The long format
>> VHPT isn't the panacea we'd like it to be because the hash function
>> it uses depends on the page size).

David> Why not just repeat the PTEs for super-pages?  That won't work
David> for huge pages, but for superpages that are a reasonable
David> multiple (e.g., 16-times) the base-page size, it should work
David> nicely.

You end up having to repeat PTEs to fit into Linux's page table
structure *anyway* (unless we can change Linux's page table).  But
there's no place in the short format hardware-walked page table (that
reuses the leaf entries in Linux's table) for a page size.  And if you
use some of the holes in the format, the hardware walker doesn't
understand it --- so you have to turn off the hardware walker for
*any* regions where there might be a superpage.  

If you use the long format VHPT, you have a choice:  load the
hash table with just the translation that caused the miss, load all
possible hash entries that could have caused the miss for the page, or
preload the hash table when the page is instantiated, with all
possible entries that could hash to the huge page.  I don't remember
the details, but I seem to remember all these being bad choices for
one reason or other ... Ian, can you elaborate?

--
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
