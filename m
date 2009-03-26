Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZCZOs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZCZOs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbZCZOsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:48:13 -0400
Received: from THUNK.ORG ([69.25.196.29]:36722 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758801AbZCZOsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:48:12 -0400
Date: Thu, 26 Mar 2009 10:47:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326144707.GA6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
References: <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326140312.GB14822@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 03:03:12PM +0100, Ingo Molnar wrote:
> That's in good deal atime update latencies. We still appear to 
> default to atime enabled in ext4.
> 
> That's stupid - only around 0.01% of all Linux systems relies on 
> atime - and even those who rely on it would be well served by 
> relatime. Why arent the relatime patches upstream? Why isnt it the 
> default? They have been submitted several times.

The relatime patches are upstream.  Both noatime and relatime are
handled at the VFS layer, not at the per-filesystem level.  The reason
why it sin't the default is because of a desire for POSIX compliance,
I suspect.  Most distributions are putting relatime into /etc/fstab by
default, but we haven't changed the mount option.  It wouldn't be hard
to add an "atime" option to turn on atime updates, and make either
"noatime" or "relatime" the default.  This is a simple patch to
fs/namespace.c

> Atime in its current mandatory do-a-write-for-every-read form is a 
> stupid relic and we have been paying the fool's tax for it in the 
> past 10 years.

No argument here.  I use noatime, myself.  It actually saves a lot
more than relatime, and unless you are using mutt with local Maildir
delivery, relatime isn't really that helpful, and the benefit of
noatime is roughly double that of relatime vs normal atime update, in
my measurements:

http://thunk.org/tytso/blog/2009/03/01/ssds-journaling-and-noatimerelatime/

						- Ted
