Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZBXRl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZBXRl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZBXRlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:41:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:8134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZBXRls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:41:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,260,1233561600"; 
   d="scan'208";a="668150167"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "jeremy@goop.org" <jeremy@goop.org>,
       "cpw@sgi.com" <cpw@sgi.com>, "mingo@elte.hu" <mingo@elte.hu>
Date: Tue, 24 Feb 2009 09:41:44 -0800
Subject: RE: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Thread-Topic: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Thread-Index: AcmWQ18FspqtUVB3RImVzvLIKMw/HgAYlsTA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA361924956@orsmsx505.amr.corp.intel.com>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
 <200902192221.52835.rusty@rustcorp.com.au> <499E1D01.2040408@kernel.org>
 <200902241326.23605.rusty@rustcorp.com.au> <49A389F7.9030002@kernel.org>
In-Reply-To: <49A389F7.9030002@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > IA64 uses a pinned TLB entry to map this cpu's 64k at __phys_per_cpu_start.
> > See __ia64_per_cpu_var() in arch/ia64/include/asm/percpu.h.  This means they
> > can also optimize cpu_local_* and read_cpuvar (or whatever it's called now).
> > IIUC IA64 needs this region internally, using it for percpu vars is a bonus.

Something like that ...

ia64 started out with a pinned TLB entry to map the percpu space to the
top 64K of address space (so that the compiler can generate ld/st instructions
with a small negative offset from register r0 to access local-to-this-cpu
objects).

Then we started using a one of the ar.k* registers to hold the base
physical address for each cpus per-cpu area so that early parts of
machine check code (which runs with MMU off) can access per-cpu variables.

Finally we found that certain transaction processing benchmarks ran faster
if we let the cpu have free access to one extra TLB entry ... so we
stopped pinning the per-cpu area, and wrote a s/w fault handler to
insert the mapping on demand (using the ar.k3 register to get the
physical address for the mapping).

N.B. ar.k3 is a medium-slow register ... I wouldn't want to use it
in the code sequence for *every* per-cpu variable access.

-Tony
