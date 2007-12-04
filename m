Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbXLDI40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbXLDI40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXLDI4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:56:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:14952 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbXLDI4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:56:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,247,1194249600"; 
   d="scan'208";a="332308065"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Date: Tue, 4 Dec 2007 08:52:13 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401090315@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200712031721.39013.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
thread-index: Acg1yJ19xtJ+UMRPSG6CahT2UHW5VwAhc5NA
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071201074044.GA13974@elte.hu> <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com> <200712031721.39013.ak@suse.de>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <ak@suse.de>, "Roland McGrath" <roland@redhat.com>
Cc: <tglx@linutronix.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>, <markus.t.metzger@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Markus Metzger" <markus.t.metzger@googlemail.com>
X-OriginalArrivalTime: 04 Dec 2007 08:52:10.0517 (UTC) FILETIME=[F4F7FC50:01C83652]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Andi Kleen [mailto:ak@suse.de] 
>Sent: Montag, 3. Dezember 2007 17:22

>> What did you have in mind when you asked for kernel-mode support?
>
>I asked about that earlier too and I would like to see per CPU traces
>for ring 0 with some way to dump that on crashes or on user trigger.

I will split it into two layers:
- a lower layer that does the DS/BTS configuration
- a higher layer that provides the ptrace interface

The lower layer works on a parameter DS pointer. Unfortunately,
this will be an unsigned long, since we have different DS/BTS layout
for different architectures.

The higher layer uses the lower layer to do the real work. It stores
a per-thread DS pointer in the thread_struct.

Kernel tracing would allocate a per_cpu array of DS pointers
and use the lower layer for all the real work. I would leave it
to someone who is more familiar with the kgdb patch, if that is OK.


What's left is proper resource managememt. The kernel use of
DS_SAVE_AREA
and DEBUGCTL conflicts with the ptrace use of those MSR's. As far as I
can
tell, this is missing for all MSR's. The single/block_stepping support 
certainly uses an optimistic approach.

I guess this is a certain amount of work. It needs the idea of an
'owner'
of such an MSR, some means to acquire and release it, a global
allocation 
order, some protection from others who simply try to use it. It needs to
be on register granularity for some; on bit granularity for others. It
needs to be global for some; per-thread for others. And it probably
needs 
a lot of error handling code in a lot of different areas.

I would hope that utrace is tackling some or all of these problems.
I would therefore stay optimistic in this patch and rework it once
utrace is in and provides a proper framework.
This seems to be the approach that the new block-stepping support takes.


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
