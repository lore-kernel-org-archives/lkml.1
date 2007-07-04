Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXGDDNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXGDDNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbXGDDNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:13:08 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:40468 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610AbXGDDNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:13:06 -0400
Date: Tue, 3 Jul 2007 23:13:01 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, michaele@au1.ibm.com, dwilder@us.ibm.com,
       HOLZHEU@de.ibm.com
Subject: Re: [RFC PATCH 1/6] Driver Tracing Interface (DTI) Documentation
Message-ID: <20070704031300.GA24341@Krystal>
References: <1183173817.24291.137.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1183173817.24291.137.camel@ubuntu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:33:19 up 2 days, 21:16,  2 users,  load average: 0.25, 0.25, 0.15
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

I'm glad to see that other people are tackling the tracing task.
I must say that there is a lot here that was already out there in LTTng.
I will be happy to review the code you present. Please see comments
below.

* Tom Zanussi (zanussi@us.ibm.com) wrote:
> Hi,
> 
> This patchset contains the code for a tracing and debugging facility
> named 'The Driver Tracing Interface (DTI)' after the title of our OLS
> paper, to be presented tomorrow. ;-)
> 
> It was originally based on ideas from a useful s390 tracing utility
> called s390dbf (see Documentation/s390/s390dbf.txt), which allows
> driver writers to set up and continually log to a small (or large)
> circular 'flight-recording' buffer.  When something goes wrong, the
> buffer can be cat'ed from userspace and the contents analyzed to help
> determine the source of the problem.
> 
> The s390dbf facility supports multiple log levels, so the level of
> detail being logged can be dynamically controlled (again in user space
> via a control file).  which in turn provides even more help in
> determining the source of the problem.  This facility has apparently
> proven itself very useful in the field and has helped solve driver
> problems on production systems.
> 
> The Driver Tracing Interface introduced here does essentially the same
> thing, but makes the functionality available to all architectures, not
> just s390.  It's built on top of the relay interface, and so makes
> per-cpu logging available to users of the interface, something which
> the s390dbf facility currently lacks.
> 
> Because the data is logged to per-cpu buffers, there needs to be an
> easy way for users to easily view it without having to read and merge
> the individual per-cpu buffers themselves.  To solve this problem, DTI
> provides a merged 'view' via a debugfs file, which merges and presents
> the per-cpu data when read.
> 
> DTI is also very useful as a debugging tool for kernel development.  I
> personally use the klog example in the relay-apps user code all the
> time for quick-and-dirty tracing, and I know that other people use
> similar home-grown tracing tools (and even post them here).
> Hopefully, the DTI interface provides a decent enough simplification
> of the relay API that using it for these types of tracing applications
> would be attractive to people put off by the bare relay API.
> 
> I created a DTI sourceforge site earlier today, but it hasn't been
> approved yet.  Once it's available, I'll put a few example patches up
> there along with some user tools (for binary tracing).  But in the
> meantime, here's a short description of the examples:
> 
> - dti-ext2-example.patch - ext2 contains some debugging code that uses
>   printk().  Redefining ext2_debug() in ext2_fs.h to use dti_printk()
>   basically turns the existing debugging code into a flight-recording
>   DTI channel.
> 
> - dti-systrace-example.patch - does binary tracing of all interrupts,
>   system calls and schedule changes (x86).  This demonstrates using a
>   single DTI channel across multiple 'subsystems' as well as custom
>   formatting and presentation of the binary data (using the DTI user
>   code).
> 
> - dti-early-example.patch - does early tracing i.e. before initcalls.
>   Logs data starting from the beginning of start_kernel() and when the
>   system comes up, boot data is available in a DTI debugfs file.
> 
> This patchset includes a few additions to relay, and also a patch that
> converts some of the s390 drivers from s390dbf to DTI.
> 
> DTI uses the Generic Tracing Setup and Control (GTSC) API, which was
> posted a couple of weeks ago and which I'll post an updated version of
> following this patchset.
> 
> For maximum satisfaction, you should also make sure your kernel has
> these two relay patches applied:
> 
> http://marc.info/?l=linux-kernel&m=118214275032484&w=2
> http://marc.info/?l=linux-kernel&m=118232840921694&w=2
> 
> Thanks also to Michael Ellerman for some useful suggestions on the
> interface.
> 
> Tom
> 
> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  dti.txt |  272 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 272 insertions(+)
> 
> diff --git a/Documentation/drivers/dti.txt b/Documentation/drivers/dti.txt
> new file mode 100644
> index 0000000..e071167
> --- /dev/null
> +++ b/Documentation/drivers/dti.txt
> @@ -0,0 +1,272 @@
> +Driver Tracing Interface (DTI)
> +==============================
> +
> +The Driver Tracing Interface provides easy-to-use interfaces for
> +logging per-cpu 'flight recorder' data in the kernel and merging and
> +presenting it to userspace.
> +
> +On the kernel side, data can be logged as text using a printk()-like
> +logging function, or it can be logged in binary form using a couple of
> +special binary event logging functions.
> +
> +On the user side, the combined contents of all the data present in the
> +per-cpu relay files can be read from a single debugfs file that merges
> +and presents the contents of the per-cpu data files.  This is mostly
> +useful for text-based logging, but also works for binary logging.  For
> +binary logging, there is a small userspace library and examples
> +available which merge and display the binary per-cpu data in userspace
> +rather than in the kernel.  See http://sourceforge.net/projects/dti.
> +

