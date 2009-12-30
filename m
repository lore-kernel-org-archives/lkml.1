Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZL3VaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZL3VaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZL3VaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:30:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbZL3VaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:30:01 -0500
Date: Wed, 30 Dec 2009 13:29:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: kprobes: get rid of distinct type warning
Message-Id: <20091230132945.f32f49fd.akpm@linux-foundation.org>
In-Reply-To: <20091221120224.GA4471@osiris.boeblingen.de.ibm.com>
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
	<20091221111759.GA12670@in.ibm.com>
	<20091221120224.GA4471@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 13:02:24 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Of course the patch wouldn't help for CONFIG_PREEMPT and !CONFIG_SMP since
> we would have a comparison of a signed and and unsigned value again *sigh*.

We should fix that, shouldn't we?  Rather than working around it at one
caller site.

: #if NR_CPUS > 1
: #define num_online_cpus()	cpumask_weight(cpu_online_mask)
: #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
: #define num_present_cpus()	cpumask_weight(cpu_present_mask)
: #define num_active_cpus()	cpumask_weight(cpu_active_mask)
: #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
: #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
: #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
: #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
: #else
: #define num_online_cpus()	1
: #define num_possible_cpus()	1
: #define num_present_cpus()	1
: #define num_active_cpus()	1
: #define cpu_online(cpu)		((cpu) == 0)
: #define cpu_possible(cpu)	((cpu) == 0)
: #define cpu_present(cpu)	((cpu) == 0)
: #define cpu_active(cpu)		((cpu) == 0)
: #endif

The num_*() "functions" return unsigned on SMP and int on UP.  This is
wrong.

The cpu_*() "functions" got lucky and return int in both cases.

Personally I think it's neatest if a quantity which can never be
negative is held in an unsigned type.  Than includes anything starting
with "num".  But for expediency's sake we could live with making these
things consistently return "int".

Alas, changing those four num_*() "functions" to return int on SMP is a
pretty wide-reaching change and will probably expose warts.

