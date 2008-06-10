Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYFJXWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYFJXWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYFJXWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:22:03 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49136 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYFJXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:22:01 -0400
Subject: Re: [PATCH] Version 3: Reworked Cell OProfile: SPU mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, acjohnso <acjohnso@us.ibm.com>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 16:19:14 -0700
Message-Id: <1213139954.6763.244.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd and company:

There are issues with using the cpu buffers for storing the SPU data.  I
agree with you on some of your comments about the high complexity of the
per cpu patch.  It seemed like a good idea at the start but in the end I
am not all that happy with it.

I have another approach to solving this bug.  I will layout the approach
and then try to give the pros/cons of the proposed approach.  Hopefully
everyone will help out with the design so we can come up with something
that will address the issues that we have seen with the previous
approaches.  I think we are getting closer to an acceptable solution.
Maybe the fourth try will the the one.  :-)

New approach, call it Single system wide buffer.

In arch/powerpc/oprofile/cell/spu_profiler.c,
- Create a function to return the per cpu buffer size.

- Create a single system wide buffer (call it SPU_BUFFER) to store the
SPU context switch and SPU PC data.  The buffer would be an array of
unsigned longs.  Currently the cpu buffer is a struct containing two
unsigned longs.  The function would be called in function
start_spu_profiling() as part of starting an SPU profiling session. The
size of the buffer would be based on the size of the per cpu buffers * a
scale factor for handling all of the spu data.

- Create a function in arch/powerpc/oprofile/cell/spu_profiler.c that
would be periodically called via a delayed workqueue call to flush
SPU_BUFFER to the kernel buffer.  It would have to call the routine to
get the kernel buffer mutex.  Grab the lock protecting writes to the
SPU_BUFFER, flush the data to the kernel buffer and then release the
locks. 

- Create a function to store data into the SPU_BUFFER.  It will be
managed by a lock to ensure atomic access.  If the buffer fills, data
will be dropped on the floor as is currently done when the per cpu
buffer fills.  The cpu_buf->sample_lost_overflow stats would be
incremented, as if we were using them, so the user would know that the
buffer was not big enough.  We would keep the fact that we really are
not using per cpu buffers transparent to the user.  The idea is the
buffer size management would all look the same to the user.

In the driver/oprofile/buffer_sync.c function
-Create a function to obtain the kernel buffer mutex lock.  
- Create a second function to release the kernel buffer mutex lock.  
- Make these two functions visible to the architecture specific code by
exporting them in include/linux/oprofile.h.



Pros single system wide buffer
1) It would not require changing existing architecture independent code
to add the special data to a CPU buffer, move the special data to the
kernel buffer, remove the code that was added so that the SPU profiling
code does not enable the creation of the per cpu buffers.  Summary,
minimal changing of architecture independent code

2) The SPU_BUFFER size would be managed using the same user controls and
feedback as the per cpu buffers.  The goal would be to make management
look like we actually used cpu buffers.

3) I think the overall kernel data storage space would be less.
Currently, I have to increase the size of the cpu buffers, done in user
land, by 8 times to handle the SPU data.  Since each entry in the
SPU_BUFFER would be one unsigned long instead of two unsigned longs for
cpu buffer we would save 2x here.  We would not have to have and escape
sequence entry before each data sample that would save an additional 2x
in space.

4) Do not have to manage mapping of SPUs to CPU buffers.  We don't care
what the cpu or spu numbers are.

5) I think the memory storage could be adjusted better for SPU event
profiling that I am working on.  

Cons
1) Currently OProfile does not support CPU hotplug.  Not sure how easy
it would be or what issues there may be in supporting CPU hot plug with
this approach.  Can't really say if it would be easier/harder then with
per cpu buffers.

2) I think the cpu_buf stats are allocated when the module loads.  I
think it is just the per cpu buffer allocation that is done dynamically
when the daemon starts/shutdown.  I have not investigated this enough to
say for sure.  If this is not the case, then we may need to tweek the
generic oprofile code a bit more.

3) There is probably some other gotcha out there I have not thought of
yet.  


Any additional ideas, comments, concerns???  It would be nice if we
could flush out as many issues as possible now.

Thanks for your time and thought on this.

               Carl Love


