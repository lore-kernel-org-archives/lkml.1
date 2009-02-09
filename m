Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZBIJ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZBIJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZBIJ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:29:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:58540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZBIJ3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:29:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,404,1231142400"; 
   d="scan'208";a="488423301"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 9 Feb 2009 09:28:34 +0000
Subject: RE: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Thread-Topic: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Thread-Index: AcmKVhLJ2pry8DqWQMuENQK18GDtIwAOFmJA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com>
References: <20090209010233.GA26444@redhat.com>
 <20090209012824.GA26461@redhat.com>
In-Reply-To: <20090209012824.GA26461@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Monday, February 09, 2009 2:28 AM
>To: Andrew Morton; Ingo Molnar; Metzger, Markus T; Roland McGrath
>Cc: linux-kernel@vger.kernel.org


>> I noticed by pure accident we have ptrace_fork() and friends. This was
>> added by "x86, bts: add fork and exit handling", commit
>> bf53de907dfdaac178c92d774aae7370d7b97d20
>
>Hmm. Looks like we have more problems here...

Thanks for pointing out these problems. I did not get too many reviews when I sent out the patch.


>PTRACE_BTS_CONFIG allocates ->bts_buffer via alloc_locked_buffer()
>which updates mm->total_vm/locked_vm.
>
>ptrace_detach() does free_locked_buffer() which "restores" mm->xxx_vm.

That's what I expect to be the normal case.


>But if the tracer exits we are doing __ptrace_unlink()->ptrace_bts_untrace()
>which uses a plain kfree(), in that case we don't update mm->xxx_vm ?

That's correct.
When the tracer dies, do_exit() first calls exit_mm() and then calls exit_notify(), which eventually calls __ptrace_unlink() and ptrace_bts_untrace().

At this time, the tracer's mm is already gone, but the bts buffer is not.
The code reclaims the memory; so we should not leak memory.
The user should not see any problems with his ulimit, either, since the task that had the memory accounted against his locked and total limit is as good as dead.

Where exactly do you see the problem?


>Note that the exiting tracer can have sub-threads, so the whole process
>does not necessary dies.

In that case, the process would lose the child's branch trace. Doesn't the process lose control over the ptraced task, anyway, when we call __ptrace_unlink()?

The task that paid for the buffer, though, is dead, and the memory has been reclaimed by the kernel.


>Or, the tracer can reap a zombie tracee without PTRACE_DETACH, in that
>case we don't update ->mm too.

I'm not sure I understand that scenario.
A task ptraces another task, requests branch trace, and does not detach when the tracee dies?

In that case, the tracer would continue to pay for the buffer (which had been freed in __ptrace_unlink()) until it dies.
If the tracer task still lives, shouldn't we enforce a proper detach?


The problem I was trying to solve is that a dying ptracer does not detach properly. It seems that there are more ways to bypass ptrace detach.

Ideally (that is, from my point of view, at least), the tracer would call ptrace_detach() very early in do_exit(), so ptrace would not have to distinguish the various ways a tracer or tracee could die. That view might be a bit naïve, I admit.


>Oh, and afaics ptrace_detach()->ptrace_bts_detach() can race with the
>tracer's sub-thread which does do_wait()->release_task() (if the tracee
>was killed before detach takes tasklist), the kernel can crash in this
>case.

Are you saying that ptrace_detach() should call ptrace_disable() with tasklist_lock held for write?
There's a comment in ptrace_detach() before it does write_lock_irw(&tasklist_lock) and calls __ptrace_detach().


>Unless I missed something, This all looks rather wrong, and I wasn't
>aware about these changes :(

I wished I would have got this review when I sent out the patch.


regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

