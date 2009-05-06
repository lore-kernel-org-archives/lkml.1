Return-Path: <linux-kernel-owner+w=401wt.eu-S1761727AbZEFWw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727AbZEFWw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbZEFWvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:51:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55986 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbZEFWvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:51:16 -0400
Date: Wed, 6 May 2009 15:51:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-ID: <20090506225115.GM6771@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090506112459.5edd0902.akpm@linux-foundation.org> <20090502163423.GA1633@linux.vnet.ibm.com> <12234.1241558327@redhat.com> <20090506120909.GR25203@elte.hu> <11979.1241648574@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11979.1241648574@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 11:22:54PM +0100, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > More like "concerns".  It's unobvious to me that the modest .text
> > savings justify the costs of an additional RCU implementation.  Where
> > those costs include
> 
> It may be more than just modest .text savings.  Being optimised to be as
> simple as possible, and to only support one CPU, it may be quicker too.  I'm
> not sure how best to benchmark it though.

The read side is unchanged, but the update side is another story, given
that synchronize_rcu()'s latency decreases from multiple milliseconds
to the sub-microsecond range:

	void synchronize_rcu(void)
	{
		unsigned long flags;

		local_irq_save(flags);
		rcu_ctrlblk.completed++;
		local_irq_restore(flags);
	}

So boot speed is one possible metric, depending on how many synchronize_rcu()
invocations are in your arch's boot path.  It appears that x86 has a
fair number.  ;-)

							Thanx, Paul
