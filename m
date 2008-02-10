Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYBJJEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYBJJEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYBJJE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:04:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37066 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYBJJEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:04:24 -0500
Date: Sun, 10 Feb 2008 10:39:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@suse.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] CPA: Split static_protections into required_static_prot and advised_static_prot
Message-ID: <20080210093938.GA12683@one.firstfloor.org>
References: <20080208536.837219990@suse.de> <20080208163612.D76421B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091525400.3145@apollo.tec.linutronix.de> <20080209151322.GB6773@basil.nowhere.org> <alpine.LFD.1.00.0802091639200.3145@apollo.tec.linutronix.de> <20080209163904.GA24548@one.firstfloor.org> <alpine.LFD.1.00.0802091806220.3145@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802091806220.3145@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 06:09:23PM +0100, Thomas Gleixner wrote:
> On Sat, 9 Feb 2008, Andi Kleen wrote:
> > > > Note the behaviour for pageattr and thus DEBUG_RODATA / debugging
> > > > sitations where you don't care about your TLB this
> > > > does not change, this makes only a difference for the initial init_32
> > > > direct mapping setup.
> > > 
> > > Your patches do change the behaviour. The range checking breaks the
> > > enforcement of some restrictions for the sake of keeping the large
> > > page intact.
> > 
> > You mean in try_preserve_large_page()?
> > 
> > No actually they were not completely enforced previously at all, because
> > it did only check the restrictions of the first page.
> 
> Right, you poked my nose to it. I did not think about it when I coded
> it. It is wrong and needs to be fixed, but not by the range check you
> introduced.

Well I need the range check for a different piece of code (init_memory_mapping())
For that a range check is definitely needed and the existing code there
also does an (although quite fishy) range check. The DEBUG_RODATA case
 is also handled correctly there because DEBUG_RODATA is applied explicitely 
using pageattr later. 

You have not commented on that at all so I assume it's ok for you.

> > On the end of my patch series the enforcement is actually stricter
> > than it was before, although not 100%.
> 
> As far as I can tell it is more relaxed, as it will make overlapping
> regions of rodata and rwdata completely rw instead of splitting it up.

In try_preserve_large_page()? No because it only checks the first page.

In all other cases (in the existing code; my patchkit adds a new case 
in mm/init_32.c) it always only checks single 4K pages so the only
overlap case would be sub 4K. For that there can be no split up.

-Andi
