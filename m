Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZBNAqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZBNAqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZBNApx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:45:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:56639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbZBNApx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:45:53 -0500
Message-ID: <4996141A.1050506@kernel.org>
Date: Sat, 14 Feb 2009 09:45:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <49939964.4070607@kernel.org> <49939B08.1050801@kernel.org> <200902140728.55954.rusty@rustcorp.com.au>
In-Reply-To: <200902140728.55954.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Feb 2009 00:45:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 12 February 2009 14:14:08 Tejun Heo wrote:
>> Oops, those are the same ones.  I'll give a shot at cooking up
>> something which can be dynamically sized before going forward with
>> this one.
> 
> That's why I handed it to you! :)
> 
> Just remember we waited over 5 years for this to happen: the point of these
> is that Christoph showed it's still useful.
> 
> (And I really like the idea of allocing congruent areas rather than remapping
>  if someone can show that it's semi-reliable.  Good luck!)

I finished writing up the first draft last night.  Somehow I can feel
long grueling debugging hours ahead of me but it generally goes like
the following.

Percpu areas are allocated in chunks in vmalloc area.  Each chunk is
consisted of num_possible_cpus() units and the first chunk is used for
static percpu variables in the kernel image (special boot time
alloc/init handling necessary as these areas need to be brought up
before allocation services are running).  Unit grows as necessary and
all units grow or shrink in unison.  When a chunk is filled up,
another chunk is allocated.  ie. in vmalloc area

  c0                           c1                         c2           
   -------------------          -------------------        ------------
  | u0 | u1 | u2 | u3 |        | u0 | u1 | u2 | u3 |      | u0 | u1 | u
   -------------------  ......  -------------------  ....  ------------

Allocation is done in offset-size areas of single unit space.  Ie,
when UNIT_SIZE is 128k, an area at 134k of 512bytes occupy 512bytes at
6k of c1:u0, c1:u1, c1:u2 and c1u3.  Percpu access can be done by
configuring percpu base registers UNIT_SIZE apart.

Currently it uses pte mappings but byn using larger UNIT_SIZE, it can
be modified to use pmd mappings.  I'm a bit skeptical about this tho.
Percpu pages are allocated with HIGHMEM | COLD, so they won't
interfere with the physical mapping and on !NUMA it lifts load from
pgd tlb by not having stuff for different cpus occupying the same pgd
page.  What we can also do is to use large page sized UNIT_SIZE but
default to pte mappings and convert to pmd mapping if a chunk becomes
full occupied.  Anyways, we can think about this later.

I'm going back to get this thing working.

Happy Valentine's everyone. :-)

-- 
tejun
