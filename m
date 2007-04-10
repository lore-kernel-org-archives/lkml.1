Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXDJB7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXDJB7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXDJB7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:59:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbXDJB7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:59:31 -0400
Date: Mon, 9 Apr 2007 21:59:12 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410015912.GE1994@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>, Robin Holt <holt@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jack Steiner <steiner@americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409172339.48d661d6.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 05:23:39PM -0700, Andrew Morton wrote:

 > I suspect there are quite a few kernel threads which don't really need to
 > be threads at all: the code would quite happily work if it was changed to
 > use keventd, via schedule_work() and friends.  But kernel threads are
 > somewhat easier to code for.

Perhaps too easy.  We have a bunch of kthreads sitting around that afaict,
are there 'just in case', not because they're actually in use.

   10 ?        S<     0:00 [khelper]

Why doesn't this get spawned when it needs to?

  164 ?        S<     0:00 [cqueue/0]
  165 ?        S<     0:00 [cqueue/1]

I'm not even sure wth these are.

  166 ?        S<     0:00 [ksuspend_usbd]

Just in case I decide to suspend ? Sounds.. handy.
But why not spawn this just after we start a suspend?

  209 ?        S<     0:00 [aio/0]
  210 ?        S<     0:00 [aio/1]

I'm sure I'd appreciate these a lot more if I had any AIO using apps.

  364 ?        S<     0:00 [kpsmoused]

I never did figure out why this was a thread.

  417 ?        S<     0:00 [scsi_eh_1]
  418 ?        S<     0:00 [scsi_eh_2]
  419 ?        S<     5:28 [scsi_eh_3]
  426 ?        S<     0:00 [scsi_eh_4]
  427 ?        S<     0:00 [scsi_eh_5]
  428 ?        S<     0:00 [scsi_eh_6]
  429 ?        S<     0:00 [scsi_eh_7]

Just in case my 7-1 in card reader gets an error.
(Which is unlikely on at least 6 of the slots as evidenced by the runtime column.
 -- Though now I'm curious as to why the error handler was running so much given
    I've not experienced any errors.).
This must be a fun one of on huge diskfarms.

  884 ?        S<     0:00 [kgameportd]

Just in case I ever decide to plug something into my soundcard.

 2179 ?        S<     0:00 [kmpathd/0]
 2180 ?        S<     0:00 [kmpathd/1]
 2189 ?        S<     0:00 [kmirrord]

Just loading the modules starts up the threads, regardless
of whether you use them. (Not sure why they're getting loaded,
something for me to look into)

 3246 ?        S<     0:00 [krfcommd]

I don't even *have* bluetooth hardware.
(Yes, the module shouldn't have loaded, but that's another battle..)

 > otoh, a lot of these inefficeincies are probably down in scruffy drivers
 > rather than in core or top-level code.

You say scruffy, but most of the proliferation of kthreads comes
from code written in the last few years.  Compare the explosion of kthreads
we see coming from 2.4 to 2.6. It's disturbing, and I don't see it
slowing down at all.

On the 2-way box I grabbed the above ps output from, I end up with 69 kthreads.
It doesn't surprise me at all that bigger iron is starting to see issues.

	Dave

-- 
http://www.codemonkey.org.uk
