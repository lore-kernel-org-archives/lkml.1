Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbYCXQru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbYCXQru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYCXQrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:47:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:3256 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbYCXQrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,546,1199692800"; 
   d="scan'208";a="359700933"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Date: Mon, 24 Mar 2008 09:45:06 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE5B401@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080322122903.GD15355@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Thread-Index: AciMGGjJ/TyU8I2AQ2K/fpdGEJs02ABs9ZPA
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com> <20080322122903.GD15355@kernel.dk>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, <npiggin@suse.de>, <paulus@samba.org>,
       <tglx@linutronix.de>, <mingo@redhat.com>
X-OriginalArrivalTime: 24 Mar 2008 16:45:08.0181 (UTC) FILETIME=[6B3A2050:01C88DCE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Funky, how does accessing other CPU's per-cpu variables work on ia64
> then? Perhaps I made some false assumptions.

The per-cpu memory is mapped at two different spots in the kernel
virtual memory.  When cpuA wants to access per-cpu memory that belongs
to cpuB it can use the mappings that allow access to every percpu
area (which may just be indexing by cpu number into a big block of
memory that has all the per-cpu spaces ... or some more complex
arithmetic and pointers for NUMA systems where the per-cpu memory
ought to be allocated out of memory on the right node for the cpu
that it refers to).

When any cpu wants to access its own per-cpu data, it can do so
via the per-cpu mapping (which is much more efficient from a code
generation perspective at the per-cpu virtual area is the top 64K
of virtual address space, so can be accessed with a small negative
offset from register r0).

This is why lists can be a problem ... since the same memory can
be accessed via two different virtual addresses, things can get
badly knotted when the two different addresses get used in different
parts of the code.  Then operations like "list_empty()" may give
the wrong answer because the virtual address used for head->next
isn't the same as that used for head ... but they both refer to the
same underlying object.

> Unfortunately I have no access to any IA64 machines, so I either
> have to yank the ia64 bits (which is unfortunate, since Alan tests
> on those :-) or rely on a bit of help from you and/or others in
> getting that bit right.

I'll see if I can figure out what is going wrong.

-Tony
