Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYK0JTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYK0JTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYK0JSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:18:46 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:53761 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYK0JSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mz6HAmB/FgbEGlcJ7+zWp8XrqhvKNZfNNj+CbBTeNeGVLpKxfDmk40+I8gXi0Krjaq
         oHT6DH6n6Zud46o5yUfV47YQxzmpokU8b+gwsR7pnUrKS6Q3uSYWlQnCbe/wAf1dLwWL
         DPEhyNgxruDV6JM97Xy4PYlGkib8bRIZWg6gk=
Message-ID: <492E65F9.30208@gmail.com>
Date: Thu, 27 Nov 2008 18:18:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Oleg Nesterov <oleg@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] poll: allow f_op->poll to sleep, take#5
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com> <492CEF04.6070100@gmail.com> <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Davide Libenzi wrote:
> Hmmm, I just noticed that the set_current_state(TASK_INTERRUPTIBLE) at the 
> beginning of the ->poll() loop has been dropped (and it makes sense since 
> now ->poll() can sleep).

Yeah, that's exactly what the ->triggered condition replaces.

> w1) WR dev->events
> w2) MB
> w3) WR triggered (1)
> w4) WMB
> w5) WR task->state (RUNNING)
> 
> Poller side:
>  
> s1) WR task->state (TASK_INTERRUPTIBLE)
> s2) MB
> s3) RD triggered
> s4) IF0 => RD task->state (if !RUNNING -> sleep)
> s5) WR triggered (0)
> s6) MB
> s7) RD dev->events
> 
> That is, an MB before w3 (triggered=1) and a set_mb(triggered,0) at 
> s5+s6. The spinlock on the queue taken before entering pollwake() is not 
> enough to guarantee the required ordering, since a LOCK is no guarantee 
> that operations before it are visible after the LOCK.
> Without the MB at w2, it could happen [w3, s5, s7, w1] that will make us 
> miss the event *and* sleep.

Yeah, it seems we'll need something which is equivalent to smp_wmb()
in try_to_wake_up().  So, the original set_mb() should have stayed
there while just adding the latter one.  Will prep yet another take of
the patch.  Thanks for the detailed analysis.

-- 
tejun
