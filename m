Return-Path: <linux-kernel-owner+w=401wt.eu-S934926AbZJNQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926AbZJNQnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbZJNQnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:43:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:11407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbZJNQnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:43:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,559,1249282800"; 
   d="scan'208";a="198918995"
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Date: Wed, 14 Oct 2009 09:42:31 -0700
Subject: RE: [PATCH 13/16] percpu: remove per_cpu__ prefix.
Thread-Topic: [PATCH 13/16] percpu: remove per_cpu__ prefix.
Thread-Index: AcpM5Ggv5v7820+QQ/GlPpaa4vhPdgAB2eoA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
 <1255500125-3210-14-git-send-email-tj@kernel.org>
 <alpine.DEB.1.10.0910141026370.26476@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141026370.26476@gentwo.org>
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

>> -#define __ia64_per_cpu_var(var)	per_cpu__##var
>> +#define __ia64_per_cpu_var(var)	var
>
> IA64 could completely drop the macro? Tony?

A #define that just returns its original argument untouched
does seem to be a no-op.  So I suppose we could just fix
the dozen or so places where it is used to just use the
variable directly.

But that would leave no visual indicator in the source
code that a per-cpu variable was being used.  E.g. in
delayed_tlb_flush() we'd end up with:

   if (unlikely(ia64_need_tlb_flush)) {
       spin_lock ...
       if (ia64_need_tlb_flush) {
           local_flush_tlb_all();
           ia64_need_tlb_flush = 0;
       }
       spin_unlock ...
   }

This might cause confusion to anyone who is looking at
this code and has let the

DECLARE_PER_CPU(u8, ia64_need_tlb_flush);

scroll off the top of their screen.  I'd be tempted to go
and change all the names to make this obvious:

DECLARE_PER_CPU(u8, PERCPU_ia64_need_tlb_flush);


-Tony
