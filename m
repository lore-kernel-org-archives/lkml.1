Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbYBWTvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbYBWTvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYBWTv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:51:26 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:51238 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbYBWTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r7eaE/lPo7bW5E5H4NyGjyP8URsvMIzKNhSkmxdpNCZqrh0B3x6g6yPFhjbuHYpOLPgOpWWv1qyBcV6vU+KUSD5RVfXmA5SeLQH1hL0wydJ9ZxtKBm88IgtAptxDZMCXYVTwrmS/V7tK++03FDKOkiB3/kyGkIBL+1WH3iHeEV8=
Message-ID: <b647ffbd0802231151w481fdcb5hc2a3972e7fd03f69@mail.gmail.com>
Date: Sat, 23 Feb 2008 20:51:23 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch added to -mm tree
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, apw@shadowen.org, "Ingo Molnar" <mingo@elte.hu>,
       nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0802231044240.21332@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org>
	 <20080223162705.GA7686@tv-sign.ru>
	 <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org>
	 <20080223182258.GA19946@tv-sign.ru>
	 <alpine.LFD.1.00.0802231044240.21332@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/2008, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
>  On Sat, 23 Feb 2008, Oleg Nesterov wrote:
>  >
>
> > Yes, but still I suspect wmb() is not enough. Note that try_to_wake_up()
>  > first checks (reads) the task->state,
>  >
>  >       if (!(old_state & state))
>  >               goto out;
>  >
>  > without the full mb() it is (in theory) possible that try_to_wake_up()
>  > first reads TASK_RUNNING and only then sets CONDITION. IOW, STORE and
>  > LOAD could be re-ordered.
>
>
> No. The spinlock can have preceding stores (and loads, for that matter)
>  percolate *into* the locked region, but a spinlock can *not* have loads
>  (and stores) escape *out* of the region withou being totally broken.

it's not a LOAD that escapes *out* of the region. It's a MODIFY that gets *in*:

(1)

MODIFY(a);

LOCK

LOAD(b);

UNLOCK


can become:

(2)

LOCK

MOFIDY(a)
LOAD(b);

UNLOCK

and (reordered)

(3)

LOCK

LOAD(a)
MODIFY(b)

UNLOCK

and this last one is a problem. No?


>
>                 Linus
>

-- 
Best regards,
Dmitry Adamushko
