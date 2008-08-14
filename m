Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYHNQiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYHNQiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNQiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:38:13 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:46413 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYHNQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=j+WzFsIp8lO2uQvXmBveBINEdfvZ/n+L/JpP/jgz2yVU0Ug10wOgbn6vdLCMp3qNdj
         5iK5gGKEI0fzYuekIW2J08KzLf0AVnpyKt7n+DRpnAXUIhyeZ31qDQ4MugICM77+L1Dn
         OS3lI4VxHpVVQMNBGKCq7DrgYms3QzoKlWOSI=
Date: Thu, 14 Aug 2008 19:35:04 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
	writing to a CPU buffer.
Message-ID: <20080814163504.GA5478@localhost>
References: <20080613040947.7465b9a5@linux360.ro> <1213418437.8237.51.camel@charm-linux> <20080614175223.4d3c6084@linux360.ro> <1213593748.7744.34.camel@charm-linux> <20080621050632.4a7a6c16@linux360.ro> <1216876176.6392.38.camel@charm-linux> <20080730174821.GA5222@localhost> <1218608219.8980.92.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218608219.8980.92.camel@charm-linux>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:16:59AM -0500, Tom Zanussi wrote:
> 
> Hi,

Hi,

> You shouldn't have to use poll() with infinite timeout - see for example
> the blktrace user code.  I'm not sure why you're seeing these problems,
> but if you're interested, even if only for comparison, you can try using
> the blktrace user code for kmemtrace too - I recently turned the
> blktrace userspace code into a generic tracing library called libutt,
> which you can get here:
> 
> http://utt.sourceforge.net
> 
> Here are some patches to your code that take a first stab at kmemtrace
> using utt:
> 
> http://utt.sourceforge.net/kmemtrace-utt-kernel.patch
> http://utt.sourceforge.net/kmemtrace-utt-user.patch

Thanks a lot, I'll have a look at them and try this instead.

> Most of the kernel patch just adds tracing controls for the purpose of
> controlling the trace:
> 
> root@positron:/home/trz/kmemtrace-user# ls -al /sys/kernel/debug/kmem/trace
> total 0
> drwxr-xr-x 2 root root       0 2008-08-12 22:48 .
> drwxr-xr-x 3 root root       0 2008-08-12 22:48 ..
> -r-------- 1 root root       0 2008-08-12 22:48 abi_version
> ---------- 1 root root       0 2008-08-12 22:48 buf_nr
> ---------- 1 root root       0 2008-08-12 22:48 buf_size
> ---------- 1 root root       0 2008-08-12 22:48 create
> ---------- 1 root root       0 2008-08-12 22:48 destroy
> -r--r--r-- 1 root root       0 2008-08-12 22:48 dropped
> ---------- 1 root root       0 2008-08-12 22:48 event_mask
> ---------- 1 root root       0 2008-08-12 22:48 start
> ---------- 1 root root       0 2008-08-12 22:48 stop
> -r-------- 1 root root 9175040 2008-08-12 22:48 trace0
> -r-------- 1 root root 1543192 2008-08-12 22:48 trace1
> 
> You'll also notice that the directory structure is a little different
> (/sys/kernel/debug/kmem/trace instead of /sys/kernel/debug/kmemtrace)
> and that the per-cpu files are named traceX instead of cpuX - this is
> just because it follows the blktrace conventions.
> 
> The other change to the kernel code is that it allows the buffers (and
> buffer sizes) to be created on demand instead of always allocated at
> boot time.  The boot-time buffer and tracing still works as before, but
> it actually turns tracing off in kmem_setup_late(), since there's really
> no point in continuing logging and overrunning the buffers until
> kmemtraced is started up to read it.  Having the buffers allocated and
> tracing started by kmemtraced also makes more sense to me, rather than
> the current behavior of continually logging and overrunning the buffers
> forever regardless of whether something is reading them.  Maybe that's
> not exactly what you'd want, but it made more sense to me, so that's
> what I did for this.
> 
> So anyway, to use it, after you boot up, you can do:
> 
> root@positron:/home/trz/kmemtrace-user# ./kmemtraced-utt -t
> ^CChannel: trace
>   CPU  0:                    0 events,     8960 KiB data
>   CPU  1:                    0 events,     1508 KiB data
>   Total:                     0 events (dropped 3124),    10468 KiB data
> You have dropped events, consider using a larger buffer size (-b)
> 
> (yeah, I know, it shouldn't say 0 events, there were plenty!)
> 
> This will read the contents of the per-cpu relay files containing what
> you logged during boot into trace.kmem.0 and trace.kmem.1 - you'll have
> to rename them to cpu0.out,etc to use them with your analysis tools.
> The ctrl-c does the same thing as a normal trace i.e. stops the trace,
> reads the files and destroys the buffers.
> 
> You can start a new trace at any time using:
> 
> root@positron:/home/trz/kmemtrace-user# ./kmemtraced-utt
> ^CChannel: trace
>   CPU  0:                    0 events,      316 KiB data
>   CPU  1:                    0 events,      223 KiB data
>   Total:                     0 events (dropped 0),      538 KiB data
> 
> Again, ctrl-c to stop the trace and clean up.
> 
> Also, because you're using part of the blktrace code, you get some other
> capabilities for free, such as tracing over the network.  This starts
> the trace server, which will receive the trace data:
> 
> root@positron:/home/trz/kmemtrace-user# ./kmemtraced-utt -l
> server: waiting for connections...
> server: connection from 127.0.0.1
> 
> Now run the trace on the client, and ctrl-c to stop it:
> 
> root@positron:/home/trz/kmemtrace-user# ./kmemtraced-utt -h localhost
> kmem: connecting to localhost
> kmem: connected!
> ^CChannel: trace
>   CPU  0:                    0 events,      581 KiB data
>   CPU  1:                    0 events,      399 KiB data
>   Total:                     0 events (dropped 0),      980 KiB data
> 
> And you should see something like this on the server as well:
> 
> server: end of run for trace
> Channel: trace
>   CPU  0:                    0 events,      581 KiB data
>   CPU  1:                    0 events,      399 KiB data
>   Total:                     0 events (dropped 0),      980 KiB data
> 
> The trace files will be in a directory named using the IP address and
> time:
> 
> root@positron:/home/trz/kmemtrace-user# ls -al 127.0.0.1-2008-08-13-04:12:39
> total 1000
> drwxr-xr-x 2 root root   4096 2008-08-12 23:12 .
> drwxr-xr-x 6 trz  trz    4096 2008-08-12 23:12 ..
> -rw-r--r-- 1 root root 594944 2008-08-12 23:13 trace.kmem.0
> -rw-r--r-- 1 root root 408352 2008-08-12 23:13 trace.kmem.1
> 
> 
> libutt isn't completely baked at this point, and the API will probably
> change depending on feedback, but still it seems to work pretty well at
> this point.  If you decide to try it out, please let me know if you run
> into problems with it too.
> 
> Tom

Looks nice, as I had already implemented a way to turn off kmemtrace
when logging. I'll get back to you in a few days, I'm not close to home
right now.

BTW, did the kmemtrace user app work for you? Pekka seemed to have
issues with compiling it.


	Thanks,
	Eduard

