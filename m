Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbXICNmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbXICNmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbXICNmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:42:07 -0400
Received: from styx.suse.cz ([82.119.242.94]:44571 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751077AbXICNmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:42:06 -0400
Date: Mon, 3 Sep 2007 16:01:35 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: folkert@vanheusden.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [2.6.22] circular lock detected
Message-ID: <20070903140135.GE7524@duck.suse.cz>
References: <20070824210033.GB13237@vanheusden.com> <20070902045529.c66eddc9.akpm@linux-foundation.org> <20070903122702.GC29908@atrey.karlin.mff.cuni.cz> <20070903054959.3ecd9576.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903054959.3ecd9576.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-09-07 05:49:59, Andrew Morton wrote:
> > On Mon, 3 Sep 2007 14:27:02 +0200 Jan Kara <jack@suse.cz> wrote:
> > > > On Fri, 24 Aug 2007 23:00:33 +0200 Folkert van Heusden <folkert@vanheusden.com> wrote:
> > > > Hi,
> > > > 
> > > > 2.6.22 kernel with hyperthreading enabled only ext3 filesystems (2).
> > > > 
> > > > [  346.314640] =======================================================
> > > > [  346.314758] [ INFO: possible circular locking dependency detected ]
> > > > [  346.314815] 2.6.22 #5
> > > > [  346.314862] -------------------------------------------------------
> > > > [  346.314920] tor/2421 is trying to acquire lock:
> > > > [  346.314973]  (tty_mutex){--..}, at: [<c121aa83>] mutex_lock+0x8/0xa
> > > > [  346.315193] 
> > > > [  346.315195] but task is already holding lock:
> > > > [  346.316203]  (&s->s_dquot.dqptr_sem){----}, at: [<c10a485f>] dquot_alloc_space+0x50/0x189
> > > > [  346.316457] 
> > > > [  346.316458] which lock already depends on the new lock.
> >
> > ...
> >
> > > > [  346.353603]  =======================
> > > > 
> > > Has been reported before, but I don't recall whether we fixed it.  Jan,
> > > do you know>?
> >   I think we at least found a solution: Teach lockdep that I_MUTEX for
> > different filesystems is different. Peter Zilstra wrote a patch for that
> > and Folkert even confirmed that it fixes the problem for him. I'm not
> > sure what happened with the patch afterwards though. Adding Peter to CC
> > :).
> 
> But this is a tty_lock-versus-dqptr_sem ranking error.  Unrelated to i_mutex?
  The final report is for this ranking but the locking chain (if I understand it
right) is:
tty_mutex (con_close) -> i_mutex (sysfs: remove_subdir)
i_mutex (do_truncate) -> i_alloc_sem (notify_change) -> truncate_mutex (ext3_truncate)
truncate_mutex (ext3_get_blocks_handle) -> dqptr_sem (dquot_alloc_space)

So it complains about tty_mutex vs dqptr_sem (I don't know why it does not
complain about tty_mutex vs i_mutex) but the wrong link in the chain is
that i_mutex from remove_subdir() [sysfs] and i_mutex from do_truncate()
[ext3] are different and should never depend on each other...

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
