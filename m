Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbZBNDSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbZBNDSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 22:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZBNDSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 22:18:25 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:52749 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZBNDSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 22:18:25 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 22:18:24 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TXh8DNxbVACRP1Rm74uVTmouiRULUU0KM7JYP1I2WcNW/frGoxktHGykZTbmPvOkHj
         eWeJTFLAe3/6+GULxOQ26PZhnZbldU0uD/RUvYuPSS/DNaS1CP9/jSHpyK1HUCwpP8uU
         y7+8RvvMHiU9I2ceaSgW1D5WoMSXTvPPbSl0M=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902130758010.3099@localhost.localdomain>
References: <20090212023308.GA21157@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain>
	 <20090212215959.GN6759@linux.vnet.ibm.com>
	 <200902140050.44550.nickpiggin@yahoo.com.au>
	 <alpine.LFD.2.00.0902130758010.3099@localhost.localdomain>
Date: Fri, 13 Feb 2009 22:11:26 -0500
Message-ID: <8bd0f97a0902131911m7c06fbe8nb83f12f740bd7997@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [ltt-dev] [RFC git tree] Userspace RCU 
	(urcu) for Linux (repost)
From: Mike Frysinger <vapier.adi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       uclinux-dist-devel@blackfin.uclinux.org, paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 11:05, Linus Torvalds wrote:
> On Sat, 14 Feb 2009, Nick Piggin wrote:
>> Interesting. I don't know if you would say it is not cache coherent.
>> Does anything in cache coherency definition require timeliness? Only
>> causality I think.
>
> Nick, afaik, BF _really_ isn't cache coherent.
>
> It's not about timeliness. It's literally non-coherent.
>
> Blackfin L1 caches are
>  (a) write-through
>  (b) per-cpu
>  (c) non-coherent
> so the way that BF implements "cache coherency" is by literally
>
>  - use a magic test-and-set instruction that works on L2 memory (shared)
>  - keep track of which core has done that test-and-set last
>  - *flush* the L1 when it was the other core.
>
> Note that because it's a write-through cache, _writes_ are basically
> "coherent". But since the cache isn't actually _updated_ ont he other CPU,
> you can have two CPU's doing writes, and they'll both continue to see
> their own write, not necessarily the one that made it to memory. So I
> would not call that a "timeliness" issue, I would just say that the caches
> simply aren't coherent.
>
> But because it's write-through, flushing the cache always makes things
> coherent again (well, on _that_ CPU), of course.

it invalidates, not flushes, the cache when the lock changes hands.
and since the caches are forced to write through mode, the new core
should pick up all the correct data fresh from external memory.
-mike
