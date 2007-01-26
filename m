Return-Path: <linux-kernel-owner+w=401wt.eu-S1030601AbXAZQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030601AbXAZQLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030620AbXAZQLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:11:30 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:48283 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030601AbXAZQL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:11:29 -0500
Subject: Re: mutex ownership (was: Re: [PATCH 19/24] Unionfs: Helper
	macros/inlines)
From: Steven Rostedt <rostedt@goodmis.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arjan <arjan@infradead.org>
In-Reply-To: <200701091009.30063.oliver@neukum.org>
References: <1168229596580-git-send-email-jsipek@cs.sunysb.edu>
	 <20070108132817.5c9a30d6.akpm@osdl.org> <1168333376.12503.22.camel@twins>
	 <200701091009.30063.oliver@neukum.org>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 11:10:36 -0500
Message-Id: <1169827836.26770.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-09 at 10:09 +0100, Oliver Neukum wrote:
> Am Dienstag, 9. Januar 2007 10:02 schrieb Peter Zijlstra:

> > Its a fundamental property of a mutex, not a shortcoming. A mutex has an
> > owner, the one that takes and releases the resource. This allows things
> > such as Priority Inheritance to boost owners.
> > 
> > 'fixing' this takes away much of what a mutex is.
> > 
> > That said, it seems some folks really want this to happen, weird as it
> > may be. I'm not sure if all these cases are because of wrong designs. A
> > possible extension to the mutex interface might be something like this:
> > 
> >   mutex_pass_owner(struct task_struct *task);
> > 
> > which would be an atomic unlock/lock pair where the current task
> > releases the resource and the indicated task gains it. However it must
> > be understood that from the POV of 'current' this should be treated as
> > an unlock action.
> 
> This won't help if I want to release from an interrupt handler or tasklet.

Then that shouldn't use a mutex. A mutex is for "mutual exclusion", and
not "shared exclusion".  Peter is right that the fundamental property of
a mutex, is that it is for a single thread.  And it should never be
released by a separate thread than the one that grabbed it.

A semaphore can be used as a mutex, but not the other way around.

I wouldn't even recommend doing the mutex_pass_owner().  To do so, the
process calling this must be the owner, and the parameter must be a
thread waiting on the mutex. If it is not, then that could introduce
some really nasty races and bugs.

The mutex_unlock_dont_warn_if_a_different_task_did_it() is also a bad
idea.

-- Steve

