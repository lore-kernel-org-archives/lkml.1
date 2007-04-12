Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXDLIdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXDLIdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965491AbXDLIdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:33:14 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:37135 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbXDLIdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:33:12 -0400
From: Buytaert_Steven@emc.com
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: sched_yield proposals/rationale
Date: Thu, 12 Apr 2007 04:31:19 -0400
Message-ID: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sched_yield proposals/rationale
Thread-Index: Acd83PIUvTXFaF8RQzOXqjaBmkKSwg==
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Apr 2007 08:31:21.0133 (UTC) FILETIME=[F2CA1DD0:01C77CDC]
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.4.12.10534
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, NO_REAL_NAME 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __IMS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the new 2.6.x O(1) scheduler I'm having latency problems. Probably due
to excessive use of sched_yield in code in components I don't have control
over. This 'problem'/behavioral change has been reported also by other
applications (e.g. OpenLDAP, Gnome netmeeting, Postgress, e.google...)

I have analysed the sched_yield code in kernel/sched.c (2.6.16 SLES10) and have 3 questions/proposals:

1) Would it be beneficial to give each task one try to be enqueued on the
end of the active queue (by means of a boolean flag, reset each time the
time slices reach 0 and it is put in the expired list by scheduler_tick)?

2) When a task is eventually put in the expired list in sched_yield, give it
back the full time slices round (as done in scheduler_tick), not with the
remaining slices as is done now?

3) Put the task in the expired list at a random position, not at the end as
is done now?

Rationales:

For 1) suppose the resource that the task wants to acquire (if any) and for
which it yields, since it is not available, is kept by another task that is
in the active list, behind this task. Putting the task on the expired list
would induce some kind of 'tail chasing'. This would be broken by 1.

For 2) When a task is put on the expired list with e.g. 1 time quantum left,
next time it gets the resource and is put on the expired list at the next
scheduler_tick occurence, before it has the chance to release the resource
again, keeping it for a longer time than necessary.

For 3) when the resource (if any) is requested by many tasks
regularly, always putting the yielding task at the end of the expired list
could result in 'unfairness' since the resource is handed out to the tasks
as they get on the cpu. The only 'fairness' that can be applied with yield
is than to insert in a random position.

Any insight on these proposed changes? Thanks

Steven Buytaert
--
La perfection est atteinte non quand il ne reste rien ajouter, mais quand il ne reste rien à enlever. (Antoine de Saint-Exupéry)

