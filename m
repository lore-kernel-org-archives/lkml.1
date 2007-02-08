Return-Path: <linux-kernel-owner+w=401wt.eu-S1423051AbXBHIkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423051AbXBHIkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423058AbXBHIkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:40:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33431 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423051AbXBHIkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:40:03 -0500
Date: Thu, 8 Feb 2007 00:39:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Horms <horms@verge.net.au>, Daniel Drake <dsd@gentoo.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/6] workqueue: make cancel_rearming_delayed_workqueue()
 work on idle dwork
Message-Id: <20070208003927.d8f8cb78.akpm@linux-foundation.org>
In-Reply-To: <20070208083539.GA85@tv-sign.ru>
References: <20070206233016.GA108@tv-sign.ru>
	<45C9E320.3070001@gentoo.org>
	<20070207151630.GA138@tv-sign.ru>
	<20070207174355.GA340@tv-sign.ru>
	<20070208022051.GC17585@verge.net.au>
	<20070208083539.GA85@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 11:35:39 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 02/08, Horms wrote:
> >
> > On Wed, Feb 07, 2007 at 08:43:55PM +0300, Oleg Nesterov wrote:
> > > 
> > > I think we have another problem with delayed_works.
> > > 
> > > cancel_rearming_delayed_workqueue() doesn't garantee that the ->func() is not
> > > running upon return. I don't know if it is bug or not, the comment says nothing
> > > about that.
> > > 
> > > However, we have the callers which seem to assume the opposite, example
> > > 
> > > 	net/ipv4/ipvs/ip_vs_core.c
> > > 
> > > 		module_exit
> > > 		    ip_vs_cleanup
> > > 		        ip_vs_control_cleanup
> > > 		            cancel_rearming_delayed_work
> > > 		// done
> > > 
> > > This is unsafe. The module may be unloaded and the memory may be freed
> > > while defense_work_handler() is still running/preempted.
> > > 
> > > Unless I missed something, which side should be fixed?
> > 
> > Assuming the decision is to fix the ipvs side, is the fix
> > just to remove the call to cancel_rearming_delayed_work() in
> > ip_vs_control_cleanup() ?
> 
> I think ip_vs_control_cleanup() should also do flush_workqueue() after
> cancel_rearming_delayed_work().
> 
> This is ugly, because we have flush_work() but can't use it on delayed
> works. This is possible to change, but not so trivial.
> 
> Andrew, do you think it is worth to tweak delayed works so it would be
> possible to use flush_work(dwork->work) ?
> 

I've completely lost track of what you've been doing in there (this is a
problem) but sure, if the patch isn't too horrid it's always better to be
robust in the core than to have to work around inadequacies in the callers.

