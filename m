Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbYCXOci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbYCXOci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbYCXOcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:32:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:7741 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbYCXOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mgexkkBhSdkoLU+EWEshEDjYduIB5WKiFOD4RSVx35eafHarSObBRVWnjKNLbR291oKV6yw7vy0/NYJMly8EFexDhG3nc/feBHYUsSpSgiwYl1maP9wSIj4UHvlMuSx60OlUa3N0N9tyVGRhG6N5gG3pLbVKTj3Goub6NV2904U=
Date: Mon, 24 Mar 2008 15:31:45 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
Message-ID: <20080324143141.GA6019@joi>
References: <20080324122424.671168000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324122424.671168000@chello.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 01:24:24PM +0100, Peter Zijlstra wrote:
> Hi Linus,
> 
> As to the regression reported by Marcin; what happens is that we invoke
> printk() while holding the xtime lock for writing. printk() will call
> wake_up_klogd() which tries to enqueue klogd on some rq.
> 
> The known deadlock here is calling printk() while holding rq->lock, which
> would then try to recusively lock the rq again when trying to wake klogd.
> 
> The new deadlock is due to task enqueues setting an hrtimer, which requires
> reading the time, which will result in a live-lock when the printk() call-
> site is holding the xtime lock for writing.
> 
> Thomas would like to preserve the printk() information if possible, hence my
> proposal of printk_nowakeup(). It will do everything printk() normally does,
> except ommit to wake up of klogd. The call is explicitly not EXPORTed so that
> its use is confined to core kernel code.
> 
> Marcin, could you please test these two patches to confirm they do indeed
> solve your issue as well?

I've successfully tested these patches. Thanks.
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>

Marcin
