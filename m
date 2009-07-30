Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZG3AhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZG3AhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZG3Ag7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:36:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51465 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbZG3Ag7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:36:59 -0400
Date: Wed, 29 Jul 2009 19:36:58 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: Possible memory leak via alloc_pid()
Message-ID: <20090730003658.GA27040@us.ibm.com>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com> <20090729170315.f62066c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729170315.f62066c0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 8 Jul 2009 22:33:31 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > Hi,
> > 
> > There's a kmemleak report of a struct pid allocation in alloc_pid()
> > which somehow gets lost:
> > 
> > unreferenced object 0xc307aa00 (size 44):
> >   comm "gdm", pid 2734, jiffies 4294902040
> >   backtrace:
> >     [<c01e721a>] create_object+0xfa/0x250
> >     [<c01e73cd>] kmemleak_alloc+0x5d/0x70
> >     [<c01e0ad6>] kmem_cache_alloc+0x156/0x1a0
> >     [<c01552f9>] alloc_pid+0x19/0x350
> >     [<c013e6e0>] copy_process+0x800/0x1230
> >     [<c013f17f>] do_fork+0x6f/0x370
> >     [<c0101986>] sys_clone+0x36/0x40
> >     [<c010319c>] sysenter_do_call+0x12/0x38
> >     [<ffffffff>] 0xffffffff
> > 
> > This is the gdm fork for starting Xorg (with pid 2739). It first
> > logged me in automatically, after which I logged out and gdm started
> > another Xorg. The pid structure for the first Xorg is reported as a
> > leak. The Xorg with pid 2739 is no longer present on my system.
> > 
> > Using gdb vmlinux /proc/kcore shows that the pid->count is 2, so
> > that's why it probably wasn't freed by put_pid():
> > 
> > (gdb) print ({struct pid}0xc307aa00)
> > $20 = {count = {counter = 2}, level = 0, tasks = {{first = 0x0}, {
> >       first = 0x0}, {first = 0x0}}, rcu = {next = 0xc24bfd64,
> >     func = 0xc0154e90 <delayed_put_pid>}, numbers = {{nr = 2739,
> >       ns = 0xc0737540, pid_chain = {next = 0x0, pprev = 0x200200}}}}
> > 
> > Note that kmemleak is aware of and scans pid_hash (which was recorded
> > in kmemleak as a 16KB object).
> > 
> 
> Thanks.  Let's cc some recent pid fiddlers.

Hi,

thanks for the report.  Note that kernel modules can increment those
counds through find_get_pid().  Can you send your kernel .config and
the output of lsmod?

thanks,
-serge