Right.. LTTng does not use text-based tracing at all, nor global
buffers, because of the performance hit. I see that it can be usseful in
some cases, but the fact that we have a post-processing binary-to-text
converter that uses the timestamp to merge the per-cpu buffers makes the
global channel useless.

> +DTI also presents an interface to user space allowing it to control the
> +amount or 'level' of data being logged at any given time using levels
> +corresponding to printk log levels.  This interface can also be used to
> +stop logging and to destroy the channel.
> +

Controlling by loglevel is an interesting idea. However, we are
currently, with the markers, implementing a per-marker fine-grained
event selection mechanism, which enables or disables the markers at the
caller site to filter events, which seems to be more performant and
finer-grained than the loglevel-based mechanism.

> +The length and format of the data logged into a DTI channel is completely
> +up to the client.
> +
> +DTI also provides an easy way to do 'early logging' in the kernel
> +e.g. from the beginning of the start_kernel() kernel init code.
> +

That was implemented in the original LTT, but has never been redone in
LTTng, due to lack of time. I'm glad to see you implemented it.

> +DTI is built on top of the relay interface (see
> +Documentation/filesystems/relay.txt) and the Generic Trace Setup and
> +Control interface (see Documentation/gtsc.txt).
> +

At some point, I would like discussing with you a push of the lockless
buffer management mechanism I have in LTTng to relay. I use per-cpu
buffers and per-cpu local atomic operations to get the best performances
and still be reentrant from most kernel code paths, including NMI
handlers.

> +This document provides an overview of the DTI API.  The details of the
> +function parameters are documented along with the functions in the DTI
> +code - please see that for details.
> +
> +
> +Using DTI
> +=========
> +
> +In the kernel, DTI provides both a low-level interface and a
> +high-level 'handle-based' interface.  The handle-based interface is
> +built on top of the low-level interface.  The main difference between
> +the low and high-level interfaces is that in addition to being easier
> +to use, the high-level interface only allocates the channel buffers
> +'on-demand', when the first event of a high enough priority comes in.

Ouch ? What tells you that you are running in a context where it is safe
to allocate a channel buffer when you hit the first event of that
loglevel ? I see it is done in complete_channel(), which fails silently
if the code is called from an atomic context. tsk tsk.. who would like
to miss important events just because their buffer was not allocated and
they were unable to allocate it.

