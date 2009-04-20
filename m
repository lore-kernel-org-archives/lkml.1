Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZDTKjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZDTKjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZDTKi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:38:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbZDTKiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:38:55 -0400
Date: Mon, 20 Apr 2009 12:38:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jonathan Corbet <corbet@lwn.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090420103805.GA29891@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <200904161130.28129.rusty@rustcorp.com.au> <20090416075541.527b8f85@bike.lwn.net> <200904201744.22572.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904201744.22572.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Here are my thoughts:
> 
> - Actual demonstrated fixes for demonstrated bugs should aim for subject
>   "<subsystem>: fix <symptom> <condition>...", eg: "modules: fix crash when out
>   of memory" or "modules: fix compile error on arm" or "modules: fix module
>   load when CONFIG_FOO=y, CONFIG_BAR=n, moon=full".

i dont disagree - and this really has been recommended for years and 
is 'obvious' to do - i just dont see it being consistently practiced 
by _anyone_ upstream.

And (at the risk of over-simplifying a good dozen mails) i pointed 
out why it's not being practiced consistently by anyone: without 
easy visual (and/or tooled) reminders that something is structured 
incorrectly, humans tend to slack off. They tend to slack off 
_especially_ when it comes to describing a discomforting aspect of 
an otherwise cool commit: the practical benefit of the patch (which 
might be discomfortingly insignificant) and the risks it carries 
(which might be discomfortingly significant).

This "impact on the kernel" also happens to be an essential (and 
hard to obtain) piece of information that matters most when a tree 
is actualy _used_ by people (not just developed to the moon), and 
this piece of information is missing in most cases.

Developers often _do not create_ this information even in their 
heads: and it's not at all apparent from a commit log whether this 
information has been created. Making them think about this straight 
at patch creation time, with an easy rule and an easy reminder, is 
an obviously good thing to kernel quality in general.

So we saw this general problem and we tried to find a solution.

Instead of ping-ponging with contributors all the time and bitching 
about subject lines (which really is not something most developers 
will even understand the deep importance of, and which is also 
rather difficult to do linguistically) we went for preemptively 
asking them to include this kind of information, in a separate, 
limited-format and limited-purpose impact line that concentrates on 
just creating this information.

And given the very clear rejection of some special sign in the 
summary line (or right next to it), and given the intrusion the 
header-impact-line approach causes to the natural language flow of 
the commit log, a couple of days ago we switched to an impact-footer 
that describes 'impact to the kernel' in an as short way as 
possible.

After a few days of experience with it i can tell you that it's even 
better than the original header approach: it fits better into the 
other tags and it can be done more consistently because it's less 
intrusive to the introductory portion of the commit log (which was 
the main complaint against it). There's also upstream buy-in now 
which is a big plus. So as far as i'm concerned there's a happy 
ending.

Note that this tag is both poorer and richer in information than the 
summary line you describe, so it's really pretty complementary. It 
is poorer in that it does not replicate subsystem information and 
does not replicate implementational details. It is richer in that it 
always tries to describe practical impact of a change.

Look at the example below, it is a commit from today and it has this 
summary line and this impact line:

    tracing/ring-buffer: Add unlock recursion protection on discard

    ...

    [ Impact: fix spurious warning triggering tracing shutdown ]

Both kinds of information are important. To the developer it is more 
important to see that we added recursion protection to trace-record 
discard path.

To the user/tester/distributor/lurker it is more important to see 
that this fix addresses a spurious warning that causes the tracing 
subsystem to self-disable. This is simply a different 'view' of the 
same commit - and a pretty important view at that.

Can you integrate these two into a single summary line? The obvious 
solution would be to append them:

     tracing/ring-buffer: add unlock recursion protection on discard to fix spurious warning triggering tracing shutdown

but 121 characters width is _way_ too long for a summary.

And even if we could squeeze it into the given line length, can you 
make it apparent enough 'at a glance' that this has been done (and 
can you enable tooling that checks whether this has been done) 
versus the many commits where this has not been done?

( The tag scheme Ted proposed addresses those problems but has a 
  number of other disadvantages. )

	Ingo

