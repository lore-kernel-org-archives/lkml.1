Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbXHVKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbXHVKB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXHVKBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:01:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33851 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbXHVKBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:01:48 -0400
Date: Wed, 22 Aug 2007 14:02:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_sigaction: don't worry about signal_pending()
Message-ID: <20070822100210.GA139@tv-sign.ru>
References: <20070820160157.GA1279@tv-sign.ru> <20070822094325.GF1684@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822094325.GF1684@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Jarek Poplawski wrote:
>
> On 20-08-2007 18:01, Oleg Nesterov wrote:
> > do_sigaction() returns -ERESTARTNOINTR if signal_pending(). The comment says:
> > 
> > 	* If there might be a fatal signal pending on multiple
> > 	* threads, make sure we take it before changing the action.
> > 	
> > I think this is not needed. We should only worry about SIGNAL_GROUP_EXIT case,
> > bit it implies a pending SIGKILL which can't be cleared by do_sigaction.
> 
> Isn't it for optimization e.g., to skip this 'do while' loop below for
> such multiple threads, which would get SIGKILL or SIGSTOP anyway?

Yes, in that case this 'do while' doesn't make sense. But this is very
unlikely, sigaction() shouldn't be called too much often, better to save
a couple of bytes from icache.

Also, please note that sigaction() is not special, almost any system call
could be started with

	if (current->signal->flags & SIGNAL_GROUP_EXIT)
		return ANYVALUE;

to "optimize" for the case when the task is dying.

Oleg.

