Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZKJNIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZKJNIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZKJNIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:08:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:64135 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZKJNIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:08:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,716,1249282800"; 
   d="scan'208";a="209761825"
Date: Tue, 10 Nov 2009 21:08:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
       Peter Staubach <staubach@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: Re: Likley stupid question on "throttle_vm_writeout"
Message-ID: <20091110130818.GA6229@localhost>
References: <799070.68490.qm@web32608.mail.mud.yahoo.com> <1257780393.4108.343.camel@laptop> <20091110020858.GA5749@localhost> <707547.6272.qm@web32605.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <707547.6272.qm@web32605.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 08:01:47PM +0800, Martin Knoblauch wrote:
> ----- Original Message ----
> 
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > To: Peter Zijlstra <peterz@infradead.org>
> > Cc: Martin Knoblauch <spamtrap@knobisoft.de>; linux-kernel@vger.kernel.org
> > Sent: Tue, November 10, 2009 3:08:58 AM
> > Subject: Re: Likley stupid question on "throttle_vm_writeout"
> > 
> > On Mon, Nov 09, 2009 at 04:26:33PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2009-11-09 at 07:15 -0800, Martin Knoblauch wrote:
> > > > Hi, (please CC me on replies)
> > > > 
> > > >  I have a likely stupid question on the function "throttle_vm_writeout". 
> > Looking at the code I find:
> > > > 
> > > >                 if (global_page_state(NR_UNSTABLE_NFS) +
> > > >                         global_page_state(NR_WRITEBACK) <= dirty_thresh)
> > > >                                 break;
> > > >                 congestion_wait(WRITE, HZ/10);
> > > > 
> > > > Shouldn't the NR_FILE_DIRTY pages be considered as well?
> > > 
> > > Ha, you just trod onto a piece of ugly I'd totally forgotten about ;-)
> > > 
> > > The intent of throttle_vm_writeout() is to limit the total pages in
> > > writeout and to wait for them to go-away.
> > 
> > Like this:
> > 
> >         vmscan fast => large NR_WRITEBACK => throttle vmscan based on it
> > 
> > > Everybody hates the function, nobody managed to actually come up with
> > > anything better.
> > 
> > btw, here is another reason to limit NR_WRITEBACK: I saw many
> > throttle_vm_writeout() waits if there is no wait queue to limit
> > NR_WRITEBACK (eg. NFS). In that case the (steadily) big NR_WRITEBACK
> > is _not_ caused by fast vmscan..
> > 
> 
>  That is exactely what made me look again into the code. My observation is that when doing something like:
> 
> dd if=/dev/zero of=fast-local-disk bs=1M count=15000
> 
> most of the "dirty" pages are in NR_FILE_DIRTY with some relatively small amount (10% or so) in NR_WRITEBACK. If I do:
> 
> dd if=/dev/zero of=some-nfs-mount bs=1M count=15000
> 
> NR_WRITEBACK almost immediatelly goes up to dirty_ratio, with
> NR_UNSTABLE_NFS small. Over time NR_UNSTABLE_NFS grows, but is
> always lower than NR_WRITEBACK (maybe 40/60).

This is interesting, though I don't see explicit NFS code to limit
NR_UNSTABLE_NFS. Maybe there are some implicit rules.

>  But don't ask what happens if I do both in parallel.... The local
>  IO really slows to a crawl and sometimes the system just becomes
>  very unresponsive. Have we heard that before? :-)

You may be the first reporter as far as I can tell :)

>  Somehow I have the impression that NFS writeout is able to
>  absolutely dominate the dirty pages to an extent that the system is
>  unusable.

This is why I want to limit NR_WRITEBACK for NFS:

        [PATCH] NFS: introduce writeback wait queue
        http://lkml.org/lkml/2009/10/3/198

Thanks,
Fengguang
