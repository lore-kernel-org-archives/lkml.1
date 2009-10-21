Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZJUWLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZJUWLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbZJUWLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:11:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:32948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZJUWLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:11:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,600,1249282800"; 
   d="scan'208";a="201936831"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>
CC: Jeff Mahoney <jeffm@suse.com>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Wed, 21 Oct 2009 15:11:04 -0700
Subject: RE: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Thread-Topic: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Thread-Index: AcpSYdd6gZSDIwOiSTqDMoQm1TqZhwANubNQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E337CF79@orsmsx505.amr.corp.intel.com>
References: <4ADB967A.4080707@suse.com>
 <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz>
 <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz>
 <4ADD48D1.1040701@kernel.org>
 <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de>
 <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org>
 <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de>
 <4ADDC69A.5000701@suse.com> <4ADDCDED.6060706@suse.com>
 <20091021061109.GA27195@elte.hu> <4ADF2691.7070304@kernel.org>
In-Reply-To: <4ADF2691.7070304@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I talked with Christoph earlier and he basically said that the
> constant can just be bumped up without any ill effect (it would be
> great if Tony Luck can confirm this).  So, it's an annoying thing and
> in the long term removing would be a good idea but I don't think it's
> anything major as long as it blows up during build not runtime.

Yes, ia64 can use any supported page size for the percpu area (I
tried a couple of different options, and saw no obvious problems).

But ... the architecturally supported page sizes go up by powers
of 4, so next choice from 64K is 256K then 1M, 4M, etc.  This is
also requires an edit of source code and re-compile.  We could easily
make it a config option ... but that is still inconvenient.

The bloat introduced by adding percpu variables is multiplied by
NR_CPUS ... and in my case that is 4096.  It is easy to just shrug
this off and say that such big systems have plenty of memory anyway,
but the case that led to this issue (adding a percpu object that
included a [NR_CPUS] array) shows that, IMHO, people are do not
care enough about the bloat.

I suspect that if I just increase the percpu area to 256K or 1M,
I'll see this same issue when someone adds:

struct foo {
       char buf[NR_CPUS][PAGE_SIZE];
};
DECLARE_PER_CPU(struct foo, bar);

which needs 4k * 64k = 256M of per-cpu space ... i.e. 1T total.

If such code is going to be deemed acceptable, then we do need
to move away from the ia64 TLB mapped percpu area.

-Tony
