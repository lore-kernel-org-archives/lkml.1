Return-Path: <linux-kernel-owner+w=401wt.eu-S1762905AbXHJWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762905AbXHJWdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbXHJWdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:33:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:44483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbXHJWda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,246,1183359600"; 
   d="scan'208";a="277296542"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 9/24] make atomic_read() behave consistently on ia64
Date: Fri, 10 Aug 2007 15:33:27 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0224C88B@scsmsx411.amr.corp.intel.com>
In-Reply-To: <jewsw3oyl8.fsf@sykes.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 9/24] make atomic_read() behave consistently on ia64
Thread-Index: Acfbl3k71HqNwcBaRxGDvHyIqtp2rQABEb9w
References: <20070809135107.GA15985@shell.boston.redhat.com><617E1C2C70743745A92448908E030B2A02213B3C@scsmsx411.amr.corp.intel.com><46BCC1AF.5050204@redhat.com><617E1C2C70743745A92448908E030B2A0224C777@scsmsx411.amr.corp.intel.com> <jewsw3oyl8.fsf@sykes.suse.de>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andreas Schwab" <schwab@suse.de>
Cc: "Chris Snook" <csnook@redhat.com>, <linux-kernel@vger.kernel.org>,
       <linux-arch@vger.kernel.org>, <torvalds@linux-foundation.org>,
       <netdev@vger.kernel.org>, <akpm@linux-foundation.org>, <ak@suse.de>,
       <heiko.carstens@de.ibm.com>, <davem@davemloft.net>,
       <schwidefsky@de.ibm.com>, <wensong@linux-vs.org>, <horms@verge.net.au>,
       <wjiang@resilience.com>, <cfriesen@nortel.com>, <zlynx@acm.org>,
       <rpjday@mindspring.com>, <jesper.juhl@gmail.com>
X-OriginalArrivalTime: 10 Aug 2007 22:33:28.0463 (UTC) FILETIME=[78FED1F0:01C7DB9E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Use atomic64_read to read an atomic64_t.

Thanks Andreas!

Chris: This bug is why the 8-byte loads got changed to 4-byte + sign-extend
by your change to atomic_read().

With this applied together with shuffling the volatile from the
declaration to the usage (in both atomic_read() and atomic_set()
the generated code *almost* reverts to the original.

There are some differences where ld4 have turned into ld8 though.
Are these bugs in the use of atomic_add() and atomic_sub().  E.g.
the first of these changes is in: ipc/msg.c:freeque() where we have:

	atomic_sub(msg->q_cbytes, &msg_bytes);

Now the type of msg->q_cbytes is "unsigned long" ... so it seems a
poor idea to subtract such a large typed object from "msg_bytes"
which is a mere slip of an atomic_t.

Or is there some other type-wrangling that needs to happen in
include/asm-ia64/atomic.h?  There are a total of nineteen of
these ld4->ld8 transforms.

-Tony
