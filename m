Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZAOUFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZAOUFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765319AbZAOUA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:29 -0500
Received: from kroah.org ([198.145.64.141]:48778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762435AbZAOUAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:22 -0500
Date: Thu, 15 Jan 2009 11:57:32 -0800
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
Subject: [patch 09/94] ring-buffer: fix dangling commit race
Message-ID: <20090115195732.GI14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ring-buffer-fix-dangling-commit-race.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit a8ccf1d6f60e3e6ae63122e02378cd4d40dd4aac upstream.

Impact: fix stuck trace-buffers

If an interrupt comes in during the rb_set_commit_to_write and
pushes the tail page forward just at the right time, the commit
updates will miss the adding of the interrupt data. This will
cause the commit pointer to cease from moving forward.

Thanks to Jiaying Zhang for finding this race.

Reported-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ring_buffer.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -769,6 +769,7 @@ rb_set_commit_to_write(struct ring_buffe
 	 * back to us). This allows us to do a simple loop to
 	 * assign the commit to the tail.
 	 */
+ again:
 	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
 		cpu_buffer->commit_page->commit =
 			cpu_buffer->commit_page->write;
@@ -783,6 +784,17 @@ rb_set_commit_to_write(struct ring_buffe
 			cpu_buffer->commit_page->write;
 		barrier();
 	}
+
+	/* again, keep gcc from optimizing */
+	barrier();
+
+	/*
+	 * If an interrupt came in just after the first while loop
+	 * and pushed the tail page forward, we will be left with
+	 * a dangling commit that will never go forward.
+	 */
+	if (unlikely(cpu_buffer->commit_page != cpu_buffer->tail_page))
+		goto again;
 }
 
 static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)

