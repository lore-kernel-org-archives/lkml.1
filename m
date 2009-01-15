Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbZAOUFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbZAOUFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764630AbZAOUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:27 -0500
Received: from kroah.org ([198.145.64.141]:48765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762158AbZAOUAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:20 -0500
Date: Thu, 15 Jan 2009 11:57:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 08/94] ring-buffer: prevent false positive warning
Message-ID: <20090115195729.GH14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ring-buffer-prevent-false-positive-warning.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 98db8df777438e16ad0f44a0fba05ebbdb73db8d upstream.

Impact: eliminate false WARN_ON message

If an interrupt goes off after the setting of the local variable
tail_page and before incrementing the write index of that page,
the interrupt could push the commit forward to the next page.

Later a check is made to see if interrupts pushed the buffer around
the entire ring buffer by comparing the next page to the last commited
page. This can produce a false positive if the interrupt had pushed
the commit page forward as stated above.

Thanks to Jiaying Zhang for finding this race.

Reported-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ring_buffer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -880,12 +880,15 @@ static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		  unsigned type, unsigned long length, u64 *ts)
 {
-	struct buffer_page *tail_page, *head_page, *reader_page;
+	struct buffer_page *tail_page, *head_page, *reader_page, *commit_page;
 	unsigned long tail, write;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
 	unsigned long flags;
 
+	commit_page = cpu_buffer->commit_page;
+	/* we just need to protect against interrupts */
+	barrier();
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
 	tail = write - length;
@@ -909,7 +912,7 @@ __rb_reserve_next(struct ring_buffer_per
 		 * it all the way around the buffer, bail, and warn
 		 * about it.
 		 */
-		if (unlikely(next_page == cpu_buffer->commit_page)) {
+		if (unlikely(next_page == commit_page)) {
 			WARN_ON_ONCE(1);
 			goto out_unlock;
 		}

