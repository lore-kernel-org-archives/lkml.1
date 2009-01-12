Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZALWSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZALWSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZALWRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:17:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZALWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:17:51 -0500
Date: Mon, 12 Jan 2009 23:32:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090112223220.GK23848@one.firstfloor.org>
References: <20090112213539.GA10720@gambetta> <20090112215701.GH23848@one.firstfloor.org> <20090112221023.GB10720@gambetta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112221023.GB10720@gambetta>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:10:23PM +0100, Frederik Deweerdt wrote:
> On Mon, Jan 12, 2009 at 10:57:02PM +0100, Andi Kleen wrote:
> > On Mon, Jan 12, 2009 at 10:35:42PM +0100, Frederik Deweerdt wrote:
> > > Hi,
> > > 
> > > On x86_64 flush tlb data is stored in per_cpu variables. This is
> > > unnecessary because only the first NUM_INVALIDATE_TLB_VECTORS entries
> > > are accessed.
> > > This patch aims at making the code less confusing (there's nothing
> > > really "per_cpu") by using a plain array. It also would save some memory
> > > on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).
> > 
> > Nope it doesn't save memory on most systems because per cpu is only allocated
> > based on the CPUs that are actually there. And if you have more than 8
> > cores you can likely afford a few bytes per CPU.
> I did not understand that, thanks for clarifiying
> > 
> > You would need to cache line pad each entry then, otherwise you risk
> > false sharing. That would make the array 1K on 128 bytes cache line 
> > system.  This means on small systems this would actually waste
> > much more memory.
> > 
> > per cpu avoids that problem completely.
> It is also slower (or so percpu.h says), and confusing I'd say.

Well it's something like 3 instructions versus one. You would
have a hard time benchmarking it unless you run it in a very tight 
loop. It will be lost in the noise compared to all the other costs
of the IPI.

Also why i don't like this patch is that on the typical small single/dual
core system running a 128 byte cache line distro kernel you always pay the 
1K cost now, while with per cpu it only needed one/two entries.

Admittedly it could have been better commented.

Not that it matters now unfortunately it's already applied. Sometimes
wonder why I still bother to do patch review...

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
