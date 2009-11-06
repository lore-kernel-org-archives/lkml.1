Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbZKFHjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbZKFHjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZKFHjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:39:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZKFHjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:39:44 -0500
Date: Fri, 6 Nov 2009 08:39:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter instead
Message-ID: <20091106073946.GV31511@one.firstfloor.org>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1> <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> <87r5sc7kst.fsf@basil.nowhere.org> <alpine.DEB.1.10.0911051558220.7668@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911051558220.7668@V090114053VZO-1>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 04:03:39PM -0500, Christoph Lameter wrote:
> > For example it will definitely impact the AIM7 multi brk() issue
> > or the mysql allocation case, which are all writer intensive. I assume
> > doing a lot of mmaps/brks in parallel is not that uncommon.
> 
> No its not that common. Page faults are much more common. The AIM7 seems
> to be an artificial case? What does mysql do for allocation? If its brk()

AIM7 is artificial yes, but I suspect similar problems (to a less
extreme degree) are in other workloads.

> related then simply going to larger increases may fix the issue??

For mysql it's mmap through malloc(). There has been some tuning in
glibc for it. But I suspect it's a more general problem that will
still need kernel improvements.

> 
> > My thinking was more that we simply need per VMA locking or
> > some other per larger address range locking. Unfortunately that
> > needs changes in a lot of users that mess with the VMA lists
> > (perhaps really needs some better abstractions for VMA list management
> > first)
> 
> We have range locking through the distribution of the ptl for systems with
> more than 4 processors. One can use that today to lock ranges of the
> address space.

Yes but all the major calls still take mmap_sem, which is not ranged.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
