Return-Path: <linux-kernel-owner+w=401wt.eu-S1422981AbXBHIfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422981AbXBHIfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423039AbXBHIfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:35:52 -0500
Received: from mail.screens.ru ([213.234.233.54]:44125 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422981AbXBHIfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:35:51 -0500
Date: Thu, 8 Feb 2007 11:35:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Horms <horms@verge.net.au>
Cc: Daniel Drake <dsd@gentoo.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/6] workqueue: make cancel_rearming_delayed_workqueue() work on idle dwork
Message-ID: <20070208083539.GA85@tv-sign.ru>
References: <20070206233016.GA108@tv-sign.ru> <45C9E320.3070001@gentoo.org> <20070207151630.GA138@tv-sign.ru> <20070207174355.GA340@tv-sign.ru> <20070208022051.GC17585@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208022051.GC17585@verge.net.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Horms wrote:
>
> On Wed, Feb 07, 2007 at 08:43:55PM +0300, Oleg Nesterov wrote:
> > 
> > I think we have another problem with delayed_works.
> > 
> > cancel_rearming_delayed_workqueue() doesn't garantee that the ->func() is not
> > running upon return. I don't know if it is bug or not, the comment says nothing
> > about that.
> > 
> > However, we have the callers which seem to assume the opposite, example
> > 
> > 	net/ipv4/ipvs/ip_vs_core.c
> > 
> > 		module_exit
> > 		    ip_vs_cleanup
> > 		        ip_vs_control_cleanup
> > 		            cancel_rearming_delayed_work
> > 		// done
> > 
> > This is unsafe. The module may be unloaded and the memory may be freed
> > while defense_work_handler() is still running/preempted.
> > 
> > Unless I missed something, which side should be fixed?
> 
> Assuming the decision is to fix the ipvs side, is the fix
> just to remove the call to cancel_rearming_delayed_work() in
> ip_vs_control_cleanup() ?

I think ip_vs_control_cleanup() should also do flush_workqueue() after
cancel_rearming_delayed_work().

This is ugly, because we have flush_work() but can't use it on delayed
works. This is possible to change, but not so trivial.

Andrew, do you think it is worth to tweak delayed works so it would be
possible to use flush_work(dwork->work) ?

Oleg.

