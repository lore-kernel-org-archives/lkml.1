Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYDALzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYDALzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYDALzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:55:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43380 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753462AbYDALzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:55:36 -0400
Date: Tue, 1 Apr 2008 06:55:34 -0500
From: Paul Jackson <pj@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
Message-Id: <20080401065534.a6267b96.pj@sgi.com>
In-Reply-To: <47F21BE3.5030705@jp.fujitsu.com>
References: <47F21BE3.5030705@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting ...

So, we have two flags here.  One flag "sched_wake_idle_far" that will
cause the current task to search farther for an idle CPU when it wakes
up another task that needs a CPU on which to run, and the other flag
"sched_balance_newidle_far" that will cause a soon-to-idle CPU to search
farther for a task it might pull over and run, instead of going idle.

I am tempted to ask if we should not elaborate this in one dimension,
and simplify it in another dimension.

First the simplification side: do we need both flags?  Yes, they are
two distinct cases in the code, but perhaps practical uses will always
end up setting both flags the same way.  If that's the case, then we
are just burdening the user of these flags with understanding a detail
that didn't matter to them: did a waking task or an idle CPU provoke
the search?  Do you have or know of a situation where you actually
desire to enable one flag while disabling the other?

For the elaboration side: your proposal has just two-level's of
distance, near and far.  Perhaps, as architectures become more
elaborate and hierarchies deeper, we would want N-level's of distance,
and the ability to request such load balancing for all levels "n"
for our choice of "n" <= N.

If we did both the above, then we might have a single per-cpuset file
that took an integer value ... this "n".  If (n == 0), that might mean
no such balancing at all.  If (n == 1), that might mean just the
nearest balancing, for example, to the hyperthread within the same core,
on some current Intel architectures.  If (n == 2), then that might mean,
on the same architectures, that balancing could occur across cores
within the same package.  If (n == 3) then that might mean, again on
that architecture, that balancing could occur across packages on the
same node board.  As architectures evolve over time, the exact details
of what each value of "n" mean would evolve, but always higher "n"
would enable balancing across a wider portion of the system.

Please understand I am just brain storming here.  I don't know that
the alternatives I considered above are preferrable or not to what
your patch presents.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
