Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXKQM4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXKQM4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 07:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXKQM4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 07:56:11 -0500
Received: from mx1.suse.de ([195.135.220.2]:49019 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbXKQM4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 07:56:09 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, netdev@vget.kernel.org
Subject: Re: [NET]: rt_check_expire() can take a long time, add a cond_resched()
From: Andi Kleen <andi@firstfloor.org>
References: <200711150401.lAF41mSs021898@hera.kernel.org>
	<20071115193802.4ec64eef@laptopd505.fenrus.org>
	<473D131A.5000200@cosmosbay.com> <473D18A5.2090309@cosmosbay.com>
	<20071115215938.44233733@laptopd505.fenrus.org>
Date: Sat, 17 Nov 2007 13:56:08 +0100
In-Reply-To: <20071115215938.44233733@laptopd505.fenrus.org> (Arjan van de Ven's message of "Thu\, 15 Nov 2007 21\:59\:38 -0800")
Message-ID: <p73k5ohav4n.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>> > 
>> > Its not that cheap. The ChangeLog included my own numbers, on a
>> > Pentium M machine. (i686, 1.6 GHz, 1.5 GB ram)
>> > 
>> > Without "if (need_resched())" (so calling need_resched() X.XXX.XXX 
>> > times), each run takes 88ms
>> > 
>> > With the extra check (and *much* less function calls), each run
>> > takes 25ms

ms?!? The numbers sound wrong. Wrong unit? 

>> > 
>> 
>> Looking at cond_resched(), I think the extra cost comes from
>> "mov %esp,%edx ; and $0xffffe000,%edx" (current_thread_info())
>> 
>> I dont have oprofile numbers yet, but I suspect CPU may have some
>> delays to compute this pointer value, since %esp is probably 'busy'
>> because of the preceding "call"
>
> yeah the explicit reference makes the stack pointer tracking engine do a
> commit I suspect which then also creates a data dependency in the code
> flow.
>
> however... this is likely a good argument for making cond_resched() as a
> whole a #define (or inline) that does this test and then calls the out
> of line code (which then doesn't need to retest, so it avoids the
> double test)...

Disadvantage would be that might_sleep would be commonly skipped then
(unless you actually need to reschedule) 
But perhaps that's not a big issue.

-Andi

