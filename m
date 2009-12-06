Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZLFMOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZLFMOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 07:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZLFMOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 07:14:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309AbZLFMOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 07:14:05 -0500
Date: Sun, 6 Dec 2009 13:13:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: Fix timechart header handling
Message-ID: <20091206121353.GA31559@elte.hu>
References: <87ljhg8ioe.fsf@devron.myhome.or.jp>
 <20091206115458.GA21964@elte.hu>
 <874oo48fq8.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874oo48fq8.fsf@devron.myhome.or.jp>
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


* OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> >
> >> Hi,
> >> 
> >> Update "struct trace_entry" to match with current one. And remove
> >> "size" field from it.
> >> 
> >> If it has "size", it become cause of alignment mismatch of structure
> >> with kernel.
> >> 
> >> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> >> ---
> >> 
> >>  tools/perf/builtin-timechart.c |   12 ++++++++----
> >>  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > Just curious, have you tested timechart functionality after having done 
> > this change - does it still work fine for you?
> 
> Yes. Rather, it doesn't work without this. (Without patch, it provide
> svg output, but it doesn't provide correct sched state. And this issue
> is only 64bit arch.)
> 
> E.g. The following has difference (perf timechart doesn't has hole).
> 
> In kernel,
> 
> struct ftrace_raw_sched_switch {
> 	struct trace_entry         ent;                  /*     0    12 */
> 	char                       prev_comm[16];        /*    12    16 */
> 	pid_t                      prev_pid;             /*    28     4 */
> 	int                        prev_prio;            /*    32     4 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	long int                   prev_state;           /*    40     8 */
> 	char                       next_comm[16];        /*    48    16 */
> 	/* --- cacheline 1 boundary (64 bytes) --- */
> 	pid_t                      next_pid;             /*    64     4 */
> 	int                        next_prio;            /*    68     4 */
> 	char                       __data[0];            /*    72     0 */
> 
> 	/* size: 72, cachelines: 2, members: 9 */
> 	/* sum members: 68, holes: 1, sum holes: 4 */
> 	/* last cacheline: 8 bytes */
> };
> 
> In perl timechart, [Note, struct trace_entry is including "u32 size"]
> 
> struct sched_switch {
> 	struct trace_entry         te;                   /*     0    16 */
> 	char                       prev_comm[16];        /*    16    16 */
> 	int                        prev_pid;             /*    32     4 */
> 	int                        prev_prio;            /*    36     4 */
> 	long int                   prev_state;           /*    40     8 */
> 	char                       next_comm[16];        /*    48    16 */
> 	/* --- cacheline 1 boundary (64 bytes) --- */
> 	int                        next_pid;             /*    64     4 */
> 	int                        next_prio;            /*    68     4 */
> 
> 	/* size: 72, cachelines: 2, members: 8 */
> 	/* last cacheline: 8 bytes */
> };
> 

ok - thanks for the confirmation!

	Ingo
