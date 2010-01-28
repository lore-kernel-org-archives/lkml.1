Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704Ab0A1Gva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0A1Gva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021Ab0A1Gva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:51:30 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58649 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0A1Gv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:51:29 -0500
Message-ID: <4B6133DF.9080207@dcl.info.waseda.ac.jp>
Date: Thu, 28 Jan 2010 15:51:11 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 11/12] perf lock: New subcommand "perf lock", for analyzing
 lock statistics
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1264167553-6510-12-git-send-email-mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1264167553-6510-12-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年01月22日 22:39, Hitoshi Mitake wrote:

Hi Ingo,
I have a trivial but difficult problem on this 11th patch.

 > +static void
 > +process_lock_acquire_event(void *data,
 > +			   struct event *event __used,
 > +			   int cpu __used,
 > +			   u64 timestamp __used,
 > +			   struct thread *thread __used)
 > +{
 > +	struct trace_acquire_event acquire_event;
 > +	u64 tmp;		/* this is required for casting... */
 > +
 > +	tmp = raw_field_value(event, "lockdep_addr", data);
 > +	acquire_event.addr = (void *)tmp;   # <- type of addr is void *

In the above function,
the statement:
     raw_field_value(event, "lockdep_addr", data);
reads member of event which is type of void *.

But, direct assigning like
     acquire_event.addr = (void *)raw_field_value(event, "lockdep_addr", 
data);
produces warning and it is treated as error on build environment of perf.
GCC says "cast from function call of type ‘long long unsigned int’ to 
non-matching type ‘void *’".
# Why is tmp to acquire_event.addr allowed? It's mysterious...

So I declared "u64 tmp" as temporary place for casting.
But next, this tmp causes compile error on x86_32.
Because it is u64. tmp should be u32 on x86_32.

I have to switch type of tmp u64 or u32 based on environment.
Don't you know some good preprocessor flag or some other avoiding methods?
I seeked but not found...

Thanks,
	Hitoshi
