Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZBPHX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZBPHX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZBPHXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:23:18 -0500
Received: from ozlabs.org ([203.10.76.45]:51679 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZBPHXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:23:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: #tj-percpu has been rebased
Date: Mon, 16 Feb 2009 17:53:13 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
References: <49833350.1020809@kernel.org> <200902140728.55954.rusty@rustcorp.com.au> <4996141A.1050506@kernel.org>
In-Reply-To: <4996141A.1050506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161753.14141.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009 11:15:14 Tejun Heo wrote:
> Rusty Russell wrote:
> > On Thursday 12 February 2009 14:14:08 Tejun Heo wrote:
> >> Oops, those are the same ones.  I'll give a shot at cooking up
> >> something which can be dynamically sized before going forward with
> >> this one.
> > 
> > That's why I handed it to you! :)
> > 
> > Just remember we waited over 5 years for this to happen: the point of these
> > is that Christoph showed it's still useful.
> > 
> > (And I really like the idea of allocing congruent areas rather than remapping
> >  if someone can show that it's semi-reliable.  Good luck!)
> 
> I finished writing up the first draft last night.  Somehow I can feel
> long grueling debugging hours ahead of me but it generally goes like
> the following.
> 
> Percpu areas are allocated in chunks in vmalloc area.  Each chunk is
> consisted of num_possible_cpus() units and the first chunk is used for
> static percpu variables in the kernel image (special boot time
> alloc/init handling necessary as these areas need to be brought up
> before allocation services are running).  Unit grows as necessary and
> all units grow or shrink in unison.  When a chunk is filled up,
> another chunk is allocated.  ie. in vmalloc area
> 
>   c0                           c1                         c2           
>    -------------------          -------------------        ------------
>   | u0 | u1 | u2 | u3 |        | u0 | u1 | u2 | u3 |      | u0 | u1 | u
>    -------------------  ......  -------------------  ....  ------------
> 
> Allocation is done in offset-size areas of single unit space.  Ie,
> when UNIT_SIZE is 128k, an area at 134k of 512bytes occupy 512bytes at
> 6k of c1:u0, c1:u1, c1:u2 and c1u3.  Percpu access can be done by
> configuring percpu base registers UNIT_SIZE apart.
> 
> Currently it uses pte mappings but byn using larger UNIT_SIZE, it can
> be modified to use pmd mappings.  I'm a bit skeptical about this tho.
> Percpu pages are allocated with HIGHMEM | COLD, so they won't
> interfere with the physical mapping and on !NUMA it lifts load from
> pgd tlb by not having stuff for different cpus occupying the same pgd
> page.

Not sure I understand all of this, but it sounds like a straight virtual
mapping with some chosen separation between the mappings.

But note that for the non-NUMA case, you can just use kmalloc/__get_free_pages
and no remapping tricks are necessary at all.

Thanks,
Rusty.
