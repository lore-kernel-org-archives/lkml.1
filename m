Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYFEPtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYFEPtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYFEPtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:49:02 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53523 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYFEPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:49:01 -0400
Date: Thu, 5 Jun 2008 09:48:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: TASK_WAKEKILL && /sbin/init (was: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race)
Message-ID: <20080605154844.GN3549@parisc-linux.org>
References: <20080604170905.GA10273@tv-sign.ru> <20080604173318.GH3549@parisc-linux.org> <20080605152316.GA257@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605152316.GA257@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 07:23:16PM +0400, Oleg Nesterov wrote:
> Sorry Matthew, I left this part unanswered because I didn't have the
> time yesterday...

That's OK, thanks for picking it up again.

> On 06/04, Matthew Wilcox wrote:
> >
> > On Wed, Jun 04, 2008 at 09:09:05PM +0400, Oleg Nesterov wrote:
> > > Note also that with or without this patch TASK_WAKEKILL is not exactly right
> > > wrt /sbin/init, but this is another issue.
> >
> > That's certainly an interesting conversation to have.
> 
> If lock_page_killable() fails because the task was killed by SIGKILL or
> another fatal signal, do_generic_file_read() returns -EIO.
> 
> This seems to be OK, because in fact the userspace won't see this error, the
> task will dequeue SIGKILL and exit.
> 
> However, /sbin/init is different, it will dequeue SIGKILL, ignore it, and be
> confused by this bogus -EIO. Please note that while this bug is not likely,
> it is _not_ theoretical. It does happen that user-space sends the unhandled
> fatal signals to init.

Have you actually tested this?  I thought it was handled by:

                /*
                 * Global init gets no signals it doesn't want.
                 */
                if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
                    !signal_group_exit(signal))
                        continue;

in get_signal_to_deliver().

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
