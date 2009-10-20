Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbZJTL6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbZJTL6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 07:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZJTL6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 07:58:44 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:58079 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZJTL6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 07:58:43 -0400
Message-ID: <4ADDA5EA.2060200@fr.ibm.com>
Date: Tue, 20 Oct 2009 13:58:34 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, jack@ucw.cz,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, andrea@cpushare.com,
       Alexey Dobriyan <adobriyan@gmail.com>, dlezcano@fr.ibm.com,
       mingo@elte.hu, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] pidns: Fix a leak in /proc inodes and dentries
References: <20091020041337.GA31623@us.ibm.com> <m1r5sywebv.fsf@fess.ebiederm.org>
In-Reply-To: <m1r5sywebv.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2009 12:27 PM, Eric W. Biederman wrote:
> Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> 
>> Fix a leak in /proc dentries and inodes with pid namespaces.
>>
>> This fix reverts the commit 7766755a2f249e7e0. The leak was reported by
>> Daniel Lezcano - see  http://lkml.org/lkml/2009/10/2/159.
>>
>> To summarize the thread, when container-init is terminated, it sets the
>> PF_EXITING flag and then zaps all the other processes in the container.
>> When those processes exit, they are expected to be reaped by the container-
>> init and as a part of reaping, the container-init should flush any /proc
>> dentries associated with the processes. But because the container-init is
>> itself exiting and the following PF_EXITING check, the dentires are not
>> flushed, resulting in leak in /proc inodes and dentries.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

there's indeed a lot of progress. A run of our C/R testsuite (spawning and
killing a few thousands pidns) used to leak ~700MB of slab, it's now gone. 
thanks suka for spending time on this. 

but we still have some minor leaks. below are contents of /proc/slabinfo 
before and after the run, you will notice that in some cases, dangling refs 
of nsproxy and pid_namespace are still alive. I wonder if there are some 
cases when this can happen, else I'll try to reproduce it.

Cheers,

C. 

* slabinfo.qemu (i686)

pid_namespace          0      0     64   59    1 
nsproxy                0      0     48   78    1 
proc_inode_cache     193    193   4096    1    1 
dentry              6734   6734   4096    1    1 

pid_2                  0      0     88   44    1 
pid_namespace          0      0     64   59    1 
nsproxy                0      0     48   78    1 
proc_inode_cache       4      4   4096    1    1 
dentry             36112  36112   4096    1    1 

* slabinfo.a13.test.meiosys.com (ppc64)

pid_namespace          0      0   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     506    513   4096    1    1 
dentry              6269   6272    280   14    1 

pid_2                  1     28    136   28    1 
pid_namespace          1      1   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     486    498   4096    1    1 
dentry             49051  49448    280   14    1 


* slabinfo.f13.test.meiosys.com (ppc64)

pid_namespace          0      0   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     248    263   4096    1    1 
dentry              7359   7364    280   14    1 

pid_2                  0      0    136   28    1 
pid_namespace          0      0   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     240    240   4096    1    1 
dentry             50253  50666    280   14    1 


* slabinfo.r3-23.test.meiosys.com (x86_64)

pid_namespace          0      0   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     479    495   4096    1    1 
dentry              5614   5614    280   14    1 

pid_2                  1     28    136   28    1 
pid_namespace          1      1   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     576    576   4096    1    1 
dentry             52202  52444    280   14    1 


* slabinfo.r3-24.test.meiosys.com (x86_64)

pid_namespace          0      0   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     464    486   4096    1    1 
dentry              5698   5698    280   14    1 

pid_2                  0      0    136   28    1 
pid_namespace          0      0   4096    1    1 
nsproxy                0      0     72   53    1 
proc_inode_cache     448    448   4096    1    1 
dentry             51845  52164    280   14    1 


* slabinfo.r3-26.test.meiosys.com (i686)

pid_namespace          0      0     64   59    1 
nsproxy                0      0     48   78    1 
proc_inode_cache     449    466   4096    1    1 
dentry              5633   5633   4096    1    1 

pid_2                  0      0     88   44    1 
pid_namespace          0      0     64   59    1 
nsproxy                0      0     48   78    1 
proc_inode_cache     448    448   4096    1    1 
dentry             52039  52039   4096    1    1 


* slabinfo.linuz12 (s390x)

pid_namespace          0      0   2112    3    2 
nsproxy                0      0     48   77    1 
proc_inode_cache     725    798    640    6    1 
dentry              4340   4340    192   20    1 

pid_2                  1     30    128   30    1 
pid_namespace          1      3   2112    3    2 
nsproxy                1     77     48   77    1 
proc_inode_cache      74    180    640    6    1 
dentry             34511  36820    192   20    1 
