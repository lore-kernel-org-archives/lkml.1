Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbXLRX3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbXLRX3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXLRX3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:29:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:53718 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbXLRX3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:29:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,182,1196668800"; 
   d="scan'208";a="243393315"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH RFC][try 2] IA64 signal : remove redundant code in setup_sigcontext()
Date: Tue, 18 Dec 2007 15:29:19 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC22DA39@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20071122033249.GM12494@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH RFC][try 2] IA64 signal : remove redundant code in setup_sigcontext()
Thread-Index: AcgsuHC1GqPcdKsbSSK09aJQgmlwTQVE98TA
References: <4744F46B.6050004@cn.fujitsu.com> <20071122033249.GM12494@parisc-linux.org>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Matthew Wilcox" <matthew@wil.cx>, "Shi Weihua" <shiwh@cn.fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 18 Dec 2007 23:29:20.0268 (UTC) FILETIME=[D0872CC0:01C841CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch removes some redundant code in the function setup_sigcontext().
>> 
>> The registers ar.ccv,b7,r14,ar.csd,ar.ssd,r2-r3 and r16-r31 are not restored 
>> in restore_sigcontext() when (flags & IA64_SC_FLAG_IN_SYSCALL) is true. 
>> So we don't need to zero those variables in setup_sigcontext().
>
> Erm, couldn't those registers contain information the process shouldn't
> see?

No, this looks safe.  setup_sigcontext() is stashing things out on the
user stack to be used by restore_sigcontext() should the application want
to return from the signal handler.  But restore_sigcontext isn't actually
in charge of putting values into machine registers, it just does the copy
back from user space to the place where the asm code will restore registers
on the way back to userland.  In this instance "restored" means "set back to
the state they had before the signal happened".  If they aren't "restored"
they'll have scratch values ... but those scratch values will have come
from the application (while it was executing the signal handler).  Not
leaked from the kernel or from some other application.

-Tony
