Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbZFXTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbZFXTMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZFXTMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:12:14 -0400
Received: from cmpxchg.org ([85.214.51.133]:51838 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbZFXTMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:12:13 -0400
Date: Wed, 24 Jun 2009 21:08:36 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 2/2] procfs: provide stack information for threads V0.10
Message-ID: <20090624190835.GA25548@cmpxchg.org>
References: <1245824444.22613.3.camel@wall-e> <20090623233247.7ed661b7.akpm@linux-foundation.org> <1245825903.23818.4.camel@wall-e> <20090624001302.18de9e21.akpm@linux-foundation.org> <m1my7ykrs7.fsf@fess.ebiederm.org> <1245854033.10579.4.camel@wall-e> <20090624152019.GD15037@elte.hu> <1245858590.13531.2.camel@wall-e> <20090624174025.GA13170@cmpxchg.org> <20090624174637.GA7576@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624174637.GA7576@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 07:46:37PM +0200, Ingo Molnar wrote:
> 
> * Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Wed, Jun 24, 2009 at 05:49:50PM +0200, Stefani Seibold wrote:
> > > Am Mittwoch, den 24.06.2009, 17:20 +0200 schrieb Ingo Molnar:
> > > > * Stefani Seibold <stefani@seibold.net> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > this is the newest version of the formaly named "detailed stack info"
> > > > > patch which give you a better overview of the userland application stack
> > > > > usage, especially for embedded linux.
> > > > > 
> > > > > Currently you are only able to dump the main process/thread stack usage
> > > > > which is showed in /proc/pid/status by the "VmStk" Value. But you get no
> > > > > information about the consumed stack memory of the the threads.
> > > > > 
> > > > > There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which
> > > > > marks the vm mapping where the thread stack pointer reside with "[thread
> > > > > stack xxxxxxxx]". xxxxxxxx is the maximum size of stack. This is a
> > > > > value information, because libpthread doesn't set the start of the stack
> > > > > to the top of the mapped area, depending of the pthread usage.
> > > > > 
> > > > > A sample output of /proc/<pid>/task/<tid>/maps looks like:
> > > > > 
> > > > > 08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
> > > > > 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
> > > > > 0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
> > > > > a7d12000-a7d13000 ---p 00000000 00:00 0 
> > > > > a7d13000-a7f13000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
> > > > 
> > > > I have the same question as before: have you checked the use of that 
> > > > field in tools/perf/builtin-record.c, and how your change will 
> > > > impact that?
> > > > 
> > > 
> > > Good question... i have another one: What is 
> > > tools/perf/builtin-record.c and where can i find it? Then i 
> > > could check it.
> > 
> > You can find it in a recent git tree from Linus.
> > 
> > On the original question: builtin-record.c is unaffected by this 
> > patch as this exact field will only be parsed if the mapping is 
> > executable.
> 
> A stack can be executable too. It is not common, but possible.

It also ignores the field if it doesn't start with a slash, so it's
even safe for executable stacks.

On a different note, I think that parser is not working for file
mappings with paths containing spaces.  Not common, but possible :)

The below, sorry: untested, should fix this up.  I think we don't
expect a slash in those lines except in a pathname, so looking for the
first slash should be okay.  What do you think?

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: tools/perf: fix filemap pathname parsing in /proc/pid/maps

Looking backward for the first space from the end of a line in
/proc/pid/maps does not find the start of the pathname of the mapped
file if it contains a space.

Since the only slashes we have in this file occur in the (absolute!)
pathname column of file mappings, looking for the first slash in a
line is a safe method to find the name.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d7ebbd7..9b899ba 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -306,12 +306,11 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
-			char *execname = strrchr(bf, ' ');
+			char *execname = strchr(bf, '/');
 
-			if (execname == NULL || execname[1] != '/')
+			if (execname == NULL)
 				continue;
 
-			execname += 1;
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
 			memcpy(mmap_ev.filename, execname, size);
