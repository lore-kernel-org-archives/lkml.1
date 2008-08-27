Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYH0Ipn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYH0Ipn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYH0IpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:45:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33932
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbYH0IpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:45:03 -0400
Date: Wed, 27 Aug 2008 01:44:57 -0700 (PDT)
Message-Id: <20080827.014457.140528687.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: travis@sgi.com, davej@redhat.com, torvalds@linux-foundation.org,
       Alan.Brunelle@hp.com, mingo@elte.hu, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, tony.luck@intel.com, steiner@sgi.com,
       cl@linux-foundation.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808271747.14690.nickpiggin@yahoo.com.au>
References: <200808271654.32721.nickpiggin@yahoo.com.au>
	<20080827.000506.177643294.davem@davemloft.net>
	<200808271747.14690.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Wed, 27 Aug 2008 17:47:14 +1000

> Yeah, I see. That's stupid isn't it? (Well, I guess it was completely
> sane when cpumasks were word sized ;))
> 
> Hopefully that accounts for a significant chunk...

There is a lot of indirect costs that are hard to see as well.

Two things a lot of these cross-call dispatch paths do is:

1) Clear self-cpu

2) AND with cpus_online

#1 can normally be a simple bit clear, but some places can also
implement this with something like "cpus_andn(X, cpumask_of_cpu(cpu))"

It's simply easier to move those two things down to the bottom of
the APIC programming code, they just loop over the cpumask doing
an expensive APIC I/O operation anyways, might as well overlap it
with these "skip self-cpu" and "skip not-online cpus" checks.

And oh yeah we get the stack wastage fixed too, isn't what what we
were talking about? :-)

