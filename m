Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZFKVF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZFKVF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZFKVFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:05:48 -0400
Received: from www.tglx.de ([62.245.132.106]:41037 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZFKVFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:05:47 -0400
Date: Thu, 11 Jun 2009 23:05:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: memtest: fix compile warning
In-Reply-To: <86802c440906111019o5829933fnfffcea5cd0e3c862@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0906112249360.15036@localhost.localdomain>
References: <20090611112746.802a24cb.sfr@canb.auug.org.au>  <20090611102927.GE12431@alberich.amd.com>  <alpine.LFD.2.00.0906111512400.3372@localhost.localdomain> <86802c440906111019o5829933fnfffcea5cd0e3c862@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Yinghai Lu wrote:
> On Thu, Jun 11, 2009 at 7:21 AM, Thomas Gleixner<tglx@linutronix.de> wrote:
> > On Thu, 11 Jun 2009, Andreas Herrmann wrote:
> > But the reserve_bad_mem() semantics are even more scary:
> >
> > - if you hit flaky memory, which gives you bad and good results here
> >   and there, you call reserve_bad_mem() totally unbound which is
> >   likely to overflow the early reservation space and panics the
> >   machine. You need to keep track of those events somehow (e.g. in a
> >   bitmap) so you can detect such problems and mark the whole affected
> >   region bad in one go.
>
> if one pass found bad, it is reserved.
> second pass will use find_e820_area_size() to get new range, so bad
> one will not be used.

No, that's not about passes. Assume that you have flaky memory which
works halfways. So that code runs through a full memory region from 0
to 0x1000000.

      0-FF	OK
      100-1ff	BAD
      200-21f	OK
      220-23f	BAD
      ....
So there is no find_e820_area_size() between those OK/BAD steps, but
every new BAD hit calls reserve_early() and you run out of space in
the reserve array.

> > - you call reserve_early() which calls __reserve_early(....,
> >   overrun_ok = 0) so if you do the default multi pattern scan and each
> >   run sees the same region of broken memory you will trigger the
> >   "Overlapping early reservations" panic in __reserve_early() when you
> >   reserve that region the second time. Why do you run the test twice
> >   when the first one failed already ? Also there is no need to do the
> >   wipeout run in that case, which will trigger it as well!
 
Ok, here applies the find_e820_area_size() thing. I missed that
because the code is so well documented and obvious.

> current problem in that: we could run out of res_reserve array.
> solution will be make res_reserve array dynamically.
>   when can not find slot, need use find_e820_area to get double sized,
> and copy the old to new one.
>   then free the old one.

This applies to the first problem, which can be avoided by clever
coding.

Thanks,

	tglx
