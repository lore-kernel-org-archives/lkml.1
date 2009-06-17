Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZFQIEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZFQIEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZFQIEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:04:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbZFQIEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:04:05 -0400
Date: Wed, 17 Jun 2009 10:04:04 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] HWPOISON: only early kill processes who installed SIGBUS handler
Message-ID: <20090617080404.GB31192@wotan.suse.de>
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <20090615064447.GA18390@wotan.suse.de> <20090615070914.GC31969@one.firstfloor.org> <20090615071907.GA8665@wotan.suse.de> <20090615121001.GA10944@localhost> <20090615122528.GA13256@wotan.suse.de> <20090615142225.GA11167@localhost> <20090617063702.GA20922@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617063702.GA20922@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 02:37:02PM +0800, Wu Fengguang wrote:
> On Mon, Jun 15, 2009 at 10:22:25PM +0800, Wu Fengguang wrote:
> > On Mon, Jun 15, 2009 at 08:25:28PM +0800, Nick Piggin wrote:
> > > On Mon, Jun 15, 2009 at 08:10:01PM +0800, Wu Fengguang wrote:
> > > > On Mon, Jun 15, 2009 at 03:19:07PM +0800, Nick Piggin wrote:
> > > > > > For KVM you need early kill, for the others it remains to be seen.
> > > > > 
> > > > > Right. It's almost like you need to do a per-process thing, and
> > > > > those that can handle things (such as the new SIGBUS or the new
> > > > > EIO) could get those, and others could be killed.
> > > > 
> > > > To send early SIGBUS kills to processes who has called
> > > > sigaction(SIGBUS, ...)?  KVM will sure do that. For other apps we
> > > > don't mind they can understand that signal at all.
> > > 
> > > For apps that hook into SIGBUS for some other means and
> > 
> > Yes I was referring to the sigaction(SIGBUS) apps, others will
> > be late killed anyway.
> > 
> > > do not understand the new type of SIGBUS signal? What about
> > > those?
> > 
> > We introduced two new SIGBUS codes:
> >         BUS_MCEERR_AO=5         for early kill
> >         BUS_MCEERR_AR=4         for late  kill
> > I'd assume a legacy application will handle them in the same way (both
> > are unexpected code to the application).
> > 
> > We don't care whether the application can be killed by BUS_MCEERR_AO
> > or BUS_MCEERR_AR depending on its SIGBUS handler implementation.
> > But (in the rare case) if the handler
> > - refused to die on BUS_MCEERR_AR, it may create a busy loop and
> >   flooding of SIGBUS signals, which is a bug of the application.
> >   BUS_MCEERR_AO is one time and won't lead to busy loops.
> > - does something that hurts itself (ie. data safety) on BUS_MCEERR_AO,
> >   it may well hurt the same way on BUS_MCEERR_AR. The latter one is
> >   unavoidable, so the application must be fixed anyway.
> 
> This patch materializes the automatically early kill idea.
> It aims to remove the vm.memory_failure_ealy_kill sysctl parameter.
> 
> This is mainly a policy change, please comment.

Well then you can still early-kill random apps that did not
want it, and you may still cause problems if its sigbus
handler does something nontrivial.

Can you use a prctl or something so it can expclitly
register interest in this?

