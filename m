Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXDWUue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXDWUue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXDWUud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:50:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51472 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXDWUub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:50:31 -0400
Date: Mon, 23 Apr 2007 15:50:20 -0500
To: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linux-s390@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
Message-ID: <20070423205020.GR31947@austin.ibm.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769695763104-git-send-email-ebiederm@xmission.com> <20070422123155.GF20763@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422123155.GF20763@infradead.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 01:31:55PM +0100, Christoph Hellwig wrote:
> On Thu, Apr 19, 2007 at 01:58:45AM -0600, Eric W. Biederman wrote:
> > From: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > This patch modifies the startup of eehd to use kthread_run
> > not a combination of kernel_thread and daemonize.  Making
> > the code slightly simpler and more maintainable.
> 
> This one has the same scheme as the various s390 drivers where a thread
> is spawned using a workqueue on demand.  I think we should not blindly
> convert it but think a litte more about it.
> 
> The first question is obviously, is this really something we want?
> spawning kernel thread on demand without reaping them properly seems
> quite dangerous.

I'm not quite sure what the intent of this patch really is, being
at most a somewhat passing and casual user of kernel threads.

Some background may be useful: (this in reply to some comments from
Andrew Morton)

EEH events are supposed to be very rare, as they correspond to 
hardware failures, typically PCI bus parity errors, but also 
things like wild DMA's.  The code that generates these will limit
them to no more than 6 per hour per pci device. Any more than that,
and the PCI device is permanently disabled (the sysadmin would 
need to do something to recover).

The only reason for using threads here is to get the error recovery
out of an interrupt context (where errors may be detected), and then,
an hour later, decrement a counter (which is how we limit these to 
6 per hour). Thread reaping is "trivial", the thread just exits
after an hour.

Since these are events rare, I've no particular concern about
performance or resource consumption. The current code seems 
to work just fine. :-)

--linas
