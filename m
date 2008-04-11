Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbYDKRPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbYDKRPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761260AbYDKRPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:15:36 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45444 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761102AbYDKRPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:15:35 -0400
Date: Fri, 11 Apr 2008 13:15:34 -0400
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080411171534.GO2158@csclub.uwaterloo.ca>
References: <20080411135544.GG2160@csclub.uwaterloo.ca> <OF861D7F24.6F60C82D-ON88257428.005C1DA4-88257428.005D5D80@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF861D7F24.6F60C82D-ON88257428.005C1DA4-88257428.005D5D80@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 09:59:45AM -0700, Bryan Henderson wrote:
> >So if you write multithreaded code and don't understand what locking
> >around shared resources is for, then your application might break.
> 
> I think I know what locking around shared resources is for, which is why 
> I'm surprised the kernel doesn't do it.
> 
> Is it normal for a kernel resource not to be thread-safe (i.e. you don't 
> get advertised/sensible results if two threads access it at the same 
> time)?

If two threads are changing one filehandle at the same time, then the
program is broken.  I can't see how the kernel making updates to 64bit
filehandles "atomic" helps.  You could still seek in one thread, then
seek in another and then start the write in the first and get a wrong
result.  Changes to a shared filehandle of any kind requires locking to
work reliably, so additional slow downs and locking in the kernel won't
fix anything.

> I could accept (though I haven't thought about it) that there aren't any 
> real-world applications that do simultaneous reads and writes through the 
> same file pointer.  I might even accept that there can be no useful 
> application that does.  But can you say such an application is incorrect?

Unless the application has it's own locking to ensure multiple threads
don't screw up each other's fileposition, it simply wouldn't work.

What is the difference between doing:

threadA: seek(positionA)
threadB: seel(positionB)
threadA: write
threadB: write

versus

threadA: seek(posisionA) but only set half the 64bits
threadB: seek(positionB) set all 64bits
threadA: complete seek operation setting the other half of the bits
threadA: write
threadB: write

either way you end up writing to the wrong file location even though the
first case the kernel made the setting of the fileposition atomic and in
the second case it wasn't.

The application has to do:
threadA: lock access to filehandle
threadA: seek(positionA)
threadB: try to get lock and wait
threadA: write
threadA: unlock
threadB: get lock finally
threadB: seek(positionB)
threadB: write
threadB: unlock

Once the application does locking, it doesn't matter if the setting of
the fileposition is atomic or not since no other thread can touch the
filehandle anyhow.

Doesn't matter if you read or write.  If it's a shared filehandle you
have only one current position so to share it you have to lock access
while doing a seek + read or write operation if you want predictable
results.

-- 
Len Sorensen
