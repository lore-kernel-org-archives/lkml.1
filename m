Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYKZGjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYKZGjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYKZGiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:38:51 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:29212 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKZGiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:38:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wgL9NVCGcF+DfU4ZIZaRcRbpleraycuBFH+jyMsmrOC/pdMaBpv5X7VN111lq0UxgE
         KXmvu1xmK3X6r0JmKv2jB96NqI3EF830/OrSSiWMMjHH6jUvgmpJqVJI9WOjJcSVys4/
         /WOiKp8+CYCQttMLsDjZDps1B0qnPddpfsjrI=
Message-ID: <492CEF04.6070100@gmail.com>
Date: Wed, 26 Nov 2008 15:39:00 +0900
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
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Davide Libenzi wrote:
> Look, pollwake() does:
> 
> w1) WR triggered (1)
> w2) WMB
> w3) WR task->state (RUNNING)
> 
> While poll_schedule_timeout() does:
> 
> s1) WR task->state (TASK_INTERRUPTIBLE)
> s2) MB
> s3) RD triggered
> s4) IF0 => RD task->state (if !RUNNING -> sleep)
s5) after waking up, WR triggered to zero

> The only risk is that w3 preceed s1, so that we go to sleep even though a 
> wakeup has been issued. But if w3 is visible, w1 is visible too, that 
> means that 'triggered' is visible in s3 (there's a MB in s2). So we skip 
> the schedule_hrtimeout_range(). So IMO you need no barriers on 'triggered'.
> If you feel you need barriers, do you mind explaning a sequence of events 
> that makes a barrier-free version break?

s5 from the previous iteration could happen after w1 during the next
iteration and the test in s4 of the next iteration will miss the
event, so the event could get lost on the iterations which is not the
first one, no?

Thanks.

-- 
tejun
