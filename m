Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXHVKwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXHVKwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXHVKw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:52:26 -0400
Received: from mx10.go2.pl ([193.17.41.74]:34040 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754175AbXHVKwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:52:25 -0400
Date: Wed, 22 Aug 2007 12:53:29 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_sigaction: don't worry about signal_pending()
Message-ID: <20070822105329.GG1684@ff.dom.local>
References: <20070820160157.GA1279@tv-sign.ru> <20070822094325.GF1684@ff.dom.local> <20070822100210.GA139@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822100210.GA139@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:02:10PM +0400, Oleg Nesterov wrote:
> On 08/22, Jarek Poplawski wrote:
> >
> > On 20-08-2007 18:01, Oleg Nesterov wrote:
> > > do_sigaction() returns -ERESTARTNOINTR if signal_pending(). The comment says:
> > > 
> > > 	* If there might be a fatal signal pending on multiple
> > > 	* threads, make sure we take it before changing the action.
> > > 	
> > > I think this is not needed. We should only worry about SIGNAL_GROUP_EXIT case,
> > > bit it implies a pending SIGKILL which can't be cleared by do_sigaction.
> > 
> > Isn't it for optimization e.g., to skip this 'do while' loop below for
> > such multiple threads, which would get SIGKILL or SIGSTOP anyway?
> 
> Yes, in that case this 'do while' doesn't make sense. But this is very
> unlikely, sigaction() shouldn't be called too much often, better to save
> a couple of bytes from icache.
> 
> Also, please note that sigaction() is not special, almost any system call
> could be started with
> 
> 	if (current->signal->flags & SIGNAL_GROUP_EXIT)
> 		return ANYVALUE;
> 
> to "optimize" for the case when the task is dying.

OK, I only wasn't sure this was considered before getting this
"not needed" verdict.

BTW, sometimes, even if something is very unlikely, but very
time-consuming, and skipping this isn't so costly, there could be
a gain at the end. So, maybe it's about individual cases and some
testing too? (At least, it seems, somebody found this so usable,
she/he bothered with such a long comment, and we know it's a last
thing any decent kernel hacker would care to do...)

Jarek P.
