Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZDNWFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZDNWFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZDNWFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:05:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:63666 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbZDNWFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:05:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,187,1239001200"; 
   d="scan'208";a="131469339"
Subject: Re: [PATCH 4/4] irq: move move_irq_desc calling to set_affinity
 directly -v4
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, "lcm@us.ibm.com" <lcm@us.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49E4F5A3.9050802@kernel.org>
References: <200903231757.53709.rusty@rustcorp.com.au>
	 <20090323165921.GA7559@us.ibm.com>
	 <200903241553.58209.rusty@rustcorp.com.au>
	 <20090402013108.GB7103@us.ibm.com> <20090404003520.GA8847@us.ibm.com>
	 <20090410215515.GC7242@us.ibm.com> <20090411065510.GA11799@elte.hu>
	 <20090413220321.GA11098@us.ibm.com> <49E4146C.7060507@kernel.org>
	 <49E4162A.3060701@kernel.org> <20090414131711.GA4403@elte.hu>
	 <49E4F513.1060709@kernel.org>  <49E4F5A3.9050802@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 14 Apr 2009 15:03:49 -0700
Message-Id: <1239746629.27006.8328.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nack.

This patch and the existing code in Linus's git is wrong.

In mainline:

static void ack_apic_edge(unsigned int irq)
{
        struct irq_desc *desc = irq_to_desc(irq);

        irq_complete_move(&desc);
...

And

static void irq_complete_move(struct irq_desc **descp)
{
...
	*descp = desc = move_irq_desc(desc, me);
...
}

So, we end up modifying the stack pointer in the stack frame of
ack_apic_edge() but not really achieving the actual irq desc migration.

hmm.. We should be seeing crashes/memory leaks etc when this code is
turned on with the appropriate config options (apart from the code not
achieving its actual intentions).

As far as I can see, this patch also has the same issue.
Please fix both mainline and this patch.

And also, please see below:

On Tue, 2009-04-14 at 13:44 -0700, Yinghai Lu wrote:
> Impact: fix panic
> 
> so could move_masked_irq call move_irq_desc directly.
> also we still don't support IRQ_MOVE_PCNTXT aka intr_remapped path

As you added the original bits and also modifying these bits now, it
will be good if you can post a patch for this too. And if you can't test
particular paths, please copy the interested folks and get an ack from
their test results, before pushing the patch to upstream.

thanks,
suresh

