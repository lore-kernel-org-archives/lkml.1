Return-Path: <linux-kernel-owner+w=401wt.eu-S932230Ab0AFP2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0AFP2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963Ab0AFP2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:28:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64632 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0AFP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:28:13 -0500
X-Authority-Analysis: v=1.0 c=1 a=5nxZjVVQarsA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=YRJDSQ7NJi_R0NIom34A:9 a=2MsG7Aounohar-FIAMuA0eH2iVYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: consolidate protection of reader access to
 the ring buffer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B447D52.1050602@cn.fujitsu.com>
References: <4B447D52.1050602@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 06 Jan 2010 10:28:07 -0500
Message-ID: <1262791687.28171.2879.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 20:08 +0800, Lai Jiangshan wrote:
> At the beginning, access to the ring buffer are fully serialized
> by trace_types_lock. Patch d7350c3f4569 gives more freedom to readers,
> and patch b04cc6b1f6 adds code to protect trace_pipe and cpu#/trace_pipe.
> 
> But actually it is not enough, ring buffer readers are not always
> read-only, they may consume data.
> 
> This patch makes accesses to trace, trace_pipe, trace_pipe_raw
> cpu#/trace, cpu#/trace_pipe and cpu#/trace_pipe_raw are serialized.
> And removes tracing_reader_cpumask which is used to protect trace_pipe.
> 
> detail:
> 
> ring buffer serializes readers, but it is low level protection.
> The validity of the events (which returns by ring_buffer_peek() ..etc)
> are not protected by ring buffer.
> 
> The content of events may become garbage if we allow other process consumes
> these events concurrently:
>   A) the page of the consumed events may become a normal page
>      (not reader page) in ring buffer, and this page will be rewrited
>      by events producer.
>   B) The page of the consumed events may become a page for splice_read,
>      and this page will be returned to system.
> 
> This patch adds trace_access_lock() and trace_access_unlock() primitives.
> 
> These primitives allow multi process access to different cpu ring buffer
> concurrently.
> 
> These primitives don't distinguish read-only and read-consume access.
> Multi read-only access are also serialized.
> 
> And we don't use these primitives when we open files,
> we only use them when we read files.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>


I queue this up with your other pending patches for .34

Thanks!

-- Steve