> +With the low-level interface, the channel buffers are created
> +immediately.  Also, with the high-level interface, 'early' logging is
> +possible; with the low-level interface, it's not.
> +
> +The handle-based interface
> +--------------------------
> +
> +To do some quick printk()-style tracing using DTI, first define a DTI
> +handle in your source file:
> +
> +  #include <linux/dti.h>
> +
> +  DEFINE_DTI_HANDLE(my_handle, "mytrace", 4096 * 4, DTI_LEVEL_OFF);
> +
> +This example sets up a dti handle called my_handle with per-cpu relay
> +buffers of 16k each, and an initial trace level of 'off'.
> +
> +If you're logging from a module, you also need to initialize the
> +handle in your module init function:
> +
> +  INIT_DTI_HANDLE(my_handle);
> +
> +If you define the handle in a kernel source file, or if your module is
> +compiled into the kernel, you don't need the INIT_DTI_HANDLE() -
> +initialization will be taken care of automatically for you.
> +
> +This will create a debugfs directory for your trace with a bunch of
> +files in it:
> +
> +  /sys/kernel/debug/dti/mytrace
> +
> +Now that you have a handle, you can log to it e.g.:
> +
> +  dti_printk(my_handle, DTI_LEVEL_DEFAULT, "debug string\n");
> +
> +When this statement is executed, it will check whether the level given
> +in the dti_printk() is less than or equal to the channel's current
> +tracing level.  If it is, the event will be logged, otherwis it will
> +be ignored. In this example, it won't be logged, since the channel
> +starts out as DTI_LEVEL_OFF, which is lower than any possible event.
> +
> +Since the channel is off, setting the channel's current level to
> +something greater than or equal to DTI_LEVEL_DEFAULT will cause the
> +event to be logged e.g.:
> +
> +  echo 7 > /sys/kernel/debug/dti/mytrace/level
> +
> +After you're done logging, you can view the events in the channel by
> +reading either the 'merged' or merged-ts' files e.g.:
> +
> +  cat /sys/kernel/debug/dti/mytrace/merged
> +
> +Reading these files causes the current contents of the per-cpu relay
> +channels to be merged and sent to the user.  The difference between
> +'merged' and 'merged-ts' is that 'merged-ts' displays timestamp and
> +cpu information, whereas 'merged' doesn't - it displays exactly what
> +was logged into the channel.
> +
> +binary tracing
> +--------------
> +
> +dti_printk() is one of three DTI logging functions available and is
> +used for printing text to a DTI channel.  The other two logging
> +functions can be used for logging binary data:
> +
> +  dti_event(handle, trace_level, buf, len)
> +
> +dti_event() simply logs whatever is passed in buf to the channel.
> +Like dti_printk(), it automatically provides the necessary
> +synchronization to avoid overwriting other events.
> +
> +  dti_reserve(handle, trace_level, len)
> +
> +dti_reserve() simply reserves space in the channel for the event.  It
> +doesn't provide any synchronization to avoid overwriting other events
> +- callers must provide their own synchronization when using this.
> +
> +The logging functions can be intermixed, but the client should be
> +prepared to make sense of the mixed data.
> +
> +Using the binary logging functions to log data in binary form implies
> +that it probably wouldn't make much sense to simply 'cat' the 'merged'
> +file to look at the data.  It makes more sense to have a userspace
> +tool read and merge the per-cpu binary data and present it in a
> +human-readable form.
> +
> +At the DTI sourceforge site, there's a utility called 'dtiprint' that
> +reads and merges the binary per-cpu data from any DTI channel and
> +prints it as hex.  If that's not sufficiently usable, there's also an
> +example that shows how to write a customized display application for
> +displaying application-specific binary data.  It makes use of a source
> +library called 'libdti' which makes writing one-off utilities pretty
> +simple.
> +
> +'early' tracing
> +---------------
> +
> +With the handle-based interface, channels are created and ready to use
> +during the do_initcalls() phase of kernel initialization.  If you want
> +to do tracing before then (say at the beginning of start_kernel()),
> +you can define an 'early' DTI handle using DEFINE_DTI_EARLY_HANDLE():
> +
> +  static char early_tracebuf[4096 * 4];
> +
> +  DEFINE_DTI_EARLY_HANDLE(early_dti_handle, "early", 4096 * 8,
> +                          DTI_LEVEL_DEFAULT, early_tracebuf,
> +                          sizeof(early_tracebuf));
> +

