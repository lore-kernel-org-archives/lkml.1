Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXDWUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXDWUCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXDWUCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:02:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34419 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXDWUCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:02:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Date: Mon, 23 Apr 2007 20:49:58 +0200
User-Agent: KMail/1.9.5
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <a781481a0704222109t5c92e4d6t280c21b256945ac8@mail.gmail.com> <20070423141908.GA6842@in.ibm.com>
In-Reply-To: <20070423141908.GA6842@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232050.00020.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 April 2007 16:19, Gautham R Shenoy wrote:
> Hi Satyam, 
> On Mon, Apr 23, 2007 at 09:39:30AM +0530, Satyam Sharma wrote:
> > Hi Rafael,
> > 
> > >+/*
> > >+ *     Per task flags used by the freezer
> > >+ *
> > >+ *     They should not be referred to directly outside of this file.
> > >+ */
> > >+#define TFF_NOFREEZE   0       /* task should not be frozen */
> > >+#define TFF_FREEZE     8       /* task should go to the refrigerator ASAP 
> > >*/
> > >+#define TFF_SKIP       9       /* do not count this task as freezable */
> > >+#define TFF_FROZEN     10      /* task is frozen */
> > 
> > Aren't NOFREEZE and SKIP doing the same thing? One of them appears
> > superfluous. I'm looking at 21-rc6-mm1 and vfork(2) seems to be its
> > only user. Seeing how vfork(2) used it, can't the call to
> > freezer_do_not_count() be replaced with a call to freezer_exempt()?
> > Similarly, the freezer_count() after the wait_for_completion might
> > just as well be a clear of the NOFREEZE bit followed by a
> > try_to_freeze(). Could you please explain the rationale behind the
> > SKIP flag?
> 
> The difference between the NOFREEZE and the SKIP flag is a subtle one.
> 
> When a task (say p) sets it's NOFREEZE flag, it tells the freezer not to
> consider it for freezing. Which means freezeable(p) will return 0.
> So the freezer will not even mark it for freezing. 
> 
> However, when a task sets it SKIP flag, it tells the freezer - "I might
> block at a safe place. So when you are counting the processes which
> have been marked as freezeable, but have not frozen yet, please don't
> count me in. IOW, please skip me."  
> Thus such a task can still be marked for freezing.
> 
> The typical usage is 
> freezer_do_not_count(current);
> /* currents goes to an uninterruptible sleep, like wait_for_completion. */
> freezer_count(current);
> 
> Once the task wakes up from it's uninterruptible sleep, it will 
> call freezer_count which in turn calls try_to_freeze.
> If the task was marked for freezing, it will be frozen now.
> 
> You may want to check the thread http://lkml.org/lkml/2007/2/18/47 
> on how it came into existance.

Very well explained.  Thanks!

Greetings,
Rafael

