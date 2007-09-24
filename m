Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXIXLJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXIXLJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbXIXLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:08:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:47040 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754934AbXIXLI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:08:57 -0400
Date: Mon, 24 Sep 2007 13:08:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070924130851.201d18ed@twins>
In-Reply-To: <1190630535.7406.2.camel@Homer.simpson.net>
References: <1190144190.5204.24.camel@earth>
	<20070918201622.GA1632@elte.hu>
	<Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	<1190183324.9737.7.camel@Homer.simpson.net>
	<1190188261.9185.21.camel@Homer.simpson.net>
	<1190191368.8687.5.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	<1190264114.6411.4.camel@Homer.simpson.net>
	<1190272507.27867.20.camel@Homer.simpson.net>
	<20070920075155.GA31641@elte.hu>
	<1190275870.9232.6.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
	<1190455308.7404.19.camel@Homer.simpson.net>
	<1190531662.11524.15.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
	<1190628609.6389.14.camel@Homer.simpson.net>
	<20070924122422.75562c41@twins>
	<1190630535.7406.2.camel@Homer.simpson.net>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 12:42:15 +0200 Mike Galbraith <efault@gmx.de> wrote:

> On Mon, 2007-09-24 at 12:24 +0200, Peter Zijlstra wrote:
> 
> > how about something like:
> > 
> >  s64 delta = (s64)(vruntime - min_vruntime);
> >  if (delta > 0)
> >   min_vruntime += delta;
> > 
> > That would rid us of most of the funny conditionals there.
> 
> That still left me with negative min_vruntimes.  The pinned hogs didn't
> lock my box up, but I quickly got the below, so hastily killed it.
> 
> se.wait_max              :             7.846949
> se.wait_max              :           301.951601
> se.wait_max              :             7.071359
>

Odd, the idea (which I think is clear) is that min_vruntime can wrap
around the u64 spectrum. And by using min_vruntime as offset to base
the key around, we get a signed but limited range key-space. (because
we update min_vruntime to be the leftmost task (in a monotonic fashion))

So I'm having trouble with these patches, that is, both your wrap
around condition of:

  if (likely(new_rq->cfs.min_vruntime))

as well as the last patchlet:

  if (((s64)vruntime > (s64)min_vruntime) ||

in that neither of these changes make sense in what its trying to do.

Its perfectly valid for min_vruntime to exist in 1ULL << 63.

