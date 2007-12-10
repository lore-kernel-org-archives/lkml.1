Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbXLJHig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbXLJHig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 02:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXLJHiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 02:38:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:43356 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751772AbXLJHiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 02:38:12 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18H9Jk4qZsHBFwyoCJB21Bs5u6u01EkRXPFvE9lly
	eXqoN7xdTeEuxE
Date: Mon, 10 Dec 2007 08:38:08 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
Message-ID: <20071210073808.GA32112@atjola.homenet>
References: <1197049846.1645.68.camel@localhost.localdomain> <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org> <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org> <Pine.LNX.4.58.0712081702450.23837@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.58.0712081702450.23837@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.12.08 17:16:24 -0500, Steven Rostedt wrote:
> 
> Hi Linus,
> 
> > On Fri, 7 Dec 2007, Linus Torvalds wrote:
> > >
> > > Can you do one run with oprofile, and see exactly where the cost is? It
> > > should hopefully be pretty darn obvious, considering your timing.
> 
> The results are here:
> 
> http://people.redhat.com/srostedt/slub/results/slab.op
> http://people.redhat.com/srostedt/slub/results/slub.op

Hm, you seem to be hitting the "another_slab" stuff in __slab_alloc
alot. I wonder if !node_match triggers too often. We always start with
the per cpu slab, if that one is on the wrong node, you'll always hit
that "another_slab" path.

After searching for way too long (given that I have no clue about that
stuff anyway and just read the code out of curiousness), I noticed that
the the cpu_to_node stuff on x86_64 seems to be initialized to 0xff
(arch/x86/mm/numa_64.c), and Google brought me this dmesg output [1],
which, AFAICT, shows that the per cpu slab setup is done _before_
cpu_to_node is correctly setup. That would lead to the per cpu slabs all
having node == 0xff, which looks pretty bad.

Disclaimer: I read the slub/numa/$WHATEVER_I_SAW_THERE for the first
time, so this might be total bull ;-)

Björn

[1] http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-10/msg04648.html
