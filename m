Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZFEDfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZFEDfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFEDfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:35:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44515 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZFEDff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:35:35 -0400
Message-ID: <4A28921C.6010802@redhat.com>
Date: Fri, 05 Jun 2009 06:33:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com>
In-Reply-To: <20090605030309.GA3872@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
>> Another way is to place the 8 groups in a container group, and limit  
>> that to 80%. But that doesn't work if I want to provide guarantees to  
>> several groups.
>>     
>
> Hmm why not ? Reduce the guarantee of the container group and provide
> the same to additional groups ?
>   

This method produces suboptimal results:

$ cgroup-limits 10 10 0
[50.0, 50.0, 40.0]

I want to provide two 10% guaranteed groups and one best-effort group.  
Using the limits method, no group can now use more than 50% of the 
resources.  However, having the first group use 90% of the resources 
does not violate any guarantees, but it not allowed by the solution.

#!/usr/bin/python

def calculate_limits(g, R):
    N = len(g)
    if N == 1:
        return [R]

    s = sum([R - gi for gi in g])
    return [(s - (R - gi) - (N - 2) * (R - gi)) / (N - 1)
            for gi in g]

import sys
print calculate_limits([float(x) for x in sys.argv[1:]], 100)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

