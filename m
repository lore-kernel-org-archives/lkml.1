Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbYBEXgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbYBEXgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763519AbYBEXfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:35:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:62504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763510AbYBEXfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:35:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,309,1199692800"; 
   d="scan'208";a="335496071"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [RFC][PATCH] kprobes: kprobe-booster for ia64
Date: Tue, 5 Feb 2008 15:34:16 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC84804C@orsmsx424.amr.corp.intel.com>
In-Reply-To: <47A8E995.1090400@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH] kprobes: kprobe-booster for ia64
Thread-Index: AchoSncvGp3G1v8/TiaRxEk3yPY6RgABHUYQ
References: <47A8E995.1090400@redhat.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       "Jim Keniston" <jkenisto@us.ibm.com>,
       "Li, Shaohua" <shaohua.li@intel.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "ia64" <linux-ia64@vger.kernel.org>,
       "systemtap-ml" <systemtap@sources.redhat.com>
X-OriginalArrivalTime: 05 Feb 2008 23:34:17.0913 (UTC) FILETIME=[A02DF290:01C8684F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+/* Insert a long branch code */
+static void __kprobes set_brl_inst(void *from, void *to)
+{
+	s64 rel = ((s64) to - (s64) from) >> 4;
+	bundle_t *brl;
+	brl = (bundle_t *) ((u64) from & ~0xf);
+	brl->quad0.template = 0x05;	/* [MLX](stop) */
+	brl->quad0.slot0 = NOP_M_INST;	/* nop.m 0x0 */
+	brl->quad0.slot1_p0 = ((rel >> 20) & 0x7fffffffff) << 2;
+	brl->quad1.slot1_p1 = (((rel >> 20) & 0x7fffffffff) << 2) >> (64 - 46);
+	/* brl.cond.sptk.many.clr rel<<4 (qp=0) */
+	brl->quad1.slot2 = BRL_INST(rel >> 59, rel & 0xfffff);
+}

Is this function operating directly on the instruction bundle in the
kernel code?  If so, the bundle will contain some "interesting"
intermediate values as each of the "brl->xxx = yyy;" are processed.
If another cpu should try to execute this bundle while the modifications
are in progress, then the results will be not what you want.

On cpu models that support st16 you could construct the brl instruction
and use a single st16 to update the whole bundle atomically.

-Tony
