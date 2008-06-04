Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYFDORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYFDORU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYFDORJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:17:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37300 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752606AbYFDORI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:17:08 -0400
Message-ID: <4846A3DF.8090109@sgi.com>
Date: Wed, 04 Jun 2008 07:17:03 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <484691CB.6090809@goop.org> <48469D30.40901@sgi.com> <48469F71.4080303@goop.org>
In-Reply-To: <48469F71.4080303@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>> Jeremy Fitzhardinge wrote:
>>  
>>> Mike Travis wrote:
>>>    
>>>>   * Declare the pda as a per cpu variable.
>>>>
>>>>   * Make the x86_64 per cpu area start at zero.
>>>>
>>>>   * Since the pda is now the first element of the per_cpu area,
>>>> cpu_pda()
>>>>     is no longer needed and per_cpu() can be used instead.  This also
>>>> makes
>>>>     the _cpu_pda[] table obsolete.
>>>>
>>>>   * Since %gs is pointing to the pda, it will then also point to the
>>>> per cpu
>>>>     variables and can be accessed thusly:
>>>>
>>>>     %gs:[&per_cpu_xxxx - __per_cpu_start]
>>>>
>>>>       
>>
>>   The above is only a partial story (I folded the two patches but didn't
>> update the comments correctly.]  The variables are already offset from
>> __per_cpu_start by virtue of the .data.percpu section being based at
>> zero.  Therefore only the %gs register needs to be set to the base of
>> each cpu's percpu section to resolve the target address:
>>
>>         %gs:&per_cpu_xxxx
>>   
> 
> Oh, good.  I'd played with trying to make that work at one point, and
> got lost in linker bugs and/or random version-specific strangeness.
>    J

Incidentally, this is why the following load is needed in x86_64_start_kernel():

        pda = (struct x8664_pda *)__per_cpu_load;
        pda->data_offset = per_cpu_offset(0) = (unsigned long)pda;

        /* initialize boot cpu_pda data */
        pda_init(0);

pda_init() loads the %gs reg so early accesses to the static per_cpu section
can be executed before the percpu areas are allocated.