---------------------------------------------->
commit f3b9aae16219aaeca2dd5a9ca69f7a10faa063df
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Sun Apr 19 23:39:33 2009 +0200

    tracing/ring-buffer: Add unlock recursion protection on discard
    
    The pair of helpers trace_recursive_lock() and trace_recursive_unlock()
    have been introduced recently to provide generic tracing recursion
    protection.
    
    They are used in a symetric way:
    
     - trace_recursive_lock() on buffer reserve
     - trace_recursive_unlock() on buffer commit
    
    However sometimes, we don't commit but discard on entry
    to the buffer, ie: in case of filter checking.
    
    Then we must also unlock the recursion protection on discard time,
    otherwise the tracing gets definitely deactivated and a warning
    is raised spuriously, such as:
    
    111.119821] ------------[ cut here ]------------
    [  111.119829] WARNING: at kernel/trace/ring_buffer.c:1498 ring_buffer_lock_reserve+0x1b7/0x1d0()
    [  111.119835] Hardware name: AMILO Li 2727
    [  111.119839] Modules linked in:
    [  111.119846] Pid: 5731, comm: Xorg Tainted: G        W  2.6.30-rc1 #69
    [  111.119851] Call Trace:
    [  111.119863]  [<ffffffff8025ce68>] warn_slowpath+0xd8/0x130
    [  111.119873]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
    [  111.119882]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
    [  111.119891]  [<ffffffff802199b0>] ? native_sched_clock+0x20/0x70
    [  111.119899]  [<ffffffff80286dee>] ? put_lock_stats+0xe/0x30
    [  111.119906]  [<ffffffff80286eb8>] ? lock_release_holdtime+0xa8/0x150
    [  111.119913]  [<ffffffff802c8ae7>] ring_buffer_lock_reserve+0x1b7/0x1d0
    [  111.119921]  [<ffffffff802cd110>] trace_buffer_lock_reserve+0x30/0x70
    [  111.119930]  [<ffffffff802ce000>] trace_current_buffer_lock_reserve+0x20/0x30
    [  111.119939]  [<ffffffff802474e8>] ftrace_raw_event_sched_switch+0x58/0x100
    [  111.119948]  [<ffffffff808103b7>] __schedule+0x3a7/0x4cd
    [  111.119957]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
    [  111.119964]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
    [  111.119971]  [<ffffffff80810c08>] schedule+0x18/0x40
    [  111.119977]  [<ffffffff80810e09>] preempt_schedule+0x39/0x60
    [  111.119985]  [<ffffffff80813bd3>] _read_unlock+0x53/0x60
    [  111.119993]  [<ffffffff807259d2>] sock_def_readable+0x72/0x80
    [  111.120002]  [<ffffffff807ad5ed>] unix_stream_sendmsg+0x24d/0x3d0
    [  111.120011]  [<ffffffff807219a3>] sock_aio_write+0x143/0x160
    [  111.120019]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
    [  111.120026]  [<ffffffff80721860>] ? sock_aio_write+0x0/0x160
    [  111.120033]  [<ffffffff80721860>] ? sock_aio_write+0x0/0x160
    [  111.120042]  [<ffffffff8031c283>] do_sync_readv_writev+0xf3/0x140
    [  111.120049]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
    [  111.120057]  [<ffffffff80276ff0>] ? autoremove_wake_function+0x0/0x40
    [  111.120067]  [<ffffffff8045d489>] ? cap_file_permission+0x9/0x10
    [  111.120074]  [<ffffffff8045c1e6>] ? security_file_permission+0x16/0x20
    [  111.120082]  [<ffffffff8031cab4>] do_readv_writev+0xd4/0x1f0
    [  111.120089]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
    [  111.120097]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
    [  111.120105]  [<ffffffff8031cc18>] vfs_writev+0x48/0x70
    [  111.120111]  [<ffffffff8031cd65>] sys_writev+0x55/0xc0
    [  111.120119]  [<ffffffff80211e32>] system_call_fastpath+0x16/0x1b
    [  111.120125] ---[ end trace 15605f4e98d5ccb5 ]---
    
    [ Impact: fix spurious warning triggering tracing shutdown ]
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
