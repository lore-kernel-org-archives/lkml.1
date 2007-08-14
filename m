Return-Path: <linux-kernel-owner+w=401wt.eu-S935185AbXHNWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185AbXHNWTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936389AbXHNWGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:06:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:8785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936669AbXHNWGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:06:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,261,1183359600"; 
   d="scan'208";a="117554500"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 10/23] make atomic_read() and atomic_set() behavior consistent on ia64
Date: Tue, 14 Aug 2007 15:06:12 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A022A009A@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46C1F917.1070008@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 10/23] make atomic_read() and atomic_set() behavior consistent on ia64
Thread-Index: Acfeo8liEgC5g7hITyawatK+bLg7yQAGj6Zw
References: <46C03885.7000109@redhat.com> <20070813112334.GJ24018@shell.boston.redhat.com> <617E1C2C70743745A92448908E030B2A0229FD89@scsmsx411.amr.corp.intel.com> <46C1F917.1070008@redhat.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chris Snook" <csnook@redhat.com>, <clameter@sgi.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <paulmck@linux.vnet.ibm.com>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Chris Friesen" <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
X-OriginalArrivalTime: 14 Aug 2007 22:06:13.0453 (UTC) FILETIME=[541B17D0:01C7DEBF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> include/linux/skbuff.h:521: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
>> include/net/sock.h:1244: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
>> include/net/tcp.h:958: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
>> mm/slub.c:3115: warning: passing arg 1 of `atomic_read' from incompatible pointer type
>> mm/slub.c:3250: warning: passing arg 1 of `atomic_read' from incompatible pointer type
>> mm/slub.c:3286: warning: passing arg 1 of `atomic_read' from incompatible pointer type

> Do you get any warnings other than those two?

That looks like six, not two.  But that's the whole list.

>IIRC, when you applied a version which used macros instead, there was no change. 
>  It would seem that inlining changed the optimization behavior of the compiler. 
>  If you turn down the optimization level, do the macro and inline versions look 
>  the same, or at least more similar?

I re-tried the macros ... the three warnings from mm/slub.c all result in
broken code ... and quite rightly too, they all come from code that does:

	atomic_read(&n->nr_slabs)

But the nr_slabs field is an atomic_long_t, so we shouldn't be using
atomic_read().  I didn't spot these last time around because I was using
slab, not slub for the previous build.

I think that I'll run into other build issues if I turn down the
optimization level (there are lots of places where the kernel relies
on optimizing away impossible cases in switch statements.

> The binary does boot ... but I haven't run any tests to see whether
> there are any problems.

-Tony
