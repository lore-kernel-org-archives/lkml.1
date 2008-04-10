Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYDJP5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYDJP5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYDJP44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:56:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:55490 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752198AbYDJP4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:56:55 -0400
Date: Thu, 10 Apr 2008 17:56:53 +0200
From: Jan Kara <jack@suse.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410155653.GF20656@duck.suse.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz> <20080410151945.GE6725@atrey.karlin.mff.cuni.cz> <200804101737.16825.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804101737.16825.mhocko@suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-04-08 17:37:16, Michal Hocko wrote:
> On Thursday 10 April 2008 05:19:45 pm Jan Kara wrote:
> > > On Thu, 10 Apr 2008, Jan Kara wrote:
> > > > > The f_pos races are in fact exploitable, we've already been there.
> > > > > See for example
> > > > > http://www.isec.pl/vulnerabilities/isec-0016-procleaks.txt
> > > >
> > > >   Well, this race is more subtle - the window is just one instruction
> > > > wide (stores to f_pos from CPU2 must come between the store of lower
> > > > and upper 32-bits of f_pos on CPU1). And the only result is that f_pos
> > > > has 32-bits from one file pointer and 32-bits from the other one. So I
> > > > can hardly imagine this would be exploitable...
> > >
> > > Supposing you are not holding any spinlock and are running with
> > > preemptible kernel (pretty common scenario nowadays), there is nothing
> > > that would prevent kernel from rescheduling between the two instructions,
> > > enlarging the race window to be more comfortable for attacker, right?
> >
> >   Yes, this is theoretically possible.
> >
> > > I think this is worth fixing.
> >
> >   Hmm, maybe it is, although I still don't see how to exploit it :).
> 
> Maybe (just guess) some high priority malicious process could try to preempt 
> reading thread to always in the bad moment (when the half of the f_pos is 
> written) and thus forcing it to read bad data (you usually don't check that 
> file position is growing after each read and you wait only for end of the 
> file). 
> But do agree, I still don't see something with really security implications 
> (privileged processes usually don't work with such a big files).
  Well, but for this to work the process you try to attack must access the
file from several threads in parallel without any locking... And I'm not
aware of anybody really doing this.
  Really the only attack vector I could imagine is that you create several
malitious processes which will try to corrupt f_pos and then use it (like
if you could make it negative, I could imagine this could trigger some bug
somewhere). But since possible corruptions are quite limited, I don't see
how to corrupt f_pos to something at least remotely "useful".

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
