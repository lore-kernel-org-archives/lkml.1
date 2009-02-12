Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZBLJQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZBLJQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 04:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZBLJPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 04:15:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:35240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbZBLJPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 04:15:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,196,1233561600"; 
   d="scan'208";a="109907343"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
Date: Thu, 12 Feb 2009 09:15:07 +0000
Subject: RE: [patch] x86, ptrace: fix double-free on race
Thread-Topic: [patch] x86, ptrace: fix double-free on race
Thread-Index: AcmMlaYvGK6ehMG+SgiUUvT9fhofGgAWJfNg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A3D5FC1@irsmsx504.ger.corp.intel.com>
References: <20090211151027.A16643@sedona.ch.intel.com>
 <20090211220821.GA17637@redhat.com>
In-Reply-To: <20090211220821.GA17637@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Wednesday, February 11, 2009 11:08 PM
>To: Metzger, Markus T


>Off-topic. This is subjective, so please feel to ignore, but personally
>I dislike the usage of ptrace_fork() in copy_process(). And ptrace_fork()
>itself.
>
>To me, this has nothing to do with ptrace at all. copy_process() or
>dup_task_struct() just must clear/tweak some fields after memcpy().
>
>Perhaps it is better to kill all these ptrace_fork/arch_ptrace_fork/
>x86_ptrace_fork/ptrace_bts_fork helpers, and make a single function
>
>	static inline void arch_bts_init(struct task_struct *p)
>	{
>	#ifdef CONFIG_X86_PTRACE_BTS
>		if (unlikely(p->bts)) {
>			p->bts = NULL;
>			p->bts_buffer = NULL;
>			p->bts_size = 0;
>			p->thread.bts_ovfl_signal = 0;
>		}
>	#endif /* CONFIG_X86_PTRACE_BTS */
>	}

It looked cleaner and more consistent to me, that way.

Ptrace passes things down to arch in other cases already,
e.g. ptrace_detach()->ptrace_disable(), ptrace()->arch_ptrace(),
ptrace_attach()->arch_ptrace_attach().

I think the function should be in arch/x86/ptrace.c - if we call it from
ptrace or from arch_dup_task_struct() doesn't really matter.

Do you want me to move the call to arch_dup_task_struct()?


>which is called by arch_dup_task_struct(). The "if (ptrace)" check
>in copy_process() is just wrong imho, even if it is currently correct.

You're right, it is not strictly necessary and would actually be in the
way if we added more fields. I'm OK to remove it.


>Btw, just curious, bts_ovfl_signal is not used, except the user can
>set/get it via PTRACE_BTS_CONFIG/PTRACE_BTS_STATUS ?

It's not really necessary for debugging, but we wanted to get the interface
general enough to support other use cases.

There's already a PMI interrupt handler in perfmon which handles the PEBS
buffer overflow. Stephane was planning to extract it so it can be used by
ds.c. Once that is done, we were planning to move the buffer overflow
handling for BTS and PEBS into ds.c and enable the feature in ptrace.


regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

