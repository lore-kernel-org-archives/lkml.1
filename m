Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZGFPe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZGFPe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZGFPeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:34:18 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:13275 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZGFPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:34:18 -0400
X-SourceIP: 213.93.53.227
Subject: Re: bts & perf_counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EBE519AE5@irsmsx504.ger.corp.intel.com>
References: <20090611214124.GA4133@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC65961@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBD00DC5@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EBE2DB8EB@irsmsx504.ger.corp.intel.com>
	 <20090624133645.GE6224@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EBE2DB9B9@irsmsx504.ger.corp.intel.com>
	 <20090624153229.GA24346@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EBE2DC3D9@irsmsx504.ger.corp.intel.com>
	 <20090626122948.GC10850@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EBE519869@irsmsx504.ger.corp.intel.com>
	 <20090629202002.GF31577@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EBE519AE5@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 17:34:14 +0200
Message-Id: <1246894454.8143.101.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 08:32 +0100, Metzger, Markus T wrote:
> 
> >> A debugger is interested in the tail of the execution trace. It
> >> won't poll the trace data (which would be far too much overhead).
> >> How would a user synchronize on the profile stream when the
> >> profiled process is stopped?
> >
> >Yeah, with a new perf_attr flag that activates overwrite this
> >usecase would be solved, right? The debugger has to make sure the
> >task is stopped before reading out the buffer, but that's pretty
> >much all.
> 
> I'm not sure about that. The way I read struct perf_counter_mmap_page,
> data_head points to the end of the stream (I would guess one byte
> beyond the last record).
> 
> I think we can ignore data_tail in the debug scenario since debuggers
> won't poll. We can further assume a buffer overflow no matter how big
> the ring buffer - branch trace grows terribly fast and we don't want
> normal uses to lock megabytes of memory, do we?
> 
> How would a debugger find the beginning of the event stream to start
> reading?

something like the below? (utterly untested)

---
 include/linux/perf_counter.h |    3 ++-
 kernel/perf_counter.c        |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..95b5257 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -180,8 +180,9 @@ struct perf_counter_attr {
 				freq           :  1, /* use freq, not period  */
 				inherit_stat   :  1, /* per task counts       */
 				enable_on_exec :  1, /* next exec enables     */
+				overwrite      :  1, /* overwrite mmap data   */
 
-				__reserved_1   : 51;
+				__reserved_1   : 50;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..0c64d53 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2097,6 +2097,13 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
 	/*
+	 * attr->overwrite and PROT_WRITE both use ->data_tail in an exclusive
+	 * manner, disallow this combination.
+	 */
+	if ((vma->vm_flags & VM_WRITE) && counter->attr.overwrite)
+		return -EINVAL;
+
+	/*
 	 * If we have data pages ensure they're a power-of-two number, so we
 	 * can do bitmasks instead of modulo.
 	 */
@@ -2329,6 +2336,7 @@ struct perf_output_handle {
 	struct perf_counter	*counter;
 	struct perf_mmap_data	*data;
 	unsigned long		head;
+	unsigned long		tail;
 	unsigned long		offset;
 	int			nmi;
 	int			sample;
@@ -2363,6 +2371,31 @@ static bool perf_output_space(struct perf_mmap_data *data,
 	return true;
 }
 
+static void perf_output_tail(struct perf_mmap_data *data, unsigned int head)
+{
+	__u64 *tailp = &data->user_page->data_tail;
+	struct perf_event_header *header;
+	unsigned long pages_mask, nr;
+	unsigned long tail, new;
+	unsigned long size;
+	void *ptr;
+
+	if (data->writable)
+		return;
+
+	size 	   = data->nr_pages << PAGE_SHIFT;
+	pages_mask = data->nr_pages - 1;
+	tail	   = ACCESS_ONCE(*tailp);
+
+	while (tail + size - head < 0) {
+		nr     = (tail >> PAGE_SHIFT) & pages_mask;
+		ptr    = data->pages[nr] + (tail & (PAGE_SIZE - 1));
+		header = (struct perf_event_header *)ptr;
+		new    = tail + header->size;
+		tail   = atomic64_cmpxchg(tailp, tail, new);
+	}
+}
+
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
 	atomic_set(&handle->data->poll, POLL_IN);
@@ -2535,6 +2568,8 @@ static int perf_output_begin(struct perf_output_handle *handle,
 		head += size;
 		if (unlikely(!perf_output_space(data, offset, head)))
 			goto fail;
+		if (unlikely(counter->attr.overwrite))
+			perf_output_tail(data, head);
 	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;


