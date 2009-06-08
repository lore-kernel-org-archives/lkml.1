Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZFHFXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZFHFXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 01:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZFHFXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 01:23:43 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:42906
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbZFHFXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 01:23:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABM9LEp8qWf0/2dsb2JhbADKFoQKBQ
X-IronPort-AV: E=Sophos;i="4.41,322,1241366400"; 
   d="scan'208";a="456610185"
Message-ID: <4A2CA05C.3060808@themaw.net>
Date: Mon, 08 Jun 2009 13:23:40 +0800
From: Ian Kent <raven@themaw.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] autofs4 - remove hashed check in validate_wait()
References: <20090608032537.7088.1870.stgit@zeus.themaw.net> <20090607220814.cc7519f6.akpm@linux-foundation.org>
In-Reply-To: <20090607220814.cc7519f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 08 Jun 2009 11:25:37 +0800 Ian Kent <raven@themaw.net> wrote:
> 
>> The recent ->lookup() deadlock correction required the directory
>> inode mutex to be dropped while waiting for expire completion. We
>> were concerned about side effects from this change and one has
>> been identified.
>>
>> When checking if a mount has already completed prior to adding a
>> new mount request to the wait queue we check if the dentry is hashed
>> and, if so, if it is a mount point. But, if a mount successfully
>> completed while we slept on the wait queue mutex the dentry must
>> exist for the mount to have completed so the test is not really
>> needed.
>>
>> Mounts can also be done on top of a global root dentry, so for the
>> above case, where a mount request completes and the wait queue entry
>> has already been removed, the hashed test returning false can cause
>> an incorrect callback to the daemon. Also, d_mountpoint() is not
>> sufficient to check if a mount has completed for the multi-mount
>> case when we don't have a real mount at the base of the tree.
>>
> 
> I've been scratching my head trying to work out if this is a
> needed-in-2.6.30 fix, but all I got was a bald spot.  Help?

Yeah, and why would you want to know that much about autofs, it's a
wonder I have any hair at all, ;)

I think so if possible, as it resolves an issue that is a side effect of
the last patch I sent, which resolved a deadlook in ->lookup(). The
problem occurs due to dropping the directory inode mutex before waiting
for an expire. What isn't obvious is that holding the mutex (as we did
previously) causes processes wanting to request mounts for other
directories to wait, so we don't see the contention for the mount
request wait queue that this patch addresses.

However, the issue only surfaces when there are a number of processes
all trying to perform mounts at the same time. The test I ran used 10
processes all using the same map.

Ian
