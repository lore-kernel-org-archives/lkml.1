Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYCNDJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYCNDJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 23:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYCNDJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 23:09:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:14545 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCNDJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 23:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f4BqWbokEcnb6A0nt5j08Kd+nDqrTcxdIbkXxdcgQt1u7+nsx7GbyO/CBzvEtAjX9DUyjqVnqGylHOXDeSn6yukTca7VpHSabOCE2CUgUzG+7hx2+6Af/Ow6KvmTX1ieFAHfihf7P9wgLLb4I3rJew+CyXT8jOgYvIGz+rgTn4c=
Message-ID: <86802c440803132009q40291587i7a9f41c686f0f10b@mail.gmail.com>
Date: Thu, 13 Mar 2008 20:09:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <874pba3tny.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	 <87iqzq40yd.fsf@saeurebad.de>
	 <86802c440803131804w1173b9b5n9d9f2d85c98b8901@mail.gmail.com>
	 <874pba3tny.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 7:50 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>
> Hi,
>
>  "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>  > On Thu, Mar 13, 2008 at 5:13 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>  >> Hi,
>  >>
>  >>  "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>  >>
>  >
>  >>  >  static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
>  >>  > @@ -407,6 +432,11 @@ unsigned long __init init_bootmem_node(p
>  >>  >  void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>  >>  >                                unsigned long size, int flags)
>  >>  >  {
>  >>  > +     int ret;
>  >>  > +
>  >>  > +     ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
>  >>  > +     if (ret < 0)
>  >>  > +             return;
>  >>  >       reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
>  >>
>  >>  I don't get it.  Sorry.  What is the purpose of
>  >>  can_reserve_bootmem_core()?  It does exactly what reserve_bootmem_core
>  >>  does besides actually setting the bits.  All the pre-checking you wanted
>  >>  to have out of the way is repeated again in reserve_bootmem_core()
>  >>  (well, almost all).
>  >
>  > can_reserve_bootmem_core is check if there is some pages is reserved
>  > already with
>  >>  > +                     if (flags & BOOTMEM_EXCLUSIVE)
>  >>  > +                             return -EBUSY;
>  >
>  > so it will avoid the restoring later.
>
>  Yes, I understood that.  But you skipped the lower part of my email:
>
>  Your current state now is _not_ that you have one function that
>  prechecks the range and another function that reserves it!  You have
>  _two_ functions checking the range and the second reserving it.

Yes

>
>  Why double-check most of the things?  If you want to have a pre-check
>  function, _move_ all the pre-checks into another function, not
>  copy-paste them.

for cross the nodes

>
>  And is the condition of trying to reserve a range twice, the second time
>  exclusively, so common that it is worth iterating twice over the nodes
>  (once for checking, once for reserving) instead of just unwinding the
>  reservation if it fails in between?
>
>  On something else: is there a bug when a memory range is reserved with
>  BOOTMEM_EXCLUSIVE and then again without this flag?  The second call
>  does not return an error then.

Yes. only provide one direction protection.
so always make sure crash_kernel reserve_bootmem as the last. that is doable.

YH
