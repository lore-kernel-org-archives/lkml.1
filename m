Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbXDMAeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbXDMAeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXDMAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:34:31 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:37626 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753945AbXDMAea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:34:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5Ti5Mgpgeg0IMxVx4Y6TjJ+vZAARjM6Kzu2mMytO4kI0Ws9MlZxzOHzPdV/qSdpogVnqG6i7Ikza8dKqSCAJWJAGSgc3/dxFeRBpvzHOhMyiMVT99S/PzCo2dUzoHK70jSdbBDiQ+dpzBX+VBIAQYYtmwvMULHp/73LMt+RfVxU=  ;
X-YMail-OSG: Z_eoFJsVM1mRmghKoTNOz6pOlqEalSlUwAId7UcuHsOxhGQLp8SgLBJWrRdEumhi46WRPOW17g--
Message-ID: <461ED00E.1090808@yahoo.com.au>
Date: Fri, 13 Apr 2007 10:34:22 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com> <461DC75B.8040200@cosmosbay.com> <461DCCEB.70004@yahoo.com.au> <461DCDDA.2030502@yahoo.com.au> <461DDE44.2040409@redhat.com> <461E30A6.5030203@yahoo.com.au> <461E9D77.4080308@redhat.com>
In-Reply-To: <461E9D77.4080308@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Nick Piggin wrote:
> 
>>> The lazy freeing is aimed at avoiding page faults on memory
>>> that is freed and later realloced, which is quite a common
>>> thing in many workloads.
>>
>>
>> I would be interested to see how it performs and what these
>> workloads look like, although we do need to fix the basic glibc and
>> madvise locking problems first.
> 
> 
> The attached graph are results of running the MySQL sysbench
> workload on my quad core system.  As you can see, performance
> with #threads == #cpus (4) almost doubles from 1070 transactions
> per second to 2014 transactions/second.
> 
> On the high end (16 threads on 4 cpus), performance increases
> from 778 transactions/second on vanilla to 1310 transactions/second.
> 
> I have also benchmarked running Ulrich's changed glibc on a vanilla
> kernel, which gives results somewhere in-between, but much closer to
> just the vanilla kernel.

Looks like the idle time issue is still biting for those guys.

Hmm, maybe MySQL is actually _touching_ the memory inside a more
critical lock, so the faults get tangled up on mmap_sem there. I
wonder if making malloc call memset right afterwards would hide
that ;) Or the madvise exclusive mmap_sem avoidance.

Seems like with perfect scaling we should get to the 2400 mark.
It would be nice to be able to not degrade under load. Of course
some of that will be MySQL scaling issues.

-- 
SUSE Labs, Novell Inc.
