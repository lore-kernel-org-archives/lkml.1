Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZJGDJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZJGDJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZJGDJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:09:14 -0400
Received: from ozlabs.org ([203.10.76.45]:48937 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZJGDJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:09:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19148.1579.573095.98045@cargo.ozlabs.ibm.com>
Date: Wed, 7 Oct 2009 14:08:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing: Check total refcount before releasing bufs in profile_enable failure
In-Reply-To: <1254577650-5623-2-git-send-email-fweisbec@gmail.com>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
	<1254577650-5623-2-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> When we call the profile_enable() callback of an event, we release the
> shared perf event tracing buffers unconditionnaly in the failure path.
> This is wrong because there may be other users of these. Then check the
> total refcount before doing this.

[snip]

> -	kfree(trace_profile_buf_nmi);
>  fail_buf_nmi:
> -	kfree(trace_profile_buf);
> +	if (!total_profile_count) {

A small problem here: total_profile_count will be 1, not 0, in the
case where we need to free...

> +		kfree(trace_profile_buf_nmi);
> +		kfree(trace_profile_buf);
> +		trace_profile_buf_nmi = NULL;
> +		trace_profile_buf = NULL;
> +	}
>  fail_buf:
> -	total_profile_count--;

since we don't decrement total_profile_count until here.

Paul.
