Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZDMViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZDMViU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZDMViG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:38:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZDMViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:38:03 -0400
Date: Mon, 13 Apr 2009 23:37:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ext4: Convert instrumentation from markers to
	tracepoints
Message-ID: <20090413213745.GC8514@elte.hu>
References: <20090412172344.GC10547@mit.edu> <1239557566-3411-1-git-send-email-tytso@mit.edu> <1239557566-3411-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239557566-3411-2-git-send-email-tytso@mit.edu>
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


* Theodore Ts'o <tytso@mit.edu> wrote:

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h                    |   22 +--
>  fs/ext4/ext4_i.h                  |   12 -
>  fs/ext4/fsync.c                   |    8 +-
>  fs/ext4/ialloc.c                  |   17 +-
>  fs/ext4/inode.c                   |   79 ++---
>  fs/ext4/mballoc.c                 |   84 ++---
>  fs/ext4/mballoc.h                 |   68 +----
>  fs/ext4/super.c                   |    6 +-
>  include/linux/ext4_trace_types.h  |  108 ++++++
>  include/trace/ext4.h              |    8 +
>  include/trace/ext4_event_types.h  |  690 +++++++++++++++++++++++++++++++++++++
>  include/trace/trace_event_types.h |    1 +
>  include/trace/trace_events.h      |    1 +
>  13 files changed, 886 insertions(+), 218 deletions(-)
>  create mode 100644 include/linux/ext4_trace_types.h
>  create mode 100644 include/trace/ext4.h
>  create mode 100644 include/trace/ext4_event_types.h

Really nice stuff!

A general, high-level observation: it is visible that the conversion 
to TRACE_EVENTS() does increase the total linecount, but it also 
removes code from the most often used source code areas 
(fs/ext4/*.c) - and using an intuitive function-call-alike 
single-line tracepoint there.

I'd call that a positive effect.

It would still be nice to compact the 690 lines of (out of line) 
ext4_event_types.h definitions some more - and i think we'll be able 
to do it without affecting the usage sites.

OTOH, even those bits look fairly readable, and there's a fair 
amount of bang-for-bucks ratio - these tracepoints give us:

      - integrated tracepoints
      - zero-copy and per-cpu splice() based tracing
      - binary tracing without printf overhead
      - structured logging records exposed under /debug/tracing/events
      - trace events embedded in function tracer output and other plugins
      - user-defined, per tracepoint filter expressions

... so even if we were to keep the 690 lines of overhead with no 
further compacting, it still looks like a good deal to me, all 
things considered.

	Ingo
