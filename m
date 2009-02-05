Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZBEXZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZBEXZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZBEXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:24:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53926 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZBEXYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:24:51 -0500
Date: Fri, 6 Feb 2009 00:22:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Kaz Kylheku <kkylheku@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090205232223.GB10345@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com> <20090201174159.4a52e15c.akpm@linux-foundation.org> <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com> <20090202165606.GA13346@redhat.com> <20090205030553.49650FC381@magilla.sf.frob.com> <3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com> <20090205161544.GA24799@redhat.com> <20090205212234.934D1FC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205212234.934D1FC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Roland McGrath wrote:
>
> I wrote this test case for it.  Is there any problem other than this one?

I don't know about other problems with the zombie leaders.

Except, I am worried whether the fix I have in mind is correct ;)
It is simple, wait_task_stopped() should do

	if we tracer:

		check ->state, eat ->exit_code

	else:
		check SIGNAL_STOP_STOPPED, use ->group_exit_code

This looks logical, and should fix the problem. But this is
the user-visible change. For example,

	$ sleep 100
	^Z
	[1]+  Stopped                 sleep 100
	$ strace -p `pidof sleep`
	Process 11442 attached - interrupt to quit

strace hangs in do_wait(). But after the fix strace will happily
proceed. I can't know whether this behaviour change is bad or not.

Oleg.

