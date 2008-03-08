Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbYCHADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbYCHADT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 19:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYCHADI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 19:03:08 -0500
Received: from smtp-out.google.com ([216.239.45.13]:53483 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYCHADF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 19:03:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=ossnl/i939EcTXznyOCN+ox7rgFsu0yTcHTbi9tNKhSFMitnkygwNfTfAo+LRHwRZ
	cl9uPImP7roT5LJVBbHzQ==
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: parag.warudkar@gmail.com,
       Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <1204932363.8797.9.camel@bobble.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204932363.8797.9.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 07 Mar 2008 16:01:37 -0800
Message-Id: <1204934497.8797.11.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 15:26 -0800, Frank Mayhar wrote:
> Based on Roland's comments and from reading the source, I have a
> possible fix.  I'm posting the attached patch _not_ for submission but
> _only_ for comment.  For one thing it's based on 2.6.18.5 and for
> another it hasn't had much testing yet.  I wanted to get it out here for
> comment, though, in case anyone can see where I might have gone wrong.
> Comments, criticism and (especially!) testing enthusiastically
> requested.

The previous email was missing one small part of the patch, reproduced
below.  Remain calm.
----------------------------------BEGIN------------------------------------
diff -urp /home/fmayhar/Static/linux-2.6.18.5/kernel/compat.c linux-2.6.18.5/kernel/compat.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/compat.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/compat.c	2008-03-06 17:26:21.000000000 -0800
@@ -161,18 +161,11 @@ asmlinkage long compat_sys_times(struct 
 	if (tbuf) {
 		struct compat_tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
 
 		read_lock(&tasklist_lock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
+		utime = tsk->signal->shared_utime;
+		stime = tsk->signal->shared_stime;
 
 		/*
 		 * While we have tasklist_lock read-locked, no dying thread
-----------------------------------END-------------------------------------
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

