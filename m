Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZA3KRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZA3KRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZA3KRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:00 -0500
Received: from relay.felk.cvut.cz ([147.32.80.7]:57142 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZA3KQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:16:58 -0500
X-Greylist: delayed 2044 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jan 2009 05:16:58 EST
X-FELK-MailScanner-Watermark: 1233913333.12382@EyvDjKn8N8a0UKuvKun3cg
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch 1/2] epoll fix own poll()
Date: Fri, 30 Jan 2009 10:42:05 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com> <200901300329.35641.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901292339480.16141@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0901292339480.16141@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301042.05333.pisa@cmp.felk.cvut.cz>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (relay.felk.cvut.cz [147.32.80.7]); Fri, 30 Jan 2009 10:42:10 +0100 (CET)
X-FELK-MailScanner-Information: 
X-MailScanner-ID: n0U9gAcw068367
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.599, required 5, autolearn=not spam, BAYES_00 -2.60)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-To: akpm@linux-foundation.org, davidel@xmailserver.org,
	linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 08:41:53 Davide Libenzi wrote:
> On Fri, 30 Jan 2009, Pavel Pisa wrote:
> > epoll_wait() unconditionally calls  ep_poll(), the "rdllist" is not empty
> > (cheked by previous ep_eventpoll_poll() call), so ep_send_events()
> > has to be called. It moves all events from "rdllist" onto  "txlist"
> > and reports events confirmed by individual poll() calls to user.
> > There could be non signaling events in the "rdlist" left there from
> > previous scan for level triggering events or in case, that condition
> > is reset by some other intervention before  ep_eventpoll_poll().
> > All this is not problem yet, it would result in one abundant call to
> > epoll_wait() which returns 0. No problem. The EPOLLET events
> > are moved from "rdlist", others (level triggered events) signalling
> > are queued on "rdlist" again. If userspace does its duty, they would
> > be removed during next call. This all seems to suggests, that one
> > abundant epoll_wait() would get things back on the right path.
> > All critical processing (moving between lists) seems to be under
> > held of spinlock, so possibility for bugs is low. I have not yet analyzed
> > overflow list which complicates things.
> >
> > I am not clever enough, to see, where is the problem, that situation
> > is not stabilized. Can you teach me Davide, please?
>
> Sorry, I missed part of the email. Yes, if revents is zero in the
> send-lood, I don't see how files can be added back to the ready-list.
> Please, create a very small test program that exhibit such behaviour ...

Hello Davide,

I have seen the reason exactly when I have sent the e-mail
and switched computer off at the night.

The reason is simple and it is caused by debugging print in each
loop in my application and by way how poll concept is implemented
in the kernel.

There is continuation of my analyze. The event is correctly cleaned
in ep_send_events but there is the culprit in my code, I have not
count before

+ add FD #0 into epoll set to be monitored for read event 
  do {
      select/poll/epoll_wait on epfd
      /* above line returns imediately because epoll->poll() indicates ready event*/
      if there is event on epfd {
         epoll_wait ( epfd, timeout = 0) /* to find which event is ready */
         /* but no ready event is reported and cycle starts again */
      }
+      debugging code prints something to FD #0
  } while(1)

The the concept how file_operations_xxx.poll(struct file *file, poll_table *wait)
 functions works, does not allow to distinguish for which conditions
callers waits. So there is only one list for IN/OUT/HUP etc events.
Even if the device/file/socked has three wait queues (one for these
waiting for IN, other for OUT and third third for IN|OUT),
there is no way to check callers intention so IN|OUT has to be
used unconditionally. Back to my code, when debug write is finished,
wait queue callback for FD #0 is called and this inserts epitem
back on "rdlist" and loop can continue for ever.

So the fault in this case is distributed between 
- my application (it should not perform any activity -
   debugging output - if there is no real noncascade event reported
   and no time expired or event event activated by other thread)
- poll concept with common wait queue which results
  in abundant wakeups and recheck need
- epoll implementation, which is not able to hide abundant wakes
  to not be seen from userspace

I have not fully analyzed updated code version, but I expect,
that it moves full "rdlist" checking into ep_eventpoll_poll().
This hides abundant wakes at price of checking groving
list of really signaled events for each call. It has advantage,
that it could remove entries which really stop to signal events
for other reasons, but rechecking again and again has performance
penalty.

So the ideal solution is to change whole kernel poll mechanism
to allow separate IN and OUT queues for all important poll() function
providers. The other solution is to provide mask of intentionally wait
for events as additional parameter in file_operations_xxx.poll
which would to use optionally three queue concept (IN, OUT, IN|OUT)
for high bandwidth devices and significantly reduce number of
unnecessary wakeups. 
 
As for epoll, you still need overflow list there, so the checking overhead
could be minimized, if all newly reported events are not put onto
"rdlist" directly, but onto some "potentionally_ready_list".
The ep_eventpoll_poll() should only call file.poll() for these epitems.
If the poll() reports ready, they should be moved to the final "rdlist".
If the "rdlist" is not empty, the IN event should be reported back.

Even in the actual poll scenario, the epoll overhead can be decreased
and ill cases can be eliminated.
The ep_poll() should call this processing of "potentionally_ready_list"
before check for "rdlist" before wait decision. In the current scenario,
same busy loop can be created even without cascading if there
is invoked unconditionally some operation on some of epoll set
monitored events which causes wakeup call but is then masked
by epitem events mask.

I have feeling, that I have seen problem report about some application
and epoll, which could be caused by this scenario somewhere.
But I cannot find it again.

So thanks for support and reply,

                    Pavel




