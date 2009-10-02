Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZJBWeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZJBWeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZJBWep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:34:45 -0400
Received: from thunk.org ([69.25.196.29]:33182 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZJBWep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:34:45 -0400
Date: Fri, 2 Oct 2009 18:34:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge
	commit
Message-ID: <20091002223412.GA8517@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	John Stultz <johnstul@us.ibm.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ondrej Zary <linux@rainbow-software.org>,
	Magnus Damm <magnus.damm@gmail.com>
References: <E1MrRDa-0002WF-LO@closure.thunk.org> <200909271813.42829.rjw@sisk.pl> <20090928135109.GB17514@mit.edu> <200909282322.57824.rjw@sisk.pl> <20091002005907.GA7490@mit.edu> <alpine.LFD.2.01.0910011817120.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910011817120.6996@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 06:21:50PM -0700, Linus Torvalds wrote:
> I think the revert is the right thing to do, especially as that 
> 'clocksource_mutex' looks totally bogus. Either the thing is protected by 
> 'stop_machine' or it's not. In neither case does it seem to make any sense 
> to replace a spinlock with a mutex. 
> 
> And resuming anything with a big mutex is crazy anyway. 
> 
> That said, I do wonder if this is already fixed. See commit 
> 89133f93508137231251543d1732da638e6022e1:
> 
>     clocksource: Resume clocksource without taking the clocksource mutex
> 
> which already undid the part that probably mattered for you. That said, I 
> still do think that that mutex is dubious, so maybe we should undo it all.

Hmm, I just tried the latest git release, and the problem does seem to
have disappeared.  I don't know if it was fixed by commit #89133f9,
but I'll take it.  :-)

(Note!  The problem I was bisecting is different and distinct from BZ
#14222.  First of all, for me 2.6.31 works fine, and in #14222 the
reporter claimed that 2.6.30 worked, and 2.6.31 didn't.  For me this
regression happened *after* the merge window opened.  Secondly, in
#14222 the failure reported was an OOPS, whereas in my case, the
system simply doesn't come back after the second suspend-to-memory.
The HD disk flashes once or twice, but then the machine stays dead,
with the screen not coming to life and the suspend light still lit.
Finally, I bisected the failure to a different commit (75c5158) which
is post 2.6.31, where as commit c7121843 which is pre-2.6.31.)

   		      	 		       - Ted

