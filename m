Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZLFMLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZLFMLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 07:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZLFMLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 07:11:11 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:52645 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZLFMLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 07:11:10 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: Fix timechart header handling
References: <87ljhg8ioe.fsf@devron.myhome.or.jp>
	<20091206115458.GA21964@elte.hu>
Date: Sun, 06 Dec 2009 21:11:11 +0900
In-Reply-To: <20091206115458.GA21964@elte.hu> (Ingo Molnar's message of "Sun,
	6 Dec 2009 12:54:58 +0100")
Message-ID: <874oo48fq8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>
>> Hi,
>> 
>> Update "struct trace_entry" to match with current one. And remove
>> "size" field from it.
>> 
>> If it has "size", it become cause of alignment mismatch of structure
>> with kernel.
>> 
>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>> ---
>> 
>>  tools/perf/builtin-timechart.c |   12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> Just curious, have you tested timechart functionality after having done 
> this change - does it still work fine for you?

Yes. Rather, it doesn't work without this. (Without patch, it provide
svg output, but it doesn't provide correct sched state. And this issue
is only 64bit arch.)

E.g. The following has difference (perf timechart doesn't has hole).

In kernel,

struct ftrace_raw_sched_switch {
	struct trace_entry         ent;                  /*     0    12 */
	char                       prev_comm[16];        /*    12    16 */
	pid_t                      prev_pid;             /*    28     4 */
	int                        prev_prio;            /*    32     4 */

	/* XXX 4 bytes hole, try to pack */

	long int                   prev_state;           /*    40     8 */
	char                       next_comm[16];        /*    48    16 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	pid_t                      next_pid;             /*    64     4 */
	int                        next_prio;            /*    68     4 */
	char                       __data[0];            /*    72     0 */

	/* size: 72, cachelines: 2, members: 9 */
	/* sum members: 68, holes: 1, sum holes: 4 */
	/* last cacheline: 8 bytes */
};

In perl timechart, [Note, struct trace_entry is including "u32 size"]

struct sched_switch {
	struct trace_entry         te;                   /*     0    16 */
	char                       prev_comm[16];        /*    16    16 */
	int                        prev_pid;             /*    32     4 */
	int                        prev_prio;            /*    36     4 */
	long int                   prev_state;           /*    40     8 */
	char                       next_comm[16];        /*    48    16 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	int                        next_pid;             /*    64     4 */
	int                        next_prio;            /*    68     4 */

	/* size: 72, cachelines: 2, members: 8 */
	/* last cacheline: 8 bytes */
};


Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
