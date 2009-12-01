Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbZLAKeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbZLAKeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZLAKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:34:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZLAKeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:34:03 -0500
Date: Tue, 1 Dec 2009 11:33:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC] [PATCH 0/2] Futex fault injection
Message-ID: <20091201103351.GA6685@elte.hu>
References: <20091201141642.398e7b7d@sripathi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201141642.398e7b7d@sripathi>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sripathi Kodi <sripathik@in.ibm.com> wrote:

> Hi,
> 
> This patch set adds fault injection for futex subsystem. It adds 
> faults at places where reading/writing from user space can return 
> EFAULT. This will be useful in testing any significant change to futex 
> subsystem.

Instead of this unacceptably ugly and special-purpose debugfs interface, 
please extend perf events to allow event injection. Some other places in 
the kernel (which deal with rare events) want/need this capability too.

A good way to do it would be to define tracepoints in these places via a 
new kind of TRACE_EVENT(), which would also define an event_injected_*() 
callback to use.

So, for example, instead of:

                if (futex_should_fail(&fail_futex_efault, 1))
                        return -EFAULT;

                if (unlikely(!access_ok(rw, uaddr, sizeof(u32)))) {
			trace_get_futex_key_efault(uaddr);
                        return -EFAULT;
		}

We'd have something like:

                if (unlikely(!access_ok(rw, uaddr, sizeof(u32))) ||
				event_injected_get_futex_key_efault()) {

			trace_get_futex_key_efault(uaddr);
                        return -EFAULT;
		}

And each separate event injection point could thus be triggered 
individually.

To use this there would be a separate facility to inject events - via 
the perf events ioctl for example.

	Ingo
