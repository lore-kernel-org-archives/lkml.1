Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752365AbYLRP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbYLRP6T (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYLRP6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:58:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:48138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYLRP6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:58:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,243,1228118400"; 
   d="scan'208";a="371996966"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
        "roland@redhat.com" <roland@redhat.com>,
        "eranian@googlemail.com" <eranian@googlemail.com>
Date: Thu, 18 Dec 2008 15:57:53 +0000
Subject: RE: [rfc] x86, ptrace: memory accounting for branch tracing
Thread-Topic: [rfc] x86, ptrace: memory accounting for branch tracing
Thread-Index: Aclfqsa7Dc7UtOzsQfimuPyhM/GYEQBep7ag
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E0CC3A802@irsmsx504.ger.corp.intel.com>
References: <20081216162424.A30209@sedona.ch.intel.com>
	<20081216173059.GD11683@elte.hu>
 <20081216101804.eccda780.akpm@linux-foundation.org>
In-Reply-To: <20081216101804.eccda780.akpm@linux-foundation.org>
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
>From: Andrew Morton [mailto:akpm@linux-foundation.org]
>Sent: Dienstag, 16. Dezember 2008 19:18
>To: Ingo Molnar
>Cc: Metzger, Markus T; Peter Zijlstra;

>> > Account memory allocated for the BTS buffer to the traced task's
>> > total_vm and locked_vm.
>>
>> Andrew, is this the right (and preferred) way to attach BTS buffer
>> allocation overhead to the RLIMIT_MEMLOCK bucket:
>
>Close.  I suspect we could refactor mlock.c to avoid all the code
>duplication we have there.
>
>There's (almost) nothing BTS-specific in this code, and it would be
>better if it lived in mm/mlock.c.  Hopefully in a
>usable-by-other-parts-of-mlock.c fashion.

Thanks,

I added alloc_locked_buffer() and free_locked_buffer() functions to mm/mlock.c.


>> > +static int ptrace_bts_allocate_buffer(struct task_struct
>*child, size_t size)
>> > +{
>> > +   unsigned long rlim, vm, pgsz;
>> > +   int error = -ENOMEM;
>> > +
>> > +   pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
>> > +
>> > +   down_write(&child->mm->mmap_sem);
>> > +
>> > +   rlim = child->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
>> > +   vm   = child->mm->total_vm + pgsz;
>> > +   if (rlim < vm)
>
>This is off-by-one, I think.  Should be
>
>        if (vm > rmlim)
>

Those two should be equivalent, shouldn't they?


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

