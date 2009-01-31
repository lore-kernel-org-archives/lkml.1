Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZAaAEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZAaAEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZAaADw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:03:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbZAaADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:03:51 -0500
Date: Fri, 30 Jan 2009 16:03:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: roger.larsson@e-gatan.se, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rml@tech9.net, pavel@ucw.cz, netdev@vger.kernel.org
Subject: Re: PROBLEM: in_atomic() misuse all over the place
Message-Id: <20090130160316.7e53ef99.akpm@linux-foundation.org>
In-Reply-To: <87pri7k4id.fsf@basil.nowhere.org>
References: <200901280010.37633.roger.larsson@e-gatan.se>
	<87pri7k4id.fsf@basil.nowhere.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 13:18:50 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > file:  include/net/sock.h
> >
> >    static inline gfp_t gfp_any(void)
> >    {
> >      return in_atomic() ? GFP_ATOMIC : GFP_KERNEL;
> >    }
> 
> That's typically for softirq vs non softirq, which is important
> for the network stack.
> 

There's a bit of a problem here.  If someone accidentally uses
gfp_any() inside a spinlock, it will do a sleeping allocation on
non-preempt kernels and will do an atomic allocation on preemptible
kernels, so we won't get to see the warning which would allow us to fix
the bug.

Would using irq_count() work?  If so, that would fix this up.
