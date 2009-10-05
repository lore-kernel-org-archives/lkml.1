Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbZJEK5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbZJEK5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbZJEK5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:57:30 -0400
Received: from www.tglx.de ([62.245.132.106]:54718 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbZJEK53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:57:29 -0400
Date: Mon, 5 Oct 2009 12:56:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Anirban Sinha <ani@anirban.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
In-Reply-To: <1254738974.26976.24.camel@twins>
Message-ID: <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>  <20091001092218.GH15345@elte.hu>  <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>  <4AC68F13.8050601@us.ibm.com>  <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
  <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>  <4AC8CF32.8060108@anirban.org>  <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain> <1254738974.26976.24.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Mon, 5 Oct 2009, Peter Zijlstra wrote:

> On Sun, 2009-10-04 at 18:59 +0200, Thomas Gleixner wrote:
> 
> > > do. It does not feel right. Currently, with or without my change,
> > > such a thing would indefinitely block other waiters on the same
> > > futex.
> > 
> > Right. Which completely defeats the purpose of the robust list. Will
> > have a look tomorrow.
> 
> Right, so mm_release() which is meant to destroy the old mm context
> actually does exit_robust_list(), but the problem is that it does so on
> the new mm, not the old one that got passed down to mm_release().
> 
> The other detail is that exit_robust_list() doesn't clear
> current->robust_list.

I know.

> The problem with the patch send my Ani is that it clears the robust
> lists before the point of no return, so on a failing execve() we'd have
> messed up the state.

Right. We need to do that at the latest possible point.

Looking more into that I think we should check whether the robust list
has an entry (lock held) in do_execve() and return -EWOULDBLOCK to
luser space. Same if pi_waiters is not empty. Holding a lock and
calling execve() is simply broken.

Thanks,

	tglx
