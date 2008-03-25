Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYCYUy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYCYUy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYCYUyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:54:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:56533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYCYUyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:54:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,554,1199692800"; 
   d="scan'208";a="360482418"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: What if a TLB flush needed to sleep?
Date: Tue, 25 Mar 2008 13:49:54 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: What if a TLB flush needed to sleep?
Thread-Index: AciOucdQti0gtE4SRbOddMbbxKnZkg==
From: "Luck, Tony" <tony.luck@intel.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Mar 2008 20:49:55.0752 (UTC) FILETIME=[C81D5A80:01C88EB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 processors have a "ptc.g" instruction that will purge
a TLB entry across all processors in a system.  On current
cpus there is a limitation that only one ptc.g instruction may
be in flight at a time, so we serialize execution with code
like this:

	spin_lock(&ptcg_lock);
	... execute ptc.g
	spin_unlock(&ptcg_lock);

The architecture allows for more than one purge at a time.
So (without making any declarations about features of
unreleased processors) it seemed like time to update the
code to grab the maximum count from PAL, use that to
initialize a semaphore, and change the code to:

	down(&ptcg_sem);
	... execute ptc.g
	up(&ptcg_sem);

This code lasted about a week before someone ran hackbench
with parameters chosen to cause some swap activity (memory
footprint ~8.5GB on an 8GB system).  The machine promptly
deadlocked because VM code called the tlbflush code while
holding an anon_vma_lock, the semaphore happened to sleep
because some other processor was also trying to do a purge,
and the test was on a system where the limit was still just
one ptc.g at a time, and the process got swapped.

Now for the questions:

1) Is holding a spin lock a problem for any other arch when
doing a TLB flush (I'm particularly thinking of those that
need to use IPI shootdown for the purge)?

2) Is it feasible to rearrange the MM code so that we don't
hold any locks while doing a TLB flush?  Or should I implement
some sort of spin_only_semaphore?

-Tony
