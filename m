Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZCDRIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZCDRIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZCDRI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:08:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZCDRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:08:28 -0500
Subject: Re: 2.6.27.14: BUG: lock held when returning to user space!
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090304165830.GC8748@atrey.karlin.mff.cuni.cz>
References: <20090225142136.GA29505@janus>
	 <1235579389.4645.3621.camel@laptop>
	 <20090304165830.GC8748@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 18:08:04 +0100
Message-Id: <1236186484.5330.8185.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 17:58 +0100, Jan Kara wrote:
> > On Wed, 2009-02-25 at 15:21 +0100, Frank van Maarseveen wrote:
> > > An lvextend -L+16G command for a logical volume while being mounted rw
> > > as ext3 triggered the following on 2.6.27.14:
> > > 
> > > ================================================
> > > [ BUG: lock held when returning to user space! ]
> > > ------------------------------------------------
> > > lvextend/29191 is leaving the kernel with locks still held!
> > > 2 locks held by lvextend/29191:
> > >  #0: (&type->s_umount_key #15){....}, at: [<c019edfb>] get_super+0x6b/0xb0
> > >  #1: (&journal->j_barrier){....}, at: [<c01f9af3>] journal_lock_updates+0xc3/0xd0
> > 
> > Do recent kernels still say this?
>
>   I'd say so. We really hold j_barrier mutex when leaving the kernel
> after FIFREEZE ioctl (the call path goes as freeze_bdev -> ext3_freeze
> -> journal_lock_updates) until FITHAW is called. As far as I know it was
> designed this way...
>   It would be a pity to completely exclude j_barrier mutex from lockdep
> control so would it be possible to mark the mutex (or even that
> particular acquisition of the mutex) so that lockdep does not warn when
> we return with it to userspace?

Linus specificly stated that we are not to keep locks held when
returning to userspace:

  http://lkml.org/lkml/2007/10/27/135

So sure, we could annotate this, but no I won't until you can convince
both me and Linus that its a sane thing to do.

The problems include: how can you be sure its the same task calling the
completing ioctl?

