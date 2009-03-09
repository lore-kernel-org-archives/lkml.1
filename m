Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZCIUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZCIUdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZCIUcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:32:55 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43565 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbZCIUcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:32:54 -0400
Message-ID: <49B57CB0.5020300@cosmosbay.com>
Date: Mon, 09 Mar 2009 21:31:44 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit
 to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>	<49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 09 Mar 2009 21:31:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer a écrit :
> Avi Kivity <avi@redhat.com> writes:
> 
>> Jeff Moyer wrote:
>>> Hi,
>>>
>>> Believe it or not, I get numerous questions from customers about the
>>> suggested tuning value of aio-max-nr.  aio-max-nr limits the total
>>> number of io events that can be reserved, system wide, for aio
>>> completions.  Each time io_setup is called, a ring buffer is allocated
>>> that can hold nr_events I/O completions.  That ring buffer is then
>>> mapped into the process' address space, and the pages are pinned in
>>> memory.  So, the reason for this upper limit (I believe) is to keep a
>>> malicious user from pinning all of kernel memory.  Now, this sounds like
>>> a much better job for the memlock rlimit to me, hence the following
>>> patch.
>>>   
>> Is it not possible to get rid of the pinning entirely?  Pinning
>> interferes with page migration which is important for NUMA, among
>> other issues.
> 
> aio_complete is called from interrupt handlers, so can't block faulting
> in a page.  Zach mentions there is a possibility of handing completions
> off to a kernel thread, with all of the performance worries and extra
> bookkeeping that go along with such a scheme (to help frame my concerns,
> I often get lambasted over .5% performance regressions).

This aio_completion from interrupt handlers keep us from using SLAB_DESTROY_BY_RCU
instead of call_rcu() for "struct file" freeing.

http://lkml.org/lkml/2008/12/17/364

I would love it we could get rid of this mess...


