Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZBITEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZBITEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZBITE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:04:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZBITE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:04:26 -0500
Date: Mon, 9 Feb 2009 17:04:06 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] ring_buffer: pahole struct ring_buffer
Message-ID: <20090209190406.GA11005@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While fixing some bugs in pahole (built-in.o files were not being
processed due to relocation problems) I found out about these packable
structures:

$ pahole --packable kernel/trace/ring_buffer.o  | grep ring
ring_buffer	72	64	8
ring_buffer_per_cpu	112	104	8

If we take a look at the current layout of struct ring_buffer we can see
that we have two 4 bytes holes.

$ pahole -C ring_buffer kernel/trace/ring_buffer.o
struct ring_buffer {
	unsigned int               pages;           /*     0     4 */
	unsigned int               flags;           /*     4     4 */
	int                        cpus;            /*     8     4 */

	/* XXX 4 bytes hole, try to pack */

	cpumask_var_t              cpumask;         /*    16     8 */
	atomic_t                   record_disabled; /*    24     4 */

	/* XXX 4 bytes hole, try to pack */

	struct mutex               mutex;           /*    32    32 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct ring_buffer_per_cpu * * buffers;     /*    64     8 */

	/* size: 72, cachelines: 2, members: 7 */
	/* sum members: 64, holes: 2, sum holes: 8 */
	/* last cacheline: 8 bytes */
};

So, if I ask pahole to reorganize it:

$ pahole -C ring_buffer --reorganize kernel/trace/ring_buffer.o

struct ring_buffer {
	unsigned int               pages;           /*     0     4 */
	unsigned int               flags;           /*     4     4 */
	int                        cpus;            /*     8     4 */
	atomic_t                   record_disabled; /*    12     4 */
	cpumask_var_t              cpumask;         /*    16     8 */
	struct mutex               mutex;           /*    24    32 */
	struct ring_buffer_per_cpu * * buffers;     /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */

	/* size: 64, cachelines: 1, members: 7 */
};   /* saved 8 bytes and 1 cacheline! */

We get it using just one 64 bytes cacheline.

To see what it did:

$ pahole -C ring_buffer --reorganize --show_reorg_steps \
	kernel/trace/ring_buffer.o | grep \/
/* Moving 'record_disabled' from after 'cpumask' to after 'cpus' */

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 53ba3a6..27ef3bf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -273,8 +273,8 @@ struct ring_buffer {
 	unsigned			pages;
 	unsigned			flags;
 	int				cpus;
-	cpumask_var_t			cpumask;
 	atomic_t			record_disabled;
+	cpumask_var_t			cpumask;
 
 	struct mutex			mutex;
 
