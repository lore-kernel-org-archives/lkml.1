Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYHJRI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYHJRI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 13:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYHJRIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 13:08:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:53806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYHJRIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 13:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MwskiUAzCbVk1KiNazkRLBs5EUeMdlIWM3zH6PIfogRGo7JzGJwJyQDZllkoEmCGvb
         g1pXdsv1170ZyxjcjPaSKm5lO4diQr5Po0NLeinl+9Yi6zY7pHciYM4hwD9bxCr9nJmN
         yajhcDhqkVqxarPBaXQkU6CchGBh2n4OM5t/4=
Date: Sun, 10 Aug 2008 19:08:15 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-pm@lists.linux-foundation.org
Subject: resume from s2ram regression (bisected to ftrace...)
Message-ID: <20080810170801.GA5739@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Few days ago I discovered that resume from suspend to ram does not work anymore
on my 2.6.27-rc2 (actually 796aadeb1b2db9b5d463946766c5bbfd7717158c) gentoo box.
My computer just boots on resume. Today I had enough time to bisect it and found
(after 1 panic and 1 build breakage) out "the reason":

$ git bisect good
d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b is first bad commit
commit d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Mon May 12 21:20:54 2008 +0200

    ftrace: fix dynamic ftrace selftest

    With the adding of the configuration changes in the Makefile to prevent
    tracing of functions in the ftrace code, all tracing of all the ftrace
    code has been removed. Unfortunately, one of the selftests, relied on
    a function to be traced. With the new change, the function was no longer
    traced and the test failed.

    This patch separates out the test function into its own file so that
    we can add the "-pg" flag to the compilation of that function and the
    adding of the mcount call to that function.

    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 0fe901f75979b8a110e58133e1d31e304d4214d5 6a63e96d5afe318a2f6f541cc48a8cf224088611 M      kernel

$ git bisect log
git-bisect start
# bad: [0967d61ea0d8e8a7826bd8949cd93dd1e829ac55] Linux 2.6.27-rc2
git-bisect bad 0967d61ea0d8e8a7826bd8949cd93dd1e829ac55
# good: [bce7f793daec3e65ec5c5705d2457b81fe7b5725] Linux 2.6.26
git-bisect good bce7f793daec3e65ec5c5705d2457b81fe7b5725
# bad: [49997d75152b3d23c53b0fa730599f2f74c92c65] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/torvalds/linux-2.6
git-bisect bad 49997d75152b3d23c53b0fa730599f2f74c92c65
# bad: [43d2548bb2ef7e6d753f91468a746784041e522d] Merge commit '85082fd7cbe3173198aac0eb5e85ab1edcc6352c' into test-build
git-bisect bad 43d2548bb2ef7e6d753f91468a746784041e522d
# bad: [5806b81ac1c0c52665b91723fd4146a4f86e386b] Merge branch 'auto-ftrace-next' into tracing/for-linus
git-bisect bad 5806b81ac1c0c52665b91723fd4146a4f86e386b
# good: [6236af82d8a989e150a02800c210eb61cb1e17be] Merge branch 'x86/fixmap' into x86/devel
git-bisect good 6236af82d8a989e150a02800c210eb61cb1e17be
# good: [32b23e9a7331fce57eb0af52e19e8409fdef831b] x86: max_low_pfn_mapped fix #4
git-bisect good 32b23e9a7331fce57eb0af52e19e8409fdef831b
# bad: [e0fd5c2fa188311667267c02a702ae699a9fc2bd] mmiotrace: do not print bogus pid for maps either
git-bisect bad e0fd5c2fa188311667267c02a702ae699a9fc2bd
# good: [5429db2d26a59903c81a4f6c6dae7eb9daaea5fc] ftrace: fix wakeup callback
git-bisect good 5429db2d26a59903c81a4f6c6dae7eb9daaea5fc
# bad: [2bb6f8d6389cbfadd657e7dc069f6986abf35e4f] ftrace: use raw_smp_processor_id for mcount functions
git-bisect bad 2bb6f8d6389cbfadd657e7dc069f6986abf35e4f
# bad: [8487c23765b6e0444ec6b5f1530766d63fe68e35] ftrace: allow trace_pipe to block on all reads
git-bisect bad 8487c23765b6e0444ec6b5f1530766d63fe68e35
# bad: [1d09daa55d2e9bab7e7d30f0d05e5a7bc60b2a4a] ftrace: use Makefile to remove tracing from lockdep
git-bisect bad 1d09daa55d2e9bab7e7d30f0d05e5a7bc60b2a4a
# bad: [d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b] ftrace: fix dynamic ftrace selftest
git-bisect bad d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b
# good: [8f96da02c14d722ad9a3713cd7273ce28c9036ad] ftrace: remove wakeup from function trace
git-bisect good 8f96da02c14d722ad9a3713cd7273ce28c9036ad
# good: [06fa75ab566c50e01bfd7b055bde85cf9b1bc98a] ftrace: add TRACE_STACK and TRACE_SPECIAL to selftest validation
git-bisect good 06fa75ab566c50e01bfd7b055bde85cf9b1bc98a

This commit looks completely unrelated to s2ram, but funny thing happened -
when I reverted it on top of 796aadeb1b2db9b5d463946766c5bbfd7717158c
(2.6.27-rc2+), suspend to ram started to work... 

You can find my .config, successful s2ram dmesg and lspci at
http://www.kadu.net/~joi/kernel/2008.08.10/

Marcin
