Return-Path: <linux-kernel-owner+w=401wt.eu-S1764354AbZDIJ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764354AbZDIJ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZDIJ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:26:49 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:3429 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbZDIJ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:26:48 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/4] perf_counter: optimize mmap/comm tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090409091622.GA23636@elte.hu>
References: <20090409085342.799915215@chello.nl>
	 <20090409085524.427173196@chello.nl>  <20090409091622.GA23636@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 11:28:29 +0200
Message-Id: <1239269309.7647.196.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 11:16 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > +static atomic_t nr_comm_tracking __read_mostly;
> 
> hm, nr_comm_tracking is not actually used by any fastpath - just 
> increased and then decreased.

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -2018,7 +2018,12 @@ static void perf_counter_comm_event(stru
 
 void perf_counter_comm(struct task_struct *task)
 {
-	struct perf_comm_event comm_event = {
+	struct perf_comm_event comm_event;
+
+	if (!atomic_read(&nr_comm_tracking))
+		return;
+       
+	comm_event = (struct perf_comm_event){
 		.task	= task,
 		.event  = {
 			.header = { .type = PERF_EVENT_COMM, },


