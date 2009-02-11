Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZBKSva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZBKSva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZBKSvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:51:21 -0500
Received: from gw.goop.org ([64.81.55.164]:38124 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZBKSvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:51:21 -0500
Message-ID: <49931E24.6080409@goop.org>
Date: Wed, 11 Feb 2009 10:51:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stuart Bennett <stuart@freedesktop.org>,
       Oliver McFadden <z3ro.geek@gmail.com>,
       david jeannot <djeannot24@gmail.com>
Subject: Re: testing pmdval/pteval page presence bit
References: <20090209215849.5a788261@daedalus.pq.iki.fi>	<499202F0.10108@goop.org> <20090211200832.016d3e59@daedalus.pq.iki.fi>
In-Reply-To: <20090211200832.016d3e59@daedalus.pq.iki.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen wrote:
> This is good to know. So far these are kernel mappings, as they are all
> created by ioremap*(), but there are plans to extend mmiotrace to
> trace IO-mappings accessed from user space. Do you have hints for that?
>   

Set _PAGE_PROTNONE, which will make the kernel logically treat it as a 
present pte with no page permissions, which is what you're doing.  Bear 
in mind that _PAGE_PROTNONE is overloaded with _PAGE_GLOBAL, so you'll 
need to make sure you restore that properly too (kernel mappings are 
generally global).

On the other hand, I assume you intercept mmiotrace faults fairly early 
in the fault handler, so that path shouldn't ever see an unexpected 
not-present pte.  But other code, like mprotect, mlock, etc, may inspect 
those ptes and get a nasty surprise if it sees them non-present.

(What happens if someone uses mprotect on a mapping that mmiotrace has 
made non-present?)

> OTOH, we are always dealing with PCI IO-mem-mappings, so would those ever
> be not present, excluding the mmiotrace case?
>
> Well, Stuart already found out that the kernel ioremap*()'ed pages might
> not really be present, there are some fixes coming up to mmiotrace to
> cope with that. The plan is to restore the state of the pte like it was
> before mmiotrace cleared the _PAGE_PRESENT flag, and if the same
> instruction and address faults again, fall through to the normal page
> fault handling. How can/will this fail? And if it is a user page?
>   

My main concern is non-fault handler code which looks at ptes.  How will 
it know what its looking at if mmiotrace has fiddled with the state?

    J
