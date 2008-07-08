Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYGHIRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYGHIRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYGHIRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:17:12 -0400
Received: from ozlabs.org ([203.10.76.45]:41821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYGHIQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:16:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Dangerous code in cpumask_of_cpu?
Date: Tue, 8 Jul 2008 18:16:40 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "H. Anvin" <hpa@zytor.com>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081816.40623.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph/Mike,

  Looked at cpumask_of_cpu as introduced in 
9f0e8d0400d925c3acd5f4e01dbeb736e4011882 (x86: convert cpumask_of_cpu macro 
to allocated array), and I don't think it's safe:

  #define cpumask_of_cpu(cpu)						\
  (*({									\
	typeof(_unused_cpumask_arg_) m;					\
	if (sizeof(m) == sizeof(unsigned long)) {			\
		m.bits[0] = 1UL<<(cpu);					\
	} else {							\
		cpus_clear(m);						\
		cpu_set((cpu), m);					\
	}								\
	&m;								\
  }))

Referring to &m once out of scope is invalid, and I can't find any evidence 
that it's legal here.  In particular, the change 
b53e921ba1cff8453dc9a87a84052fa12d5b30bd (generic: reduce stack pressure in 
sched_affinity) which passes &m to other functions seems highly risky.

I'm surprised this hasn't already hit us, but perhaps gcc isn't as clever as 
it could be?

I don't know what the right answer is, but we might need to go to a pool of 
cpumask_ts, a get_cpumask_of_cpu() which can sleep and a put_cpumask_of_cpu?

Or maybe a gcc guru can refute this?
Rusty.