What tells you that your timestamps will not be jumping randomly ?

Same thing for the if (handle->initbuf test in dti_reserve_early_fn:
it should keep a counter of events missed, not discard them silently.

> +This example creates a 32k per-cpu DTI channel having the default log
> +level, and in addition specifies a single 16k buffer that will be used
> +to log data into until the relay channels can be created at handle
> +initialization time.  In this case, after the system boots up, the file
> +
> +  /sys/kernel/debug/dti/early/merged
> +
> +will contain the data collected during early tracing.
> +
> +Handles created with DEFINE_DTI_EARLY_HANDLE are exactly the same as
> +handles created using DEFINE_DTI_HANDLE() except that a static init
> +buffer is attached to the handle.  This static buffer is logged into
> +until the relay channel becomes available, at which point the contents
> +of the static buffer are re-logged into the relay buffer.  Early
> +handles have the same lifetimes as normal handles and can be used in
> +the same way after initialization.  There are no special logging
> +functions needed for logging early data - the same dti_printk(), etc,
> +functions are used to log to an early channel.

How can the copy be done without mixing TSCs from early and non-early
events ? Why should it be done at all ?

> +
> +The low-level interface
> +-----------------------
> +
> +To use the low-level interface, first register a channel:
> +
> +  channel = dti_register(name, size, init_level)
> +
> +This will create a DTI channel ready for logging to.  The size of each
> +per-cpu buffer is given as the 'size' param and the channel will be
> +created with the initial trace level specified.  The channel directory
> +will appear at /sys/kernel/debug/dti/name.
> +
> +If you want to explicitly specify sub-buffer sizes and numbers (see
> +relay.txt for more information on sub-buffers), you can use the
> +double-underscore version:
> +
> + channel = __dti_register(name, sub_size, nr_sub, init_level)
> +
> +When you're done with a channel, call:
> +
> +
> +  dti_unregister(trace)
> +
> +to destroy the channel and its containing subdirectory.
> +
> +To change the current log level of a channel, use:
> +
> +
> +  dti_set_level(trace, new_level)
> +
> +For the low-level interface, the logging functions are essentially the
> +same, but don't use handles:
> +
> +  __dti_printk(trace, level, fmt, ...)
> +  __dti_event(trace, level, buf, len)
> +  __dti_reserve(trace, level, len)
> +
> +Misc
> +----
> +
> +For the high-level interface, after a DTI channel is created, but
> +before the first loggable event has arrived, the debugfs directory
> +layout appears as:
> +
> +  /sys/kernel/debug/dti/name/
> +                            level
> +                            nr_sub
> +                            rewind
> +                            state
> +                            sub_size
> +
> +After the first loggable event arrives, or if using the low-level
> +interface, the debugfs directory layout looks like this:
> +
> +  /sys/kernel/debug/dti/name/
> +                            level
> +                            merged
> +                            merged-ts
> +                            nr_sub
> +                            rewind
> +                            state
> +                            sub_size
> +                            trace0
> +                            trace1
> +
> +Here, the 'merged' and 'merged-ts' views are added, along with the
> +actual relay channels ('trace0, trace1, etc).
> +
> +The 'level' file can be written to change the log level and/or turn
> +tracing on/off.  The log levels (see include/linux/dti.h) run from -2
> +to 7, with special meanings for levels -1 and -2:
> +
> +  -1 means to stop tracing completely (the string "off" can also be used)
> +
> +  -2 means to destroy the relay channel, but leave the other control
> +   files intact (the string "destroy" can also be used)
> +
> +Destruction of the trace directory and the control files is under
> +control of the kernel code and can't be done from userspace.
> +  
> +
> +Resources
> +=========
> +
> +For example code and userspace tools, see the DTI homepage:
> +
> +  http://sourceforge.net/projects/dti
> +
> +
> +Credits
> +=======
> +
> +Tom Zanussi		<zanussi@us.ibm.com>
> +Dave Wilder		<wilder@us.ibm.com>
> +Michael Holzheu		<holzeu@de.ibm.com>
> +Vara Prasad		<prasadav@us.ibm.com>
> +
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
