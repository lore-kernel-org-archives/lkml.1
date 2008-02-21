Return-Path: <linux-kernel-owner+w=401wt.eu-S1764916AbYBULbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764916AbYBULbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYBULbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:31:43 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:42234 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbYBULbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:31:42 -0500
Message-ID: <47BD600D.800@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 16:57:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com> <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com> <1203586980.6243.124.camel@lappy>  <47BD479F.6070901@linux.vnet.ibm.com> <1203588090.6243.128.camel@lappy>  <47BD4D48.4080606@linux.vnet.ibm.com> <1203592374.6243.138.camel@lappy>
In-Reply-To: <1203592374.6243.138.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-02-21 at 15:37 +0530, Balbir Singh wrote:
> 
>> You use the empty pointer (missing right child), so why do we need a list. May
>> be I am missing something.
> 
> A fully threaded tree also has back-pointer to traverse backwards
> through the ordered elements.
> 

The back pointer is implemented using missing left children. I am referring to
Don Knuth's volume 1: The art of computer programming, section 2.3.1, page 322.
Please see the threaded representation of the tree, it is compared with the
unthreaded representation.

> That said, overloading the right child pointer might not be the best
> thing for the linux kernel, as it will impact all the rb-tree lookups
> which are open-coded and often performance critical (this is the reason
> the colour isn't bit encoded in either of the child pointers either).
> 

We always look at the child, irrespective of whether it is to the right or left
to terminate our walk. Overloading them and setting a bit stating it is threaded
should not be that bad.

> But if you only want a uni directional thread, I guess we can stick it
> in the unsigned long we use for the node colour.
> 
> Still, perhaps it's worth it to grow rb_node to 4 words and do the fully
> threaded thing as there are also a lot of rb_prev() users in the kernel.
> Who knows..
> 

Why does the rb_node need to grow? We can encode the bits in the children

> Anyway, I agree that improving rb_next() is worth looking into for the
> scheduler.

Sure, will experiment and see if we can bump up performance.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
