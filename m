Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbXHNS1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbXHNS1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbXHNS1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:27:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:36664 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbXHNS1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,260,1183359600"; 
   d="scan'208";a="263087274"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 10/23] make atomic_read() and atomic_set() behavior consistent on ia64
Date: Tue, 14 Aug 2007 11:27:35 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0229FD89@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070813112334.GJ24018@shell.boston.redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 10/23] make atomic_read() and atomic_set() behavior consistent on ia64
Thread-Index: AcfeTNy8OCps1NuaQ5O3IQyPogsw6AAUErBg
References: <46C03885.7000109@redhat.com> <20070813112334.GJ24018@shell.boston.redhat.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chris Snook" <csnook@redhat.com>, <linux-arch@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <paulmck@linux.vnet.ibm.com>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Chris Friesen" <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
X-OriginalArrivalTime: 14 Aug 2007 18:27:36.0702 (UTC) FILETIME=[C9E9B9E0:01C7DEA0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Use volatile consistently in atomic.h on ia64.
> This will do weird things without Andreas Schwab's fix:
> http://lkml.org/lkml/2007/8/10/410

The build is very noisy with the inline versions of atomic_{read,set}
and their 64-bit siblings.  Here are the prime culprits (some of them
repeat >100 times).

include/linux/skbuff.h:521: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
include/net/sock.h:1244: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
include/net/tcp.h:958: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
mm/slub.c:3115: warning: passing arg 1 of `atomic_read' from incompatible pointer type
mm/slub.c:3250: warning: passing arg 1 of `atomic_read' from incompatible pointer type
mm/slub.c:3286: warning: passing arg 1 of `atomic_read' from incompatible pointer type

The inline versions also result in some structural changes in
the object file that make it difficult to compare with the
original.  Text size is 96 bytes smaller ... but even after
I use sed(1) to exclude the most obvious instructions that
differ, I still find big blocks of code with changes.  Perhaps
even more surprising there are entire functions that are
optimized out in either the 'before' or 'after' binary.
E.g. lookup_pi_state() was optimized away (or completely
inlined?) before this patch, but the function appears as
standalone in the 'after' version.  The reverse is true for
fixup_pi_state_owner().

The binary does boot ... but I haven't run any tests to see whether
there are any problems.

-Tony
