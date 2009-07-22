Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZGVPSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZGVPSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZGVPSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:18:09 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:50988 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZGVPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:18:08 -0400
Date: Wed, 22 Jul 2009 20:47:59 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/ksym_tracer: support quick clear for
	ksym_trace_filter
Message-ID: <20090722151759.GA11367@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4A6685BB.2090809@cn.fujitsu.com> <4A66869A.9000106@cn.fujitsu.com> <20090722050636.GA9039@in.ibm.com> <4A66E261.2090105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A66E261.2090105@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 05:56:49PM +0800, Xiao Guangrong wrote:
> 
> 
> K.Prasad wrote:
> > On Wed, Jul 22, 2009 at 11:25:14AM +0800, Xiao Guangrong wrote:
> >> It's rather bored to clear symbol one by one in ksym_trace_filter
> >> file, so, this patch can let ksym_trace_filter file support quick
> >> clear, we can write "0" to this file, it can clear all symbols
> >>
> >> for example:
> >>  # cat ksym_trace_filter
> >>  ksym_filter_head:rw-
> >>  global_trace:rw-
> >>  # echo 0 > ksym_trace_filter
> >>  # cat ksym_trace_filter
> >>  #
> >>
> > 
> > It's nice to have this feature added and the other patches fix issues in
> > ksym tracer. Can you have this patch add the capability to clear all
> > breakpoints in one-shot through wild-cards?
> > 
> 
> It already can clear all breakpoints in one-shot by write "0" to
> ksym_trace_filter file, do you means that we need to support other
> way for it? like:
> 
> echo > ksym_trace_filter
> echo "*:---" > ksym_trace_filter
> 
> IMHO, one way to clear all breakpoints is enough, no need to add
> more code for the same function, for example, in trace events filter,
> only echo 0 > filter can properly clear all filters.
> 
> Are you sure other way is necessary? 
> 
> Thanks,
> Xiao
>

As I stated before, the ability to support
echo "*:---" > ksym_trace_filter was Ingo Molnar's suggestion, so if
he's not particular about having it now we may skip it.

However, given that it requires just a few lines of code in addition,
say

+	/* Clear all breakpoints if echo "*:---" > ksym_trace_filter */
+	if ((strncmp(ksymname, "*", strlen("*")) == 0) && (op == 0)) {
+		ksym_trace_reset(NULL);
+		kfree(input_string);
+		return count;
+	}

in ksym_trace_filter_write(), and that the patch is already present it
shouldn't be bothersome to add it.

Thanks,
K.Prasad

