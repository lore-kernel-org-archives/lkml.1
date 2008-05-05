Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbYEETBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbYEETBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbYEETA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:00:59 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36850 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759293AbYEETA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:00:58 -0400
Message-ID: <481F5965.6070305@sgi.com>
Date: Mon, 05 May 2008 12:00:53 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: arges@linux.vnet.ibm.com
CC: phil.el@wanadoo.fr, mpjohn@us.ibm.com,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Hotplug CPU support for Oprofile
References: <1210012443.6374.23.camel@snuffleupagus>
In-Reply-To: <1210012443.6374.23.camel@snuffleupagus>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding some possibly interested parties to the cc line.]

Chris J Arges wrote:
> Mike,
> I was wondering what your rationale behind using per_cpu variables for
> the cpu buffers in oprofile versus using percpu_alloc, percpu_free?
> For instance:
> 
>         DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer,
>         cpu_buffer);
> 
>         void free_cpu_buffers(void)
>         {
>                 int i;
>         
>                 for_each_online_cpu(i)
>                         vfree(per_cpu(cpu_buffer, i).buffer);
>         
>         }
> 
> Could it be possible to write it like this:
>         
>         ﻿struct oprofile_cpu_buffer *cpu_buffer;
>         
>         void free_cpu_buffers(void)
>         {
>         	percpu_free(cpu_buffer);
>         }
> 

        
Hi Chris,

There was no particular reason for one or the other.  We did have a
patch a few months ago that added CPU_ALLOC functionality that was
much cleaner than percpu_alloc (and replaced it), but due to
circumstances it didn't actually make it into the source base.
The percpu approach was the fallback.

> 
> Phillipe, Mike,
> I am currently working on a patch for enabling hotplug cpu support for
> oprofile as currently oprofile crashes whenever cpus are onlined of
> offlined. So far my patch registers a callback function for hotplug
> events, and checked if a cpu has been onlined/offlined and then
> allocs/frees a cpu buffer accordingly. 
> 
> I am wondering if you have any further recommendations as to approaching
> adding hotplug support. I am still fairly new to oprofile/linux kernel
> but I would like to contribute, please forgive any newbie mistakes.
> Thanks!
> 

Other than insuring that any routines for bringing up/tearing down
processors are in the __cpuinit/data sections and test as many
different configs as you can.

Also, increasing NR_CPUS to 4096 is one thing but I've been testing
with "possible" cpus == 4096 and have hit some snags.  The biggest
right now is the enormous amount of memory that the kernel tracing
facility requires.  So trying out your code with a healthy amount of
possible cpus will expose problems like this.

Another thing that I've encountered is that you can add "additional_cpus"
to the boot line, and the BIOS can signal that there are cpus present
but currently disabled, but there's no way to bring these cpus online
after bootup.

One thought would be to register the cpu but make it offline.  This
has some advantages but it was felt that instead something more like:

echo '32-63' > /sys/devices/system/cpu/online

would startup and register cpus 32-63.  This is orthogonal to the
showing of which cpu's are online:

# cat /sys/devices/system/cpu/online
0-31

Any suggestions along this area are welcome!

Thanks,
Mike
