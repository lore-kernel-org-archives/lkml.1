Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXGMDrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXGMDrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbXGMDrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:47:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:55656 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbXGMDq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=f/ZKycxSd7YQmw++pqEVuGWO5OZTODmzaK3xLkKRKzSH0Sy8LE9lUp1QrGm32uJIoNuLIToljRNAeNhocQ2uXcgoy+9pPvChFP4xg6gur26mwVuby2HnEeW9BnJ1xvksWJ/rBVkFe3h+lPZ3FXmzYtKjbPgaRCe0BmwwGZnCMiU=
Message-ID: <4696F5AD.1050306@gmail.com>
Date: Fri, 13 Jul 2007 12:46:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jim.houston@ccur.com, Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       raisch@de.ibm.com, Kristian Hoegsberg <krh@redhat.com>
Subject: Re: [PATCH] fix idr_get_new_above id alias bugs
References: <200707021919.27251.hnguyen@linux.vnet.ibm.com>	<1183422700.3130.27.camel@localhost.localdomain>	<200707041611.30056.hnguyen@linux.vnet.ibm.com>	<1184097931.3020.73.camel@localhost.localdomain> <20070712143501.2c2cdf1f.akpm@linux-foundation.org>
In-Reply-To: <20070712143501.2c2cdf1f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
>> Hoang-Nam Nguyen reported a bug in idr_get_new_above() 
>> which occurred with a starting id value like 0x3ffffffc.
>> His test module easily reproduced the problem.  Thanks.
>>
>> The test revealed the following bugs:
>>
>> 1. Relying on shift operations which have undefined results
>>    e.g.: 1 << n where n > word size.  On i386 an integer shift
>>    only uses the low 5 bits of the shift count.
>>
>> 2. An off by one error which prevented the top most layer
>>    of the radix tree from being allocated.  This meant that
>>    sub_alloc() would allocate an entry in the existing portion
>>    of the radix tree which aliased the requested address.  When
>>    it tried to allocate id 0x40000000, it might use the slot 
>>    belonging to id 0.
>>
>> 3. There was also a failure in the code which walked back up
>>    the tree if an allocation failed.  The normal case is to
>>    descend the tree checking the starting id value against the
>>    bitmap at each level.  If the bit is set, we know that the
>>    entire sub-tree is full and we can short cut the search.
>>    We may still descend to the lowest level and find that the
>>    portion of the id space we want is full.  In this case we
>>    need to walk back up the tree and continue the search.
>>    The existing code just returned to the previous level and
>>    continued.  This resulted in an attempt to allocate an id
>>    above 0x3ffffffc using the slot for id 0x3ffffc00 instead of
>>    0x40000000 which it then claimed to have allocated.  The same
>>    problem occurs with 0x3ff as the requested id value if it
>>    is already in use.

The third one sounds like the bug I fixed.  With it fixed, I verified
idr works correctly at least in the lower range of allocation by running
it parallelly with simple bitmap allocator but haven't tested higher
range like 0x3ffffffc.

-- 
tejun
