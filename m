Return-Path: <linux-kernel-owner+w=401wt.eu-S1766000AbXF2Nhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766000AbXF2Nhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765197AbXF2Nhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:37:38 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:40419 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1765360AbXF2Nhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:37:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=OBGKmumcPN/QfnQdBgnbmjMUqddqtAaKXocpA5HL3Ih0JQmYA/UuMqUv4RenFO2L+Pvv8uQUeJiolvbRWeI1IsK6dRPbSIt8UvxPA9q4+kL1Nv/9dPGW4PNh+484JVovcNqPdH28IsjHZMUUfkBs22zZr8VGEK7PzgIM6SQoF28=;
Date: Fri, 29 Jun 2007 17:36:58 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629133658.GB19021@ms2.inr.ac.ru>
References: <20070622040014.234651401@goodmis.org> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <200706291348.21193.duncan.sands@math.u-psud.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706291348.21193.duncan.sands@math.u-psud.fr>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> I felt that three calls to tasklet_disable were better than a gazillion calls to
> spin_(un)lock.

It is not better.

Actually, it also has something equivalent to spinlock inside.
It raises some flag and waits for completion of already running
tasklets (cf. spin_lock_bh). And if tasklet_schedule happens while
it is disabled, it tries to take that lock gazillion
of times until the tasklet is reenabled back.

Old days that was acceptable, you had not gazillion of attempts
but just a few, but since some time (also old already) it became
disasterous.

It is really better just to avoid calling tasklet_schedule(),
when you do not want it to be executed. :-)

Alexey
