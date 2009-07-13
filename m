Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZGMHT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZGMHT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZGMHTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:19:53 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:60734 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbZGMHTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:19:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0EABJ4WkpMQWU3/2dsb2JhbACBUcg+gkGBSAU
Date: Mon, 13 Jul 2009 03:14:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Robert Wisniewski <bob@watson.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: LTTng 0.146, adds extra read-side sub-buffer for flight recorder
Message-ID: <20090713071440.GA32730@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:38:11 up 135 days,  3:04,  4 users,  load average: 0.93, 0.66,
	0.48
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So, I needed a weekend break from writing my thesis (It's almost over!) ;)
and I had the great idea to try to come up with a way to ensure that
LTTng flight recorder mode permits to have a read-side that never sees
corrupted data.

Basically, this is the main thing Steven have been asking me for a
while. And it looks like I just figured out a way to do it.

So for flight recorder tracing, this new LTTng version allocates an
extra subbuffer which gets exchanged by the reader with the writer
subbuffer before it gets read.

Normal tracing does not need this extra subbuffer, because the
write-side just drops events when the buffer is full. So we don't
allocate it and we don't perform any exchange. The space
reservation/commit code plays nicely with both flight recorder and
normal tracing schemes.

Here is how I did it:

No modification was required to the buffer space reservation/commit
algorithm. I just had to do the following at the backend level
(responsible for writing data to/reader data from the buffer):

I am using an array of pointers (one pointer for each subbuffer), plus a
pointer to the reader subbuffer. Each of these pointers are pointing to
an array of pages, which are all the pages that constitute a subbuffer.
Reads/writes from/to the buffer are done by accessors which pick up the
right page location within this page table. By modifying the top-level
subbuffer pointer, we can swap a whole subbuffer in a single operation.

There is a trick to deal with concurrency between writer and reader.
When the top-level subbuffer pointers are not used (no writer is
currently writing into it, no reader is reading from its subbuffer), we
set a RCHAN_NOREF_FLAG (value: 0x1) which indicates that no reference is
currently taken to this subbuffer. As long as this flag is set in the
pointer, it is safe for the reader to exchange it. When the writer needs
to access this subbuffer for writing, it clears the flag, and sets it
back after committing the last piece of data to it.

When the reader figures out that the write-side subbuffer it is trying
to exchange has a reference, it fails with -EAGAIN.

Nice things about the way I do it here:

- I keep the separation between the space reservation layer and back-end
  buffer layer. The extra reader subbuffer exchange is done at the
  back-end layer. The reason why it took me so long to try to come up
  with something is that I tried to do it at the space reservation
  layer, which was not fitting well the space reservation semantics.

- Keeping space reservation and physical buffer management separate
  helps splitting complexity into sub-layers easier to verify.

- Given the space reservation/commit is separate from the subbuffer
  exchange per se, I don't need any special-cases for "if the tail
  pointer is in the reader page".... these things never happen because
  the reserve, commit and consumed counts are completely unrelated to
  the pointers to physical subbuffers.

As always, the tree is available at:

http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git
git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git

The commits implementing this the extra reader page for the lockless
scheme are:

lttng-relay-per-subbuffer-index.patch
lttng-relay-per-subbuffer-index-low-bit-noref.patch
lttng-relay-lockless-writer-use-noref-flag.patch
lttng-relay-default-sb-index-to-noref.patch
lttng-relay-lockless-exchange-reader-writer-pages.patch

Comments are welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
