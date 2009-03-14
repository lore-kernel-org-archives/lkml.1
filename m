Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbZCNED2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbZCNED2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZCNEDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:03:18 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:48468 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZCNEDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:03:17 -0400
Subject: Re: [PATCH] fs: fput() can be called from interrupt context
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Jeff Moyer <jmoyer@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, Benjamin LaHaise <bcrl@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
	 <49B54143.1010607@redhat.com>
	 <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
	 <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com>
	 <49B87CFE.4000701@cosmosbay.com> <49B89B22.7080303@cosmosbay.com>
	 <20090311224712.fb8db075.akpm@linux-foundation.org>
	 <49B8A75E.6040409@cosmosbay.com>
	 <20090311233903.f036027a.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>
	 <1236986902.7265.73.camel@heimdal.trondhjem.org>
	 <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 00:02:08 -0400
Message-Id: <1237003328.7265.98.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 71EB722F48060EEEDFF4AE327AB16182BFF0AFD4
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 54 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 18:40 -0700, Davide Libenzi wrote:
> On Fri, 13 Mar 2009, Trond Myklebust wrote:
> 
> > On Thu, 2009-03-12 at 06:39 -0700, Davide Libenzi wrote:
> > > On Wed, 11 Mar 2009, Andrew Morton wrote:
> > > 
> > > > > Take the time to check how fs/aio.c handle the fput(req->ki_filp) case
> > > > > (or read my 2nd patch, it should spot the thing)
> > > > 
> > > > Well yes, a kludge like that seems a bit safer.
> > > > 
> > > > It's somewhat encouraging that we're apparently already doing fput()
> > > > from within keventd (although how frequently?).  There might be
> > > > problems with file locking, security code, etc from doing fput() from
> > > > an unexpected thread.  And then there are all the usual weird problem
> > > > with using the keventd queues which take a long time to get discovered.
> > > 
> > > Would it be a huge problem, performance-wise, to stop making ->f_count 
> > > tricks in __aio_put_req, and always offload to fput_work the task of 
> > > releasing the requests?
> > > If that's a huge problem, IMO the lower impact fix would be to use 
> > > aio_fput_routine to loop into a second list, releasing the eventual 
> > > eventfd file*. There's no need, IMO, to turn the whole fput() into 
> > > IRQ-callable just for this case, when we can contain it into the 
> > > particular KAIO+eventfd usage.
> > > 
> > 
> > Do you really want to see eventd doing umounts and remote flock() calls?
> > This really needs to be run in a thread that can cope with __long__
> > waits, unavailable servers, etc...
> 
> Did I miss something? This wouldn't be (eventually) on keventd shoulders, 
> but on aio work queue (aio_wq).
> I guess we could do the same optimization we're already doing for ki_filp, 
> for ki_eventfd ...

Last I checked, a call to schedule_work(&fddef->wq) would still run
fd_defer_queue() under keventd.

That said, even if you were to run it under aio_wq, the argument remains
the same: do you really want to add potentially long lasting sleeps onto
a work queue that was designed to service fast i/o requests?

Trond

