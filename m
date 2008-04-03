Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbYDCT5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbYDCT5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760404AbYDCT5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:57:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbYDCT5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:57:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: Regression in gdm-2.18 since 2.6.24
Date: Thu, 3 Apr 2008 21:56:53 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
References: <20080403191916.GA30864@deepthought>
In-Reply-To: <20080403191916.GA30864@deepthought>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804032156.54021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of April 2008, Ken Moffat wrote:
>  Third attempt, with luck this time I've managed to find what really
> broke it.  Sorry, this is going to be a long mail to explain my
> current attribution of 'blame'.
> 
>  Summary: kernels newer than 2.6.24 break gdm's shutdown (and
> restart) for me.
> 
> Action to replicate:
> choose 'shutdown' or 'restart' from gdm, and confirm
> 
> Expected behaviour: X disappears and I'm back at a tty window
> watching my bootscripts change to runlevel 0 or 6.
> 
> Actual behaviour: many times (with 2.6.24.X 'mostly', with 2.6.25-rc
> 'often') the gdm window disappears but the background remains and
> the box stays in runlevel 5.
> 
>  This only happens when this box is running a 'pure64' x86_64
> system, when it runs with a rather different 32-bit config it is
> fine.  The system is now somewhat old (gcc-4.1.2, binutils-2.17,
> glibc-2.5), and the parts of gnome that I use are 2.20 except for
> gdm which is 2.18 (because I want to see the shutdown messages, in
> case things fail.)
> 
>  I first saw this on 2.6.24.2, but by that time I was mostly using
> x86 or other arches (I was behind on list mail, and missed the
> security fix in 2.6.24.1 among the other changes there).   The problem
> seemed consistent on the few occasions I used this system with
> 2.6.24.2.  I still had a large amount of debugging info from gdm,
> and (from an earlier posting where I mistook the cause of this
> problem) I had the following:
> 
> Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
> 'GET_CONFIG greeter/SetPosition :0'
> Mar 24 13:49:29 bluesbreaker gdmlogin[2995]:   Got response: 'OK
> false'
> Mar 24 13:49:29 bluesbreaker gdmlogin[2995]: Sending command:
> 'CLOSE'
> Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
> 'CLOSE'
> Mar 24 13:49:29 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> loop
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
> end verify for ''
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
> login/Bad login
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
> loop
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
> end verify for ''
> Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
> login/Bad login
> ... about 165 repeats of these 3 lines ...
>  messages seemed to stop of their own accord until I shut down
>  from a tty
> 
>  On my first attempt to find the cause, I was under the impression
> that it happened every time (in 2.6.24.2 and 2.6.24.4). Speculatively
> reverting some of the patches, plus an error where I forgot to set
> an extraversion, overwrote the modules, and later had a successful
> shutdown from 2.6.24.4 led me to erroneously point the finger at
> either the drm patches or i2c-viapro.  In fact, the problem doesn't
> appear every time, and I needed to do 10 attempts (a mix of 5
> shutdowns and 5 restarts) before saying that a kernel seemed to be
> ok.
> 
>  In my second attempt, I tried to bisect (v2.6.24 good, v2.6.25-rc1
> bad) and ended up in 2.6.24-rc4.  I haven't had any replies to my
> post yesterday about that, so I conclude that 'git bisect' is
> another "flexible and powerful tool" which will bite non-experts like
> me.
> 
>  For my third attempt (yesterday evening, and today) I established
> that 2.6.24 shuts down perfectly on this system, but anything
> newer is "variable".  Hence, the mix of 5 restarts and 5 shutdowns
> before believing a particular kernel is ok.
> 
>  I used 2.6.24.x for this third attempt.  After confirming that
> 2.6.24 was rock solid for this, I tried some of the patches applied
> in 2.6.24.{1,2}.  This was a lttle tricky, because security fixes
> meant the normal stable "we'll apply these patches unless somebody
> objects" considerations didn't apply and I didn't get to see which
> individual changes were being applied to stable.
> 
>  For the first pass, I cherry-picked the stable fixes for
> fs/eventpoll.c, fs/splice.c, kernel/sched_fair.c, and then
> include/linx/wait.h to make eventpoll compile.  That kernel
> restarted once, then failed (I'm no longer certain if the second
> attempt was a restart or a shutdown).  At that point, I had
> confirmed that even in 2.6.24-stable the failure didn't happen all
> the time, so I reverted to extended testing.
> 
>  First up was the pair of changes to fs/splice.c.  They were fine.
> Then I added eventpoll.c and wait.h and ran a few tests - seemed fine.
> After that I added the change to sched_fair and things became
> interesting - all the restarts were ok, all the shutdowns failed.
> 
>  At that point I tried 2.6.24.4 and reverted what should be the first
> attachment for sched_fair.  That passed all my tests for restart and
> shutdown.
> 
>  Next I went forward to 2.6.25-rc8.  Here, I found that 'patch'
> would not revert the first hunk of that attachment because of a
> context change.  So, I tried reverting only the second hunk (I didn't
> know why it had been changed, so maybe they were to fix different
> problems) - interestingly, that passed all 5 attempts to restart,
> and failed all 5 attempts to shutdown.  I then tried the second
> attachment (which reverts both hunks from rc8) and all of my tests
> passed.  Probably, there is some option for patch to ignore context,
> and I have no idea what problem(s) the original change was supposed
> to fix.  For me, reverting the original would be wonderful but if
> that will cause problems for others then I'm willing to test any
> suggested changes.
> 
>  My .config for 2.6.25 is the third attachment.  Clearly, I'd like
> this to be fixed in both 25 and stable.  Thanks for reading this far.

The attachments are missing.

Can you please just provide us with the name of the git commit that you think
breaks things for you?

Also, is there CONFIG_FAIR_GROUP_SCHED set in your .config?

Thanks,
Rafael
