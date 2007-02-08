Return-Path: <linux-kernel-owner+w=401wt.eu-S1422743AbXBHDJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422743AbXBHDJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422741AbXBHDJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:09:00 -0500
Received: from koto.vergenet.net ([210.128.90.7]:59874 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965650AbXBHDJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:09:00 -0500
Date: Thu, 8 Feb 2007 11:20:51 +0900
From: Horms <horms@verge.net.au>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Drake <dsd@gentoo.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/6] workqueue: make cancel_rearming_delayed_workqueue() work on idle dwork
Message-ID: <20070208022051.GC17585@verge.net.au>
References: <20070206233016.GA108@tv-sign.ru> <45C9E320.3070001@gentoo.org> <20070207151630.GA138@tv-sign.ru> <20070207174355.GA340@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207174355.GA340@tv-sign.ru>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 08:43:55PM +0300, Oleg Nesterov wrote:
> On 02/07, Oleg Nesterov wrote:
> > 
> > The following code
> > 
> > 	schedule_delayed_work(dw);
> > 	cancel_rearming_delayed_workqueue(dw);	// OK
> > 	cancel_rearming_delayed_workqueue(dw);	// HANGS!
> > 
> > still doesn't work.
> 
> I think we have another problem with delayed_works.
> 
> cancel_rearming_delayed_workqueue() doesn't garantee that the ->func() is not
> running upon return. I don't know if it is bug or not, the comment says nothing
> about that.
> 
> However, we have the callers which seem to assume the opposite, example
> 
> 	net/ipv4/ipvs/ip_vs_core.c
> 
> 		module_exit
> 		    ip_vs_cleanup
> 		        ip_vs_control_cleanup
> 		            cancel_rearming_delayed_work
> 		// done
> 
> This is unsafe. The module may be unloaded and the memory may be freed
> while defense_work_handler() is still running/preempted.
> 
> Unless I missed something, which side should be fixed?

Assuming the decision is to fix the ipvs side, is the fix
just to remove the call to cancel_rearming_delayed_work() in
ip_vs_control_cleanup() ?

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

