Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYKLSbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYKLSbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYKLSbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:31:15 -0500
Received: from relay2.sgi.com ([192.48.179.30]:49226 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752453AbYKLSbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:31:15 -0500
Date: Wed, 12 Nov 2008 12:31:13 -0600
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: sgi-gru drivers need of up to 8192 irqs
Message-ID: <20081112183113.GA2488@sgi.com>
References: <20081001114415.GA3281@sgi.com> <86802c440810020919p4391cbebva0eaa5591e7915be@mail.gmail.com> <48E4FA53.7050401@zytor.com> <20081002171821.GA31601@sgi.com> <20081003085943.GC27551@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003085943.GC27551@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

You may remember a patch that I submitted not so long ago that added
uv_setup_irq() and uv_teardown_irq() functions for UV on x86.

It gave us (SGI) a way to 'allocate' an irq/vector pair and write an MMR
with a CPU's APCID and the vector number. (Two functions were added to
/arch/x86/kernel/io_apic.c to accomplish this -- arch_enable_uv_irq() and
arch_disable_uv_irq().)

This solution was what was suggested by the community after much discussion.

I'm now trying to modify the GRU driver to call uv_setup_irq(). One of the
issues that is arising is that we need to be able to allocate lots of irqs.
For the GRU alone we need up to 32 irqs per blade (based on the number of CPUs)
and there can be up to 256 blades per SSI. (A total of 8192 irqs per SSI.)

Currently I'm finding that NR_IRQS=4352. (It is constrained to the lesser of
NR_CPUS and MAX_IO_APICS.) But the system really runs off of nr_irqs which
gets set down by probe_nr_irqs() to 96 in one configuration I've been running.
This function bases its answer on io_apic_get_redir_entries().

For the GRU there isn't an io_apic component, its needs are based on NR_CPUS.
So there isn't something readily available to cause probe_nr_irqs() to
generate a larger number.

Anyway, I'm looking for any suggestions as to what we should do. (Which may
include abandoning the using of irqs for the GRU driver and just go with two
hardwired system vectors?

Also, what has happened to the sparse irq patch? It doesn't seem to exist
anywhere. Has it been abandoned? I thought it was the means by which we would
be able to have huge numbers of irqs.

Thanks,
Dean

