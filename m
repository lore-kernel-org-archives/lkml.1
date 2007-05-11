Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXEKXRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXEKXRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbXEKXRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:17:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbXEKXRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:17:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 01:22:06 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <200705112240.54304.rjw@sisk.pl> <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705120122.07177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 00:56, Linus Torvalds wrote:
> 
> On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> > 
> > For user space processes this condition is always true.
> > 
> > For kernel threads:
> > (1) the change of tsk->mm from NULL to a nonzero value is only made in
> > fs/aio.c:use_mm() along with the setting of PF_BORROWED_MM under
> > the task_lock(),
> > (2) the change of tsk->mm from a nonzero value to NULL is only made in
> > fs/aio.c:unuse_mm() along with the resetting of PF_BORROWED_MM
> > under the task_lock().
> > Therefore, by taking the task_lock() here we make sure that the condition
> > is alyways false when we check it for kernel threads.
> 
> Why *test* it then and return anything?
> 
> Why not just doa "task_lock(p); task_unlock(p);" with no return value? 
> 
> As it is, it sounds like either the code is buggy, or it's pointless.

I'm not sure what you mean.

We use this function (ie. kernel/power/process.c:is_user_space()) to
distinguish kernel threads from user space processes.  Therefore we make it
always return true for user space processes and always return false for kernel
threads.  In the latter case we need to use the task_lock() to ensure that the
result is as desired (ie. false), because otherwise it might be racing with
either fs/aio.c:use_mm() or fs/aio.c:unuse_mm().

Rafael
