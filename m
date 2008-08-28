Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYH1RFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYH1RFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYH1RFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:05:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYH1RFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:05:13 -0400
Message-ID: <48B6DA4F.6090601@redhat.com>
Date: Thu, 28 Aug 2008 13:03:11 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Marlow Weston <miwesto@sandia.gov>
CC: ananth@in.ibm.com, davem@davemloft.net, mhiramata@redhat.com,
       linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com
Subject: Re: HELP!  KProbes bug
References: <48B6D03C.9090906@sandia.gov>
In-Reply-To: <48B6D03C.9090906@sandia.gov>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marlow,

Marlow Weston wrote:
> Hello persons in the current kernel maintainers file under KProbes:
> 
> I can't find this bug reported anywhere nor somewhere useful for 
> reporting it, so I chose that location to find people to write.  If 
> there is somewhere else I should be sending this to, please tell me and 
> I will redirect it there.
> 
> I think I have found a KProbes bug when I turn on the KProbes via a proc 
> file call instead of via the init code.  The stack trace is attached and 
> seems to indicate a locking issue.  Also attached is module code that 
> will make this happen.  Any advice on where to start hunting this down 
> would be greatly appreciated.
> 
> If the KProbes are going by quickly, ie there is no 
> schedule_timeout_interrupt(), then the problem doesn't show up.  This 
> problem is exacerbated by the probes actually doing things that take 
> time while other probes are attempting to register.  Also, I don't 
> believe it has to do with any particular probe as which probe locks up 
> varies (and my mad attempts at commenting out various probes did not work).

Why would you like to call scheduler from probe handler?

By design, kprobe handler MUST NOT call scheduling functions because it
checks recursive call by using per-cpu variable and scheduler might move
probed process to other cpu. Especially, since kretprobe uses a spinlock
(or hashed spinlocks on recently kernel), if the handler calls scheduler,
it will cause deadlock.

Anyway, if you read Documentation/kprobes.txt carefully, you can find
below paragraph;

---
5. Kprobes Features and Limitations
[...]
Probe handlers are run with preemption disabled.  Depending on the
architecture, handlers may also run with interrupts disabled.  In any
case, your handler should not yield the CPU (e.g., by attempting to
acquire a semaphore).
---
(I think this note should prohibit process scheduling more clearly.)

So, it's not a bug of kprobes. It's a known limitation.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

