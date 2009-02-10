Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZBJJrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZBJJrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZBJJrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:47:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:2119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZBJJrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:47:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,185,1233561600"; 
   d="scan'208";a="429709948"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@googlemail.com>
Date: Tue, 10 Feb 2009 09:47:15 +0000
Subject: RE: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Thread-Topic: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Thread-Index: AcmK7iF/yaGv2bkmS9CJiD+3l+kmOQAaG6Ag
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A1E82FE@irsmsx504.ger.corp.intel.com>
References: <20090209010233.GA26444@redhat.com>
 <20090209012824.GA26461@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com>
 <20090209193625.GA4808@redhat.com>
In-Reply-To: <20090209193625.GA4808@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Monday, February 09, 2009 8:36 PM
>To: Metzger, Markus T

>> When the tracer dies, do_exit() first calls exit_mm() and then calls exit_notify(), which eventually
>calls __ptrace_unlink() and ptrace_bts_untrace().
>>
>> At this time, the tracer's mm is already gone,
>
>It is not if we have sub-threads (which share the same ->mm),

 [....]

>> >Oh, and afaics ptrace_detach()->ptrace_bts_detach() can race with the
>> >tracer's sub-thread which does do_wait()->release_task() (if the tracee
>> >was killed before detach takes tasklist), the kernel can crash in this
>> >case.
>>
>> Are you saying that ptrace_detach() should call ptrace_disable() with tasklist_lock held for write?
>
>We can't do this. And btw one of the reasons we can't is that
>ptrace_bts_free_buffer() needs ->mmap_sem ;)


Thanks for your explanations.

If I understand this correctly, we have two problems left:
1. if the tracer thread dies without detaching, the process will not get the (locked) memory refunded.
2. there is a race between a thread detaching and another thread releasing the same task.


I do not really understand the second problem.

As far as I know, there can only be one ptracer per task. This ptracer can either detach or release,
but not both. That other thread that does do_wait() should not be able to see the tracee as long as
it is ptraced (wait_consider_task() will ignore it). Since ptrace_disable() is called before
__ptrace_unlink(), we free the BTS buffer before do_wait() will consider the tracee.
I do not see the race. Am I missing something?


Regarding the first problem, the userland impact would be that multi-threaded debuggers whose ptrace
controlling threads die without detaching will (more or less slowly) run out of memory and not be able
to collect branch trace after some time. Such debuggers will have lost control of the debuggee and
need to reattach/restart the debuggee process. Users would have to restart those debuggers to be able
to collect branch trace again.

Even though mm is shared, the pointer to it has already been set to NULL before arch_ptrace_untrace()
is called; we can't access it in ptrace_bts_untrace().
Utrace picked a better place; tracehook_report_exit() is called very early in do_exit() with everything
still in place.

We could try to mimic that and add a ptrace_notify_exit() function that is called early in do_exit().
As long as I only put the ptrace_bts_detach() into the arch version of it, the changes should be
relatively safe.
We might even be able to call ptrace_detach() from that function, although I would not dare to make
those changes myself.
This would leave us with two exit notifications to ptrace, though, which does not make the code any
cleaner or simpler.

What do you and Roland think about it? Do you have a better idea?


Thanks again for pointing out those problems. I would appreciate, if you reviewed future patches
in that area.

thanks and regards,
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

