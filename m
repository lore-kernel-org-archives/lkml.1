Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYIJQ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYIJQ0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYIJQ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:26:46 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48269 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYIJQ0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:26:46 -0400
Date: Wed, 10 Sep 2008 20:32:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Frank Mayhar <fmayhar@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
Message-ID: <20080910163205.GA478@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com> <20080909070329.GD2086@elte.hu> <20080909160152.GA714@tv-sign.ru> <1220992172.23059.20.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220992172.23059.20.camel@bobble.smo.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Frank Mayhar wrote:
>
> On Tue, 2008-09-09 at 20:01 +0400, Oleg Nesterov wrote:
> > The patch has a lot of
> >
> > 	rcu_read_lock();
> > 	sig = rcu_dereference(tsk->signal);
> >
> > This is bogus, task_struct->signal is not protected by RCU.
>
> I just want to snapshot the field
> atomically.  I guess I can just do an atomic read...

Missed this part...

No, no, you don't need an atomic read. Just do

	sig = tsk->signal;
	if (sig)
		use(sig);

->signal must be stable, or the code is buggy anyway. (and the task
never changes its ->signal, it becomes NULL when the task dies).


BTW, thanks for doing this!

Oleg.

