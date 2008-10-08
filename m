Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYJHIgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYJHIgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYJHIgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:36:01 -0400
Received: from smtp2e.orange.fr ([80.12.242.113]:51979 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbYJHIf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:35:59 -0400
X-ME-UUID: 20081008083557478.74CFE70000B9@mwinf2e18.orange.fr
Message-ID: <48EC7003.4040108@cosmosbay.com>
Date: Wed, 08 Oct 2008 10:32:03 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
 arch
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>	 <20081007105056.16d9e785.akpm@linux-foundation.org>	 <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>	 <200810081335.44576.nickpiggin@yahoo.com.au>	 <6.0.0.20.2.20081008132532.056cc400@172.19.0.2> <1223448711.1378.16.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223448711.1378.16.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> On Wed, 2008-10-08 at 13:48 +0900, Hisashi Hifumi wrote:
> 
>> Simultaneous access by two or more writer can corrupt file content,
>> so this case needs some locks(flock or fcntl) to preserve synchronization
>> of file content. This is responsibility of user-space application.
>> But file->f_pos race issue can occur even if multiple threads just read 
>> simultaneously. I think this is not responsibility of user-space application. 
>> To avoid this currently, an application needs some locks to protect file offset
>> even if it just read a file. So I think f_pos race should be fixed.
> 
> Just to add to all those who already said you're wrong :-)
> 
> You're wrong, if two threads would like to read the same file they
> either dup() the fd or open() the file twice. There is absolutely no
> valid reason to have two threads read from the same fd without
> synchronising their access to it - never.
> 

About dup() syscall, it wont help, since old and new descriptor points to
the same "struct file", definitly sharing file position, since first Unixes.

To quote the fine manual :

       After successful return of dup or dup2, the old and new descriptors may
       be used interchangeably. They share locks, file position  pointers  and
       flags;  for example, if the file position is modified by using lseek on
       one of the descriptors, the position is also changed for the other.


pread()/pwrite() are used my multi-threaded applications that want to share
a single "struct file". Or they must use some form of synchronization around
regular read()/write()/lseek() calls.

There is no generic f_pos race, only buggy applications.

A far more interesting problem is the "tail -f logfile" problem that raised
recently in lkml, when file is NFS mounted, where reader can get nul bytes...
(Subject : blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20 )





