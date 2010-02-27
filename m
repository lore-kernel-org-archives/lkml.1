Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780Ab0B0ULn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 15:11:43 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:47556 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030764Ab0B0ULm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 15:11:42 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANYLiUurR7H+/2dsb2JhbACbHHOhE5gahHsEgxc
X-IronPort-AV: E=Sophos;i="4.49,551,1262563200"; 
   d="scan'208";a="157967628"
From: Roland Dreier <rdreier@cisco.com>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: schedule (wait_event) vs. while
References: <b170af451002270152u228a46abr3b316da75b2fa3f0@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 27 Feb 2010 12:11:37 -0800
In-Reply-To: <b170af451002270152u228a46abr3b316da75b2fa3f0@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Sat, 27 Feb 2010
 10:52:09 +0100")
Message-ID: <ada8waev3pi.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > In radeon engine reclocking code I need to do some calculations and
 > then wait for VBLANK interrupt. Right after VBLANK interrupt will
 > happen I need to reclock ASAP.
 > 
 > Interrupts are received by another context and I need some quite fast
 > synchronization.
 > 
 > 1) Schedule solution:
 > reclocking() {
 >   calculations();
 >   radeon->vblank_sync = 0;
 >   wait_event_timeout(radeon->wq, radeon->vblank_sync, timeout);
 >   reclock();
 > }
 > i-handler() { radeon->vblank_sync = 1; }

What does reclock() involve?  Is there any reason you can't do it in the
interrupt handler?  (quite possibly it needs to sleep or something)

If you can do it in the interrupt handler, then your reclocking()
function could do the calculations, stash the result somewhere, and set
a flag that tells the interrupt handler to do the reclock().  Then you
could use a completion to have reclocking() wait until the reclock() was
actually done (the latency of that completion doesn't matter, since
you're not doing any actual work after the completion).

If you do need to wait for process context, then one possibility would
be to do reclocking() from a high-priority kernel thread.  Then the wake
up latency should be low (but maybe not low enough).  Or you could
convert the interrupt handler to use the new threaded interrupt support,
to get into a process context as fast as possible.

If you reall need to busy-wait, then

 > reclocking() {
 >   calculations();
 >   del_timer(radeon->fake_vblank);
 >   radeon->vblank_sync = 0;
 >   mod_timer(radeon->fake_vblank, 10ms);
 >   while(!radeon->vblank_sync);
 >   reclock();
 > }
 > i-handler() { radeon->vblank_sync = 1; }
 > fake-handler() { radeon->vblank_sync = 1; }

There's no need for the fake_vblank timer -- just keep track of the time
when you start busy-waiting and then exit the loop when 10ms passes.

 - R.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
