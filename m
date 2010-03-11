Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0CKIkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:40:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49793 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0CKIkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:40:46 -0500
Message-ID: <4B98ACC9.4080504@cn.fujitsu.com>
Date: Thu, 11 Mar 2010 16:41:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>,
       Eric Anholt <eric@anholt.net>
CC: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] drm/i915: Convert some trace events to DEFINE_TRACE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
  14655    2732      15   17402    43fa i915_trace_points.o.orig
  11625    2732      10   14367    381f i915_trace_points.o

8 events are converted:

  i915_gem_object:  i915_gem_object_{unbind, destroy}
  i915_gem_request: i915_gem_request_{complete, retire, wait_begin, wait_end}
  i915_ring:        i915_ring_{wait_begin, wait_end}

No functional change.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/gpu/drm/i915/i915_trace.h |   86 +++++++++++--------------------------
 1 files changed, 25 insertions(+), 61 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index 01840d9..3038153 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -115,7 +115,7 @@ TRACE_EVENT(i915_gem_object_get_fence,
 		      __entry->obj, __entry->fence, __entry->tiling_mode)
 );
 
-TRACE_EVENT(i915_gem_object_unbind,
+DECLARE_EVENT_CLASS(i915_gem_object,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
@@ -132,21 +132,18 @@ TRACE_EVENT(i915_gem_object_unbind,
 	    TP_printk("obj=%p", __entry->obj)
 );
 
-TRACE_EVENT(i915_gem_object_destroy,
+DEFINE_EVENT(i915_gem_object, i915_gem_object_unbind,
 
 	    TP_PROTO(struct drm_gem_object *obj),
 
-	    TP_ARGS(obj),
+	    TP_ARGS(obj)
+);
 
-	    TP_STRUCT__entry(
-			     __field(struct drm_gem_object *, obj)
-			     ),
+DEFINE_EVENT(i915_gem_object, i915_gem_object_destroy,
 
-	    TP_fast_assign(
-			   __entry->obj = obj;
-			   ),
+	    TP_PROTO(struct drm_gem_object *obj),
 
-	    TP_printk("obj=%p", __entry->obj)
+	    TP_ARGS(obj)
 );
 
 /* batch tracing */
@@ -197,8 +194,7 @@ TRACE_EVENT(i915_gem_request_flush,
 		      __entry->flush_domains, __entry->invalidate_domains)
 );
 
-
-TRACE_EVENT(i915_gem_request_complete,
+DECLARE_EVENT_CLASS(i915_gem_request,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
@@ -217,64 +213,35 @@ TRACE_EVENT(i915_gem_request_complete,
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
 );
 
-TRACE_EVENT(i915_gem_request_retire,
+DEFINE_EVENT(i915_gem_request, i915_gem_request_complete,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
-	    TP_ARGS(dev, seqno),
-
-	    TP_STRUCT__entry(
-			     __field(u32, dev)
-			     __field(u32, seqno)
-			     ),
-
-	    TP_fast_assign(
-			   __entry->dev = dev->primary->index;
-			   __entry->seqno = seqno;
-			   ),
-
-	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
+	    TP_ARGS(dev, seqno)
 );
 
-TRACE_EVENT(i915_gem_request_wait_begin,
+DEFINE_EVENT(i915_gem_request, i915_gem_request_retire,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
-	    TP_ARGS(dev, seqno),
-
-	    TP_STRUCT__entry(
-			     __field(u32, dev)
-			     __field(u32, seqno)
-			     ),
-
-	    TP_fast_assign(
-			   __entry->dev = dev->primary->index;
-			   __entry->seqno = seqno;
-			   ),
-
-	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
+	    TP_ARGS(dev, seqno)
 );
 
-TRACE_EVENT(i915_gem_request_wait_end,
+DEFINE_EVENT(i915_gem_request, i915_gem_request_wait_begin,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
-	    TP_ARGS(dev, seqno),
+	    TP_ARGS(dev, seqno)
+);
 
-	    TP_STRUCT__entry(
-			     __field(u32, dev)
-			     __field(u32, seqno)
-			     ),
+DEFINE_EVENT(i915_gem_request, i915_gem_request_wait_end,
 
-	    TP_fast_assign(
-			   __entry->dev = dev->primary->index;
-			   __entry->seqno = seqno;
-			   ),
+	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
-	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
+	    TP_ARGS(dev, seqno)
 );
 
-TRACE_EVENT(i915_ring_wait_begin,
+DECLARE_EVENT_CLASS(i915_ring,
 
 	    TP_PROTO(struct drm_device *dev),
 
@@ -291,21 +258,18 @@ TRACE_EVENT(i915_ring_wait_begin,
 	    TP_printk("dev=%u", __entry->dev)
 );
 
-TRACE_EVENT(i915_ring_wait_end,
+DEFINE_EVENT(i915_ring, i915_ring_wait_begin,
 
 	    TP_PROTO(struct drm_device *dev),
 
-	    TP_ARGS(dev),
+	    TP_ARGS(dev)
+);
 
-	    TP_STRUCT__entry(
-			     __field(u32, dev)
-			     ),
+DEFINE_EVENT(i915_ring, i915_ring_wait_end,
 
-	    TP_fast_assign(
-			   __entry->dev = dev->primary->index;
-			   ),
+	    TP_PROTO(struct drm_device *dev),
 
-	    TP_printk("dev=%u", __entry->dev)
+	    TP_ARGS(dev)
 );
 
 #endif /* _I915_TRACE_H_ */
-- 
1.6.3

