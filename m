Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXDLNFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXDLNFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbXDLNFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:05:54 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:37095 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbXDLNFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:05:53 -0400
From: Buytaert_Steven@emc.com
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: sched_yield proposals/rationale
Date: Thu, 12 Apr 2007 09:05:25 -0400
Message-ID: <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com>
In-Reply-To: <p737ish90ss.fsf@bingen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sched_yield proposals/rationale
Thread-Index: Acd8/sr1pzOWKdrQTf2Ca+o7Lh149gAApKTw
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de>
To: <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Apr 2007 13:05:26.0566 (UTC) FILETIME=[3D080C60:01C77D03]
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.4.12.53034
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, SUPERLONG_LINE 0.05, NO_REAL_NAME 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __IMS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andi Kleen
> [ ... about use of sched_yield ...]
> On the other hand when they fix their code to not rely on sched_yield
> but use [...]

Agreed, but $ find . -name "*.[ch]" | xargs grep -E "yield[ ]*\(" | wc over
the 2.6.16 kernel yields 105 hits, note including comments... An interesting spot is e.g. fs/buffer.c free_more_memory()

> The only way I could think of to make sched_yield work the way they
> expect would be to define some way of gang scheduling and give
> sched_yield semantics that it preferably yields to other members
> of the gang. [...]

That would indeed make things too complicated.

> [about question 1]
> That would still not unbreak most applications I would suspect -- they
> will likely try to yield multiple times before using up a full time slice
> unless their event handlers are very compute intensive.

No, they only get 1 go again on the active queue, until they pass the proper exit to the expired queue via scheduler_tick. And they are enqueued at the end of the active queue with whatever slices they have left, thus fair.
 
> In general other subsystems (e.g. VM) had had quite bad experiences
> with similar "one more try" hacks -- they tend to be not robust and
> actually penalize some loads.
> 
> > 2) When a task is eventually put in the expired list in sched_yield,
> > give it back the full time slices round (as done in scheduler_tick), not > > with the remaining slices as is done now?
> 
> That would likely be unfair and exploitable.

I don't understand; how more unfair would it be than passing via scheduler_tick? Grabbing a resource with a single time slice left would be more unfair towards other tasks IMHO when you get moved to the expired list with the resource in still in your possession.

> 
> > 3) Put the task in the expired list at a random position, not at the end
> > is done now?
> 
> Sounds like an interesting approach, but to do it in O(1) you would
> need a new data structure with possibly much larger constant overhead.

Agreed, but not dramatic. Suppose you need to insert at position X, you would do, on the linked list after proper setup:

while (X--) { prev = current; current = current->next }

You could have a small duffs device to reduce the X-- checking overhead.

Thanks for the insight Andi!

Steven Buytaert
--
La perfection est atteinte non quand il ne reste rien ajouter, mais quand il ne reste rien à enlever. (Antoine de Saint-Exupéry)
