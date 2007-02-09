Return-Path: <linux-kernel-owner+w=401wt.eu-S1946403AbXBIMYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946403AbXBIMYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946407AbXBIMYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:24:40 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50399 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946403AbXBIMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:24:39 -0500
Message-ID: <45CC68BA.4010403@bull.net>
Date: Fri, 09 Feb 2007 13:27:38 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>	<20070116063030.761795000@bull.net>	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net> <m1mz3poeda.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1mz3poeda.fsf@ebiederm.dsl.xmission.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 09/02/2007 13:25:44,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 09/02/2007 13:25:47,
	Serialize complete at 09/02/2007 13:25:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nadia Derbey <Nadia.Derbey@bull.net> writes:
> 
> 
>>2) why autotuning:
>>There are at least 3 cases where it can be useful
>>. for workloads that are known to need a big amount of a given resource type
>>(say shared memories), but we don't know what the maximum amount needed will be
>>. to solve the case of multiple applications running on a single system, and
>>that need the same tunable to be adjusted to feet their needs
>>. to make a system correctly react to eventual peak loads for a given resource
>>usage, i.e. make it tune up *and down* as needed.
> 
> 
>>In all these cases, the akt framework will enable the kernel to adapt to
>>increasing / decreasing resource consumption:
>>1) avoid allocating "a priori" a big amount of memory that will be used only in
>>extreme cases. This is the effect of doing an "echo <huge_value>
>>
>>>/proc/sys/kernel/shmmni"
>>
>>2) the system will come back to the default values as soon as the peak load is
>>over.
> 
> 
> At least the ipc ones are supposed to be DOS limits not behavior
> modifiers.  I do admit from looking at the code that there are some
> consequences of increasing things like shmmni.  However I think we
> would be better off with  better data structures and implementations
> that remove these consequences than this autotuning of
> denial-of-service limits.
> 

I do not fully agree with you:
It is true that some ipc tunables play the role of DoS limits.
But IMHO the *mni ones (semmni, msgmni, shmmni) are used by the ipc 
subsystem to adapt its data structures sizes to what is being asked for 
through the tunable value. I think this is how they manage to take into 
account a new tunable value without a need for rebooting the system: 
reallocate some more memory on demand.

Now, what the akt framework does, is that it takes advantage of this 
concept of "on demand memory allocation" to replace a user (or a daemon) 
that would periodically check its ipcs consumptions and manually adjust 
the ipcs tunables: Doing this from the user space would imply a latency 
that makes it difficult to react fast enough to resources running out.

Now, talking about DoS limits, akt implements them in a sense: each 
tunable managed by akt has 3 attributes exported to sysfs:
. autotune: enable / disable auto-tuning
. min: min value the tunable can ever reach
. max: max value the tunable can ever reach

Enabling a sysadmin to play with these min and max values makes it 
possible to refine the dynamic adjustment, and avoid that the tunable 
reaches really huge values.

Regards,
Nadia

