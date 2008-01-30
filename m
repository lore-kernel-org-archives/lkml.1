Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYA3GHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYA3GHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYA3GHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:07:36 -0500
Received: from [212.12.190.196] ([212.12.190.196]:38168 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbYA3GHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:07:34 -0500
From: Al Boldi <a1426z@gawab.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Wed, 30 Jan 2008 09:04:48 +0300
User-Agent: KMail/1.5
Cc: Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <200801260828.07459.a1426z@gawab.com> <20080129172232.GA9770@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080129172232.GA9770@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801300904.48299.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> > Chris Snook wrote:
> > > Al Boldi wrote:
> > > > This RFC proposes to introduce a tunable which allows to disable
> > > > fsync and changes ordered into writeback writeout on a per-process
> > > > basis like this:
> > > >
> > > >       echo 1 > /proc/`pidof process`/softsync
> > >
> > > This is basically a kernel workaround for stupid app behavior.
> >
> > Exactly right to some extent, but don't forget the underlying
> > data=ordered starvation problem, which looks like a genuinely deep
> > problem maybe related to blockIO.
>
>   It is a problem with the way how ext3 does fsync (at least that's what
> we ended up with in that konqueror problem)... It has to flush the
> current transaction which means that app doing fsync() has to wait till
> all dirty data of all files on the filesystem are written (if we are in
> ordered mode). And that takes quite some time... There are possibilities
> how to avoid that but especially with freshly created files, it's tough
> and I don't see a way how to do it without some fundamental changes to
> JBD.

Ok, but keep in mind that this starvation occurs even in the absence of 
fsync, as the benchmarks show.

And, a quick test of successive 1sec delayed syncs shows no hangs until about 
1 minute (~180mb) of db-writeout activity, when the sync abruptly hangs for 
minutes on end, and io-wait shows almost 100%.

Now it turns out that 'echo 3 > /proc/.../drop_caches' has no effect, but 
doing it a few more times makes the hangs go away for while, only to come 
back again and again.


Thanks!

--
Al

