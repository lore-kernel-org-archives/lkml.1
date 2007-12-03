Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXLCPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXLCPSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXLCPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:18:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:29398 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbXLCPSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:18:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,244,1194249600"; 
   d="scan'208";a="415625028"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Date: Mon, 3 Dec 2007 15:17:47 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF554440108FE48@swsmsx413.ger.corp.intel.com>
In-Reply-To: <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
thread-index: Acg1s+NfaPFC+m9VTna9us3A0Fu0iQACW8OA
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org> <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com> <200711301134.04719.ak@suse.de> <029E5BE7F699594398CA44E3DDF554440105236A@swsmsx413.ger.corp.intel.com> <20071130170655.GA10868@elte.hu> <20071201074044.GA13974@elte.hu> <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Roland McGrath" <roland@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Andi Kleen" <ak@suse.de>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>, <markus.t.metzger@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Markus Metzger" <markus.t.metzger@googlemail.com>
X-OriginalArrivalTime: 03 Dec 2007 15:17:45.0503 (UTC) FILETIME=[A814F2F0:01C835BF]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>There seems to be support for block stepping in arch/x86/kernel/step.c,
>which is used by kernel/ptrace.c.
>
>This is now another user for the DEBUGCTL MSR; the access needs to be
>synchronized. I'll look into it.

I looked into the new block/single stepping support in
arch/x86/kernel/step.c.
It uses a TIF DEBUGCTLMSR and a field unsigned long debugctlmsr in
struct thread_struct.

When they are done stepping, they clear the TIF and the MSR.


Our patch uses a ds_area field in struct thread_struct and two TIF to
mark
the functionality, rather than the resource. We need to access the
DEBUGCTL
and DS_SAVE_AREA MSR's.

I would rewrite our patch to rename the TIF to name the used resource
and
move the code setting the DS_SAVE_AREA MSR to __switch_to_xtra; that
leaves
only the code to take the timestamp in ptrace_bts.c.


The two MSR accesses (or, rather, the two users of the TIF) still
conflict.
When either is done, he clears the TIF bit and thus disables the other
user.

I would introduce a convention:
- each user clears only the debugctl bits he used
- the TIF bit is cleared, if thread_struct.debugctlmsr == 0
- before setting any bit, each user first checks all bits he intends to
set
  if any is set already, he bails out with an error

Is there some better way to do this?


thanks and regards,
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
