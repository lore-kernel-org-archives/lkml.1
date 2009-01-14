Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbZANCEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbZANCEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZANCEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:04:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:49578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbZANCEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:04:08 -0500
Message-ID: <496D47F7.9020504@kernel.org>
Date: Wed, 14 Jan 2009 11:03:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: ebiederm@xmission.com, cl@linux-foundation.org, mingo@elte.hu,
       travis@sgi.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       akpm@linux-foundation.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH 13/13] x86_32: make percpu symbols zerobased on SMP
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <1231843097-18003-14-git-send-email-tj@kernel.org> <200901141048.59632.rusty@rustcorp.com.au>
In-Reply-To: <200901141048.59632.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Jan 2009 02:03:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
> On Tuesday 13 January 2009 21:08:17 Tejun Heo wrote:
>> This patch makes percpu symbols zerobased on x86_32 SMP by using
>> PERCPU_VADDR() with 0 vaddr in vmlinux_32.lds.S.  A new PHDR is added
>> as existing ones cannot contain sections near address zero.
> ...
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Mike Travis <travis@sgi.com>
>> ---
>>  arch/x86/kernel/cpu/common.c     |    8 ++++++++
>>  arch/x86/kernel/head_32.S        |   37 ++++++++++++++++++++++++++++++++++---
>>  arch/x86/kernel/setup_percpu.c   |    4 ----
>>  arch/x86/kernel/vmlinux_32.lds.S |   16 +++++++++++++++-
>>  4 files changed, 57 insertions(+), 8 deletions(-)
> 
> Hmm, the only reason for this change is to unify with 64-bit, yes?  Yet it
> doesn't actually win us anything on that front, as this diffstat shows.

Yeah and to simplify things for future changes.  In this patch, the
only actual unification is in __per_cpu_offset initialization but the
lack of unification is partly due to the usage of pda and differences
in initialization sequence, which again couldn't be unified because
percpu handling was different, so it's a tied knot and this patch
helps untangling it.  Also, with cpualloc (or whatever) scheduled, I
think it's better to have two percpu models, up and smp, even if it
costs 49 more lines.

> If gcc's -mcmodel=kernel had used a weak symbol for the offset of the stack
> canary, we would have been happy.  Unfortunately generic per-cpu and x86-64
> PDA were developed separately, so noone realize the problem until too late.

And we seem to be stuck with it if we want to keep compatibility with
compilers.  :-(

> The basic series looks good: it will clash with my per-cpu work (mainly
> because I remove the per_cpu__ prefix) in a purely-textual way though.

I thought about removing all explicit per_cpu__ prefixes with
per_cpu_var() but the usage seemed prevalent so left it alone.  Why
remove it BTW?

Thanks.

-- 
tejun
