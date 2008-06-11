Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYFKMy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYFKMy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYFKMyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:54:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYFKMyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:54:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [PATCH] Version 3: Reworked Cell OProfile: SPU mutex lock fix
Date: Wed, 11 Jun 2008 14:52:46 +0200
User-Agent: KMail/1.9.9
Cc: cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       acjohnso <acjohnso@us.ibm.com>
References: <1213139954.6763.244.camel@carll-linux-desktop>
In-Reply-To: <1213139954.6763.244.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111452.46619.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/5YXiWAX7bbw24iN5vl4rPfdLydJCXVxhyrrj
 3VKaHdwYND/XN7KsPyRHFzWbfBm4OEVEaZS7Lz0KAKXmgPpklt
 g7D+xHXjEqB9H+ErVHgDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008, Carl Love wrote:
> Arnd and company:
> 
> There are issues with using the cpu buffers for storing the SPU data.  I
> agree with you on some of your comments about the high complexity of the
> per cpu patch.  It seemed like a good idea at the start but in the end I
> am not all that happy with it.

Right, I agree. I assumed it would be enough to always write to the
local CPUs buffer, but as you explained, that caused other problems
that you had to work around.

Thanks for your detailed outline of your ideas, I think we're getting
much closer to a solution now!

> New approach, call it Single system wide buffer.

I like the approach in general, but would prefer to have it more generic,
so that other subsystems can use the same infrastructure if necessary:

> In arch/powerpc/oprofile/cell/spu_profiler.c,
> - Create a function to return the per cpu buffer size.
>
> - Create a single system wide buffer (call it SPU_BUFFER) to store the
> SPU context switch and SPU PC data.  The buffer would be an array of
> unsigned longs.  Currently the cpu buffer is a struct containing two
> unsigned longs.  The function would be called in function
> start_spu_profiling() as part of starting an SPU profiling session. The
> size of the buffer would be based on the size of the per cpu buffers * a
> scale factor for handling all of the spu data.

I think the dependency on the size of the per cpu buffers is a bit
artificial. How about making this independently tunable with
another oprofilefs file and a reasonable default?
You could either create the extra files in oprofile_create_files
or in oprofile_ops.create_files.

> - Create a function in arch/powerpc/oprofile/cell/spu_profiler.c that
> would be periodically called via a delayed workqueue call to flush
> SPU_BUFFER to the kernel buffer.  It would have to call the routine to
> get the kernel buffer mutex.  Grab the lock protecting writes to the
> SPU_BUFFER, flush the data to the kernel buffer and then release the
> locks. 
> 
> - Create a function to store data into the SPU_BUFFER.  It will be
> managed by a lock to ensure atomic access.  If the buffer fills, data
> will be dropped on the floor as is currently done when the per cpu
> buffer fills.  The cpu_buf->sample_lost_overflow stats would be
> incremented, as if we were using them, so the user would know that the
> buffer was not big enough.  We would keep the fact that we really are
> not using per cpu buffers transparent to the user.  The idea is the
> buffer size management would all look the same to the user.
> 
> In the driver/oprofile/buffer_sync.c function
> -Create a function to obtain the kernel buffer mutex lock.  
> - Create a second function to release the kernel buffer mutex lock.  
> - Make these two functions visible to the architecture specific code by
> exporting them in include/linux/oprofile.h.

As a general design principle, I'd always try to have locks close
to the data. What this means is that I think the SPU_BUFFER should
be in drivers/oprofile, similar to the cpu_buffer. In that case,
it may be better to change the name to something more generic, e.g.
aux_buffer.

Similar, moving data into the aux_buffer can be done under a spinlock
that is defined in the same file, with an interface like the
oprofile_add_value() function from your V3 patch, but moving the
add_value_lock in there.

> Pros single system wide buffer
> 1) It would not require changing existing architecture independent code
> to add the special data to a CPU buffer, move the special data to the
> kernel buffer, remove the code that was added so that the SPU profiling
> code does not enable the creation of the per cpu buffers.  Summary,
> minimal changing of architecture independent code

I don't think that's a requirement. I don't mind doing changes to
spufs or oprofile common code at all, as long as the change is
reasonable. This is especially true when there are potentially
other users that can benefit from the change.

> 2) The SPU_BUFFER size would be managed using the same user controls and
> feedback as the per cpu buffers.  The goal would be to make management
> look like we actually used cpu buffers.

As mentioned above, I'd see this as a disadvantage.

> 3) I think the overall kernel data storage space would be less.
> Currently, I have to increase the size of the cpu buffers, done in user
> land, by 8 times to handle the SPU data.  Since each entry in the
> SPU_BUFFER would be one unsigned long instead of two unsigned longs for
> cpu buffer we would save 2x here.  We would not have to have and escape
> sequence entry before each data sample that would save an additional 2x
> in space.

right

> 4) Do not have to manage mapping of SPUs to CPU buffers.  We don't care
> what the cpu or spu numbers are.

right

> 5) I think the memory storage could be adjusted better for SPU event
> profiling that I am working on.  

right.
 
> Cons
> 1) Currently OProfile does not support CPU hotplug.  Not sure how easy
> it would be or what issues there may be in supporting CPU hot plug with
> this approach.  Can't really say if it would be easier/harder then with
> per cpu buffers.

I think it would be harder, but if oprofile doesn't support it anyway,
let's not worry about it.

> 2) I think the cpu_buf stats are allocated when the module loads.  I
> think it is just the per cpu buffer allocation that is done dynamically
> when the daemon starts/shutdown.  I have not investigated this enough to
> say for sure.  If this is not the case, then we may need to tweek the
> generic oprofile code a bit more.

Both the event_buffer and the cpu_buffers are allocated in oprofile_setup
when the even buffer file is opened. When you have another buffer besides
the cpu_buffers, you can either change the oprofile_setup function to
allocate it, or do it in your setup() callback.

> 3) There is probably some other gotcha out there I have not thought of
> yet.  

None that I can think of.

	Arnd <><
