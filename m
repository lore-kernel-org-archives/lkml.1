Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXC1BXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXC1BXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 21:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965574AbXC1BXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 21:23:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49052 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965576AbXC1BXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 21:23:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=ZKIG5NXgMpwQD5Dv2hwc7BgCHKYMcisDCQAYl6gl0eh0pbKxT2ahpcCIRlYvDXhY9
	/Ycst+6Yysfr8v4Ml5cCg==
Message-ID: <4609C33A.1040907@google.com>
Date: Tue, 27 Mar 2007 18:22:02 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dave Hansen <hansendc@us.ibm.com>
Subject: Re: Linux-VServer example results for sharing vs. separate mappings
 ...
References: <20070323193000.GB17007@MAIL.13thfloor.at> <20070323214235.94a3e899.akpm@linux-foundation.org> <20070324183806.GA7312@MAIL.13thfloor.at> <20070324121906.aff91c93.akpm@linux-foundation.org> <20070325022156.GA12442@MAIL.13thfloor.at>
In-Reply-To: <20070325022156.GA12442@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Poetzl wrote:
> On Sat, Mar 24, 2007 at 12:19:06PM -0800, Andrew Morton wrote:
>   
>> Or change the reclaim code so that a page which hasn't
>> been referenced from a process within its hardware
>> container is considered unreferenced (so it gets reclaimed). 
>>     
>
> that might easily lead to some ping-pong behaviour,
> when two similar guest are executing similar binaries
> but not at the same time ...
>   

    It might lead to that, but I don't think it would become 
pathological "easily". If a system has been up for a long time, it's 
easy to image pagecache pages lying everywhere just because someone 
somewhere is still using them.

    I suggest a variant on what Andrew says: don't change reclaim. 
Instead, when referencing a page, don't mark the page as referenced if 
the current task is not permitted to allocate from the page's node. I'm 
thinking in terms of cpusets, with each task having a nodemask of 
mems_allowed. This may result in a page being thrown out unnecessarily 
and brought back in from disk, but when memory is tight that is what 
happens. An optimization might be to keep track of who is referencing 
the page and migrate it to their memory instead of reclaiming it, but 
that would require reclaim to know the task/cpuset/container of the 
referencing task.
    -- Ethan

