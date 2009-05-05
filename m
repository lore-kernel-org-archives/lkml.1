Return-Path: <linux-kernel-owner+w=401wt.eu-S1751781AbZEEOuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbZEEOuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZEEOua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:50:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37466 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZEEOu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:50:29 -0400
Date: Tue, 5 May 2009 10:49:37 -0400
From: Neil Horman <nhorman@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, akpm@linux-foundation.org,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com
Subject: Re: [PATCH] sysrq: Simplify sysrq-c handler
Message-ID: <20090505144937.GD11817@hmsreliant.think-freely.org>
References: <20090505134547.GA11780@hmsreliant.think-freely.org> <20090505142359.GB9909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505142359.GB9909@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 10:23:59AM -0400, Vivek Goyal wrote:
> On Tue, May 05, 2009 at 09:45:47AM -0400, Neil Horman wrote:
> > Currently the sysrq-c handler is bit over-engineered.  Its behavior is dependent
> > on a few compile time and run time factors that alter its behavior which is
> > really unnecessecary.  If CONFIG_KEXEC is not configured, sysrq-c, crashes the
> > system with a NULL pointer dereference.  If CONFIG_KEXEC is configured, it calls
> > crash_kexec directly, which implies that the kexec kernel will either be booted
> > (if its been previously loaded), or it will simply do nothing (the no kexec
> > kernel has been loaded).  It would be much easier to just simplify the whole
> > thing to dereference a NULL pointer all the time regardless of configuration.
> > That way, it will always try to crash the system, and if a kexec kernel has been
> > loaded into reserved space, it will still boot from the page fault trap handler
> > (assuming panic_on_oops is set appropriately).
> > 
> 
> Neil,
> 
> Would it make sense to call panic() directly so that we are not dependent
> on panic_on_oops being set?
> 
> Thanks
> Vivek
> 
I think a good argument could be made for doing that, but I kind of like
traversing the entire page fault path, specifically to make sure that an oops
works the way they expect it too.  If nothing else, going through the entire
oops path like I do below will (hopefully) prevent people from complaining that
sysrq-c works, but when their custom module gets an OOPS, then never get a
vmcore :).

I'll defer to an opposing consensus of course, but I think going through the
entire oops path is a better solution.
Regards
Neil

