Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbXGQFBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbXGQFBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXGQFBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:01:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52892 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbXGQFBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:01:21 -0400
X-Sasl-enc: Aaip6O26jofDuZX69SirS4QgYMrw72hw26IBOhVJlRZi 1184648480
Subject: Re: [patch] CFS scheduler, -v19
From: Ian Kent <raven@themaw.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070716215541.GA27171@elte.hu>
References: <20070706173319.GA2356@elte.hu>
	 <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com>
	 <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com>
	 <469BE462.9030004@redhat.com>  <20070716215541.GA27171@elte.hu>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 13:01:14 +0800
Message-Id: <1184648474.3188.33.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 23:55 +0200, Ingo Molnar wrote:
> * Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > On 07/13/2007 05:19 PM, Bill Davidsen wrote:
> > > 
> > > I should really go back to 2.6.21.6, 2.6.22 has many bizarre behaviors
> > > with FC6. Automount starts taking 30% of CPU (unused at the moment)
> > 
> > Can you confirm whether CFS is involved, i.e. does it spin like that 
> > even without the CFS patch applied?
> 
> hmmm .... could you take out the kernel/time.c (sys_time()) changes from 
> the CFS patch, does that solve the automount issue? If yes, could 
> someone take a look at automount and check whether it makes use of 
> time(2) and whether it combines it with finer grained time sources?

Yes it does and I have two reported bugs so far.

In several places I have code similar to:

wait.tv_sec = time(NULL) + 1;
wait.tv_nsec = 0;

signaled = 0;
while (!signaled) {
        status = pthread_cond_timedwait(&cond, &mutex, &wait);
       if (status) {
             if (status == ETIMEDOUT)
                  break;
             fatal(status);
      }
}

lead to automount spinning with strace output a bit like:

futex(0x80034b60, FUTEX_WAKE, 1)  = 0
clock_gettime(CLOCK_REALTIME, {1184593936, 130925919}) = 0
time(NULL)                        = 1184593935
futex(0x80034b60, FUTEX_WAKE, 1)  = 0
clock_gettime(CLOCK_REALTIME, {1184593936, 131160876}) = 0
time(NULL)                        = 1184593935
futex(0x80034b60, FUTEX_WAKE, 1)  = 0
clock_gettime(CLOCK_REALTIME, {1184593936, 131377080}) = 0
time(NULL)                        = 1184593935
futex(0x80034b60, FUTEX_WAKE, 1)  = 0
clock_gettime(CLOCK_REALTIME, {1184593936, 131593297}) = 0
time(NULL)                        = 1184593935
futex(0x80034b60, FUTEX_WAKE, 1)  = 0
clock_gettime(CLOCK_REALTIME, {1184593936, 131871792}) = 0

There should be something like:

futex(0x5555557868c4, FUTEX_WAIT, 5321099, {0, 998091311}) = -1 ETIMEDOUT (Connection timed out)

in there I think.

Ian


