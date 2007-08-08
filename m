Return-Path: <linux-kernel-owner+w=401wt.eu-S965213AbXHHVOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213AbXHHVOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934074AbXHHVOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:14:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763241AbXHHVOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:14:32 -0400
Message-ID: <46BA30DC.20207@redhat.com>
Date: Wed, 08 Aug 2007 17:08:44 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>, andi@firstfloor.org
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au
Subject: Re: [patch] ipvs: force read of atomic_t in while loop
References: <20070808093300.GA14530@osiris.boeblingen.de.ibm.com> <20070808.032131.35507346.davem@davemloft.net> <20070808102835.GC14530@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070808102835.GC14530@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Wed, Aug 08, 2007 at 03:21:31AM -0700, David Miller wrote:
>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Date: Wed, 8 Aug 2007 11:33:00 +0200
>>
>>> Just saw this while grepping for atomic_reads in a while loops.
>>> Maybe we should re-add the volatile to atomic_t. Not sure.
>> I think whatever the choice, it should be done consistently
>> on every architecture.
>>
>> It's just asking for trouble if your arch does it differently from
>> every other.
> 
> Well..currently it's i386/x86_64 and s390 which have no volatile
> in atomic_t. And yes, of course I agree it should be consistent
> across all architectures. But it isn't.

Based on recent discussion, it's pretty clear that there's a lot of 
confusion about this.  A lot of people (myself included, until I thought 
about it long and hard) will reasonably assume that calling 
atomic_read() will actually read the value from memory.  Leaving out the 
volatile declaration seems like a pessimization to me.  If you force 
people to use barrier() everywhere they're working with atomic_t, it 
will force re-reads of all the non-atomic data in use as well, which 
will cause more memory fetches of things that generally don't need 
barrier().  That and it's a bug waiting to happen.

Andi -- your thoughts on the matter?
