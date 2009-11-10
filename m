Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbZKJGVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbZKJGVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZKJGVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:21:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50374 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZKJGVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:21:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter instead
Cc: kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.DEB.1.10.0911061249170.5187@V090114053VZO-1>
References: <20091106174439.GB819@basil.fritz.box> <alpine.DEB.1.10.0911061249170.5187@V090114053VZO-1>
Message-Id: <20091110151145.3615.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 10 Nov 2009 15:21:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 6 Nov 2009, Andi Kleen wrote:
> 
> > On Fri, Nov 06, 2009 at 12:08:54PM -0500, Christoph Lameter wrote:
> > > On Fri, 6 Nov 2009, Andi Kleen wrote:
> > >
> > > > Yes but all the major calls still take mmap_sem, which is not ranged.
> > >
> > > But exactly that issue is addressed by this patch!
> >
> > Major calls = mmap, brk, etc.
> 
> Those are rare. More frequently are for faults, get_user_pages and
> the like operations that are frequent.
> 
> brk depends on process wide settings and has to be
> serialized using a processor wide locks.
> 
> mmap and other address space local modification may be able to avoid
> taking mmap write lock by taking the read lock and then locking the
> ptls in the page struct relevant to the address space being modified.
> 
> This is also enabled by this patchset.

Andi, Why do you ignore fork? fork() hold mmap_sem write-side lock and
it is one of critical path.
Ah yes, I know HPC workload doesn't call fork() so frequently, I mean
typical desktop and small server case.

I agree with cristoph halfly. if the issue is only in mmap, it isn't
so important.

Probably, I haven't catch your mention.


Plus, most critical mmap_sem issue is not locking cost itself. In stree workload,
the procss grabbing mmap_sem frequently sleep. and fair rw-semaphoe logic
frequently prevent reader side locking.
At least, this improvement doesn't help google like workload.

Thanks.


> > Only for page faults, not for anything that takes it for write.
> >
> > Anyways the better reader lock is a step in the right direction, but
> > I have my doubts it's a good idea to make write really slow here.
> 
> The bigger the system the larger the problems with mmap. This is one key
> scaling issue important for the VM. We can work on that. I have a patch
> here that restricts the per cpu checks to only those cpus on which the
> process has at some times run before.



