Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbYBMJM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbYBMJM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765690AbYBMJKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:10:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:24263 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYBMJJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t5XL/VAlkFWre1tgqMXVMRyl9bC4ho1Q2LTf6tlth/nBuwPoM0V+tVabajkyfTBD071UnDeXRVO3HDN4QE8a3MwPhEYT41mVnCxSSRIWeGG0mYT4E1q+bvj/oLJwu2DC9irvHaVy5pl6keDZaovMytANmyRcRmU9v4zanDC/rfE=
From: Tejun Heo <htejun@gmail.com>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/5] printk: add Documentation/printk.txt
Date: Wed, 13 Feb 2008 18:09:32 +0900
Message-Id: <12028937742635-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12028937731333-git-send-email-htejun@gmail.com>
References: <12028937731333-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Documentation/printk.txt which explains printk, mprintk and their
friends.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 Documentation/00-INDEX   |    2 +
 Documentation/printk.txt |  724 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 726 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/printk.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 8d55670..e4c2862 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -313,6 +313,8 @@ powerpc/
 	- directory with info on using Linux with the PowerPC.
 preempt-locking.txt
 	- info on locking under a preemptive kernel.
+printk.txt
+	- info on printk and mprintk.
 prio_tree.txt
 	- info on radix-priority-search-tree use for indexing vmas.
 ramdisk.txt
diff --git a/Documentation/printk.txt b/Documentation/printk.txt
new file mode 100644
index 0000000..e510a81
--- /dev/null
+++ b/Documentation/printk.txt
@@ -0,0 +1,724 @@
+printk and mprintk
+==================
+Tejun Heo <teheo@suse.de>, January 18 2008
+
+This document describes printk and mprintk.
+
+TABLE OF CONTENTS
+
+[1] printk
+    [1-1] What is printk and how does it operate?
+    [1-2] Log level
+	[1-2-1] What is log level and how do I use it?
+	[1-2-2] How the log level is treated by kernel and logging tools.
+    [1-3] Timestamps
+    [1-4] Multiline messages and printk_header
+    [1-5] printk's friends
+
+[2] mprintk - the merging printk
+    [2-1] What is mprintk?
+    [2-2] How do I use mprintk?
+	[2-2-1] Initialization
+	[2-2-2] Assembling and printing
+	[2-2-3] Error handling
+    [2-3] Some guidelines
+    [2-4] mprintk's friends
+
+[3] How libata uses printk_header and mprintk
+
+
+[1] printk
+
+[1-1] What is printk and how does it operate?
+
+    int printk(const char *fmt, ...)
+
+printk is the equivalent of print for perl scripts, echo for shell
+scripts and much more closely printf(3) for userland C programs.  It
+takes the same arguments as printf(3), formats the string the same way
+and spits the result out.  printk is the kernel's primary way to emit
+human-readable messages.
+
+printf(3) prints formatted messages to the default destination -
+standard output.  printk also has default destination or rather
+destinations.  Messages printed out via printk are stored in a message
+buffer which can be retrieved either by syslog(2) system call or
+reading /proc/kmsg and then printed to one or more registered
+consoles.
+
+The ring buffer is the asynchronous way to access the messages.
+dmesg(1) dumps its content, klogd reads the messages and logs the
+result via syslog facility.  The ring buffer is of fixed size which
+can be configured by the 'log_buf_len' kernel parameter.  If a new
+message is printed and the ring buffer is full, it wraps around and
+writes over the old messages.
+
+On the other hand, the consoles behave mostly synchronously{1}.  The
+most common console device is the virtual console (your graphics
+adapter and monitor).  While the machine is booting, if you disable or
+escape from the pretty graphical boot screen, you'll see lots of
+kernel messages scrolling by before the userland starts to run.  All
+those messages are from printk and your monitor is serving as a
+console device.  Other examples of console devices include serial
+console{2} and netconsole{3}.
+
+The synchronous operation of console devices can be very expensive
+depending on which console devices are attached.  For example,
+transferring 160 characters over 9600 baud rate serial line consumes
+around 18.75 milliseconds and the CPU won't be doing anything else
+other than pushing the bytes out.
+
+Accesses to the log buffer are synchronized and messages from separate
+printk invocations never get intermixed; however, there is no
+guarantee that two consecutive calls to printk will show up
+consecutively.  printk calls from other threads can be printed
+inbetween.
+
+    Thread A			Thread B
+
+    printk("hello ");		printk("The answer is ");
+    printk("world!\n");		printk("42\n");
+
+The output can be
+
+    hello The answer is world!
+    42
+
+or any other combination - 6 of them, so you shouldn't construct
+messages piece-by-piece by calling printk on substrings.  You should
+build the complete message first and print it by calling printk once.
+As constructing a message from pieces can be a non-trival task, there
+is a helper mechanism called mprintk.  It will be explained later.
+
+
+[1-2] Log level
+
+[1-2-1] What is log level and how do I use it?
+
+Another difference from printf(3) is that printk performs a bit of
+post-processing on the printed messages.  Each line printed via printk
+has a log level which is priority or urgency of the message.  Eight
+log levels are defined and have the following meanings.
+
+    KERN_EMERG		: system is unusable
+    KERN_ALERT		: action must be taken immediately
+    KERN_CRIT		: critical conditions
+    KERN_ERR		: error conditions
+    KERN_WARNING	: warning conditions
+    KERN_NOTICE		: normal but significant condition
+    KERN_INFO		: informational
+    KERN_DEBUG		: debug-level message
+
+If you search for the above constants in include/linux/kernel.h,
+you'll see that they are defined as string constants "<N>" where N is
+0 for EMERG and increments for each upto 7 for DEBUG.  There's nothing
+magical about it.  Lines which start with "<N>" has the priority of N.
+Because C's preprocessor merges string constants, simply putting the
+macro in front of a message suffices.
+
+    printk(KERN_WARNING "I'm a whiny kernel.\n");
+    printk("%sAm I too whiny?\n", KERN_WARNING);
+    printk("<%d>You don't think I'm too whiny, do you?\n", 4);
+
+Will output.
+
+    <4>I'm a whiny kernel.
+    <4>Am I too whiny?
+    <4>You don't think I'm too whiny, do you?
+
+But what happens when you don't specify log level?  In such cases,
+printk automatically assigns the default log level which is
+KERN_WARNING by default but can be overridden using sysctl{4}, so
+
+    printk("Please tell me I don't whine too much\n");
+
+is mostly equivalent to
+
+    printk(KERN_WARNING "Please tell me I don't whine too much\n");
+
+Noticed 'mostly'?  The output will be different if the message doesn't
+start a new line.  Please recall that log level is per-line and thus
+log level string doesn't have any meaning when it's not at the start
+of a line.
+
+    printk(KERN_NOTICE "Why don't you notice me? ");
+    printk(KERN_EMERGE "Do I have to say louder?\n");
+
+The above will result in the following string.
+
+    <5>Why don't you notice me? <0>Do I have to say louder
+
+And printk will treat it as a NOTICE message whose content is
+
+    Why don't you notice me? <0>Do I have to say louder
+
+Putting log level in the middle of string doesn't do anything to the
+log level.  It just gets printed verbatim.  This is another reason to
+avoid constructing messages piece-by-piece by calling printk multiple
+times.  Let's go back to the hello world example and add log levels
+there.
+
+    Thread A			Thread B
+
+    printk(KERN_ERR "hello ");	printk(KERN_INFO "The answer is ");
+    printk("world!\n");		printk("42\n");
+
+The end result can be
+
+    <3>hello <6>The answer is 42
+    <4>world
+
+The first line is ERR message with weird "<6>" in it and the second
+line is WARNING message where the log level is automatically assigned
+by printk.
+
+Another thing to note about log level handling is that printk
+maintains log level in a multiline message.
+
+    printk(KERN_INFO "whine0\nwhine1\n" KERN_ERR "whine2\nwhine3\n");
+
+Becomes
+
+    <6>whine0
+    <6>whine1
+    <3>whine2
+    <3>whine3
+
+
+[1-2-2] How the log level is treated by kernel and logging tools.
+
+You probably have never noticed the log level markup in the dmesg(1)
+output, /var/log/messages or kernel messages printed on your monitor.
+This is because log level is treated specially.  When message buffer
+is accessed via syslog(2) or /proc/kmsg, the log level is printed
+verbatim but the reading program - often klogd(8) or dmesg(1) -
+recognizes the log levels, strips them and routes or treats the
+messages accordingly.  You can read the raw messages with the log
+level by stopping klogd(8) and executing "cat /proc/kmsg".
+
+For console devices, printk itself performs similar function.  The log
+level is stripped before being submitted to console drivers and
+messages are filtered according to the console log level such that low
+priority messages don't clutter consoles.  Console log level can be
+adjusted using either syslog(2) system call or kernel.printk sysctl
+node{4}.
+
+
+[1-3] Timestamps
+
+Another post-processing performed by printk is prepending timestamp.
+When enabled, the kernel's conception of time since boot or resume is
+added between the log level and the actual message.  The following is
+excerpt from libata probing messages.
+
+    <6>[  114.971205] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
+    <6>[  114.989200] ata8.00: HPA detected: current 156299375, native 156301488
+    <6>[  115.007362] ata8.00: ATA-7: WDC WD800JD-00MSA1, 10.01E01, max UDMA/133
+    <6>[  115.024879] ata8.00: 156299375 sectors, multi 16: LBA48 NCQ (depth 31/32)
+    <6>[  115.043885] ata8.00: configured for UDMA/133
+
+The number before "." is seconds and after is nanoseconds.  It's
+kernel's conception of time and may not match actual wall clock
+depending on power saving setting and other things.
+
+Timestamp is enabled at kernel compile time using CONFIG_PRINTK_TIME
+but it can also be enabled or disabled when booting by specifying
+"printk.time=1" as kernel boot parameter.  In addition, by echoing "0"
+or "1" to /sys/module/printk/parameters/printk_time, you can control
+it while the system is running.
+
+klogd(8) automatically prepends timestamps when logging kernel
+messages, so printk timestamp is somewhat redundant; however, printk
+timestamp has the following benefits making it better suited for
+debugging.
+
+* klogd(8) only knows when it read the messages.  It can't tell when
+  the message was generated.  For example, during boot or resume,
+  userspace is not running and when klogd(8) finally runs it can't
+  tell what happened when and just puts the same timestamp on all the
+  accumulated messages.
+
+* It uses kernel's conception of time and at times this provides
+  better insight into what's going on.  For example, if there's a bug
+  in kernel's timer code, kernel's conception of time can be stalled
+  or delayed while gettimeofday(2) still returns valid values.
+
+* Reading messages from the console or running dmesg(1) to dump the
+  message buffer is simpler than having klogd(8) running.  Having
+  timestamps available when using simpler methods helps debugging.
+
+There are discussions of automatically stripping and handling
+timestamps from dmesg(1) and klogd(8) to remove the timestamps
+automatically.
+
+
+[1-4] Multiline messages and printk_header
+
+    int printk_header(const char *header, const char *fmt, ...)
+
+Kernel messages are usually fitted to 80 column as many people use 80
+column console or terminal to print out and view log messages, but, at
+times, there are more things to say than fits into one 80 column line.
+
+For example, when an ATA command fails, libata reports the taskfile
+registers for the failed command and the result taskfile registers.
+Both have similar formats and each nearly fills up 80 column.  Such
+messages can be printed with separate calls to printk or as a single
+call to printk where the output string contains newline inside it.
+For simplicity, I'll just use simplified string constants for the rest
+of this section.
+
+    printk(KERN_ERR "ata1.00: cmd 60/01:00:e0:71:02/00:00:00:00:00/40\n");
+    printk(KERN_ERR "ata1.00: res 40/00:34:de:71:02/00:00:00:00:00/40\n");
+
+Or
+
+    printk(KERN_ERR "ata1.00: cmd 60/01:00:e0:71:02/00:00:00:00:00/40\n"
+                    "ata1.00: res 40/00:34:de:71:02/00:00:00:00:00/40\n");
+
+Both will print about the same thing but the latter has the benefit
+that the message won't break up in the middle.  Another twist is that
+there can be multiple commands in flight, so the output can look like
+the following.
+
+    ata1.00: cmd 60/57:00:69:ab:03/00:00:00:00:00/40
+    ata1.00: res 40/00:14:cc:ab:03/00:00:00:00:00/40
+    ata1.00: cmd 60/0c:08:c0:ab:03/00:00:00:00:00/40
+    ata1.00: res 40/00:14:cc:ab:03/00:00:00:00:00/40
+    ata1.00: cmd 60/80:18:e8:aa:03/00:00:00:00:00/40
+    ata1.00: res 40/00:14:cc:ab:03/00:00:00:00:00/40
+
+Which is pretty confusing to the eyes.  It would be better if there is
+some indication of message boundaries.
+
+    ata1.00: cmd 60/57:00:69:ab:03/00:00:00:00:00/40
+    ata1.00  res 40/00:14:cc:ab:03/00:00:00:00:00/40
+    ata1.00: cmd 60/0c:08:c0:ab:03/00:00:00:00:00/40
+    ata1.00  res 40/00:14:cc:ab:03/00:00:00:00:00/40
+    ata1.00: cmd 60/80:18:e8:aa:03/00:00:00:00:00/40
+    ata1.00  res 40/00:14:cc:ab:03/00:00:00:00:00/40
+
+Okay, now it gives us visual clue where each multiline message starts,
+so combining the above atomic multiline message and visual clue, the
+driver should do the following.
+
+    printk(KERN_ERR "ata1.00: cmd 60/01:00:e0:71:02/00:00:00:00:00/40\n"
+                    "ata1.00  res 40/00:34:de:71:02/00:00:00:00:00/40\n");
+
+However, this becomes quite clumsy.  Port and device numbers are
+variables and should be specified repeatedly for each line.  This is
+the problem printk_header solves.  It has a notion of message header
+and pretty-print multiline messages.  The above example can be done
+using printk_header like the following.
+
+    printk_header(KERN_ERR "ata1.00: ",
+                  "cmd 60/01:00:e0:71:02/00:00:00:00:00/40\n"
+                  "res 40/00:34:de:71:02/00:00:00:00:00/40\n");
+
+printk_header will automatically prepend whole header to the first
+line and prepend without the colon in the second line.  In the above
+example, log level is prepended to the header but printk_header also
+allows log level in front of each message line.
+
+    printk_header(KERN_ERR "whiny: ", KERN_DEBUG "it's me again\n"
+                                      KERN_INFO "I feel depressed today\n"
+                                     "The machine hates me\n");
+
+Will output
+
+    <7>whiny: it's me again
+    <6>whiny  I feel depressed today
+    <6>whiny  The machine hates me
+
+Note that the log level of the first message line trumped log level in
+the message header.  As seen above, printk_header supports switching
+log level inside a multiline message but it's usually better to stick
+with single log level in a multiline message.
+
+Replacing colon with space is preformed if and only if the header ends
+with ":\s*" where \s is any character which isspace() returns
+non-zero.
+
+
+[1-5] printk's friends
+
+int vprintk(const char *fmt, va_list args)
+
+    Identical to printk but takes va_list @args instead of argument
+    list.
+
+int vprintk_header(const char *header, const char *fmt, va_list args)
+
+    Identical to printk_header but takes va_list @args instead of
+    argument list.
+
+int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
+
+    Rate-limited printk.  Not more than one kernel message every
+    @ratelimit_jiffies to make a denial-of-service attack impossible.
+    @ratelimit_burst messages are allowed before ratelimit kicks in.
+
+int printk_ratelimit(void)
+
+    Rate-limited printk which uses standard limit and burst
+    parameters.  Default parameters can be tuned using sysctl{5}.
+
+bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+                            unsigned int interval_msecs)
+
+    Caller-controlled printk ratelimiting.  This function returns true
+    if more than @interval_msecs milliseconds have elapsed since the
+    last time it returned true.
+
+
+[2] mprintk - the merging printk
+
+[2-1] What is mprintk?
+
+Let's go back to the libata error message example.  Actual ATA error
+message for a failed ATAPI command looks like the following.
+
+    ata1.00: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 dma 8 in
+    ata1.00  cdb 25 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
+    ata1.00  res 40/00:03:00:00:00/00:00:00:00:00/b0 Emask 0x4 (timeout)
+
+On the first line, "dma 8 in" indicates that the failed command DMAs 8
+bytes from the drive to host memory.  This segment of message is
+printed only for commands which transfer data.  The second line
+reports the SCSI CDB issued to the drive and is only meaningful for
+the ATAPI PACKET command and thus omitted for all other commands.  The
+last line reports the status of TF registers and as libata doesn't
+load TF registers after a timeout it should have been omitted but that
+isn't implemented yet.
+
+The example shows you how a message can be composed of multiple parts
+which can be included or omitted depending on the information to
+report.  This happens quite often.  Another example in libata would be
+the device configuration message.
+
+There are three ways to assemble these multi-part messages.
+
+* Calling printk() on partial message segments.  This used to be quite
+  common but has a problem - the message can break up if someone else
+  prints something in the middle.
+
+* Prepping a temp buffer and building message piece-by-piece using
+  snprintf().  This is the most generic method but corner case
+  handling can be tedious and, on overflow, messages can be lost
+  unnoticed if overflow detection isn't properly done.
+
+* Collecting all the partial data and calling printk() once with all
+  the parameters.  This is often combined with the second.  This
+  usually works but printing messages becomes non-trivial programming
+  problem and can get quite tedious if the message format varies
+  depending on data.
+
+None of the above was satisfactory, so mprintk - merging printk - was
+implemented.  It's basically a helper to construct a message
+piece-by-piece into the specified buffer.  The caller still has to
+care about buffer size and how the buffer is allocated but mprintk
+makes it easy.
+
+* DEFINE_MPRINTK() macro helps to define a mprintk instance with
+  on-stack buffer.
+
+* mprintk_init_alloc() and mprintk_free() are helpers to use malloc'd
+  buffer.
+
+* Messages are never lost.  On buffer overflow, all queued and to be
+  queued messages are printed followed by a warning message and stack
+  dump.  The warning message and stack dump are printed once per
+  mprintk instance.  Also, the caller doesn't have to handle buffer
+  allocation failure.  If buffer is initialized to NULL, mprintk
+  simply bypasses messages to printk().  As free() can cope with NULL
+  pointer too, allocation failure doesn't require any extra care.
+
+* Has good support for multiline messages.  A mprintk instance can
+  have header associated with it and the header can have log level.
+  Header log level is used if a message chunk doesn't specify log
+  level explicitly.  When log level is specified explicitly in a
+  message chunk, the log level is applied to the chunk only.
+
+
+[2-2] How do I use mprintk?
+
+[2-2-1] Initialization
+
+    MPRINTK_INITIALIZER(buf, size)
+    DEFINE_MPRINTK(name, size)
+    void mprintk_init(struct mprintk *mp, char *buf, size_t size)
+    void mprintk_init_alloc(struct mprintk *mp, gfp_t gfp)
+    void mprintk_free(struct mprintk *mp)
+
+struct mprintk is the data structure used to keep track of the merge
+buffer.  This can be allocated anywhere but defining as a local
+variable for the block containing the message assembling code makes
+sense for most cases.  struct mprintk doesn't contain buffer space for
+the string.  It needs to be defined separately and mprintk should be
+initialized with the pointer to and the size of the buffer.
+
+MPRINTK_INITIALIZER() can be used to initialize mprintk instance.
+
+    char mp_buf[2 * 80];
+    struct mprintk mp0 = MPRINTK_INITIALIZER(mp_buf, 2 * 80);
+    struct mprintk mp1 = MPRINTK_INITIALIZER(A_struct->buffer, A_BUF_LEN);
+
+Function call variant - mprintk_init - can also be used.
+
+    struct mprintk mp;
+
+    mprinkt_init(&mp, buffer, MAX_MESSAGE_LEN);
+
+To malloc buffer, mprintk_init_alloc should be used.
+
+    struct mprintk mp;
+
+    mprintk_init_alloc(&mp, GFP_KERNEL);
+
+The caller doesn't have to care about buffer length.  The allocated
+buffer should be freed using mprintk_free.  mprintk_free can be called
+on any mprintk instance but if the mprintk instance hasn't been
+initialized with mprintk_init_alloc, it's noop.
+
+    mprintk_free(&mp);
+
+Because defining both mprintk instance and string buffer on stack is
+the most common case, there's a shortcut for it.
+
+    DEFINE_MPRINTK(my_mp, 2 * 80);
+
+Which is equivalent to the following.
+
+    char __my_mp_buf[2 * 80];
+    struct mprintk my_mp = MPRINTK_INITIALIZER(__my_mp_buf, 2 * 80);
+
+Please keep in mind that MPRINTK_INITIALIZER allocates the string
+buffer on stack.  If too much is allocated, stack overflow can happen.
+In most cases, a few hundred bytes should be fine and you shouldn't go
+over that anyway.  More on this subject later in the guidelines
+section.
+
+
+[2-2-2] Assembling and printing
+
+    int mprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+    int mprintk(struct mprintk *mp, const char *fmt, va_list args)
+    int mprintk_flush(struct mprintk *mp, const char *fmt, va_list args)
+
+mprintk_set_header() sets the header of the message.  This function
+can be called only once after initialization and should be called when
+the buffer is empty, that is, right after intialization or being
+flushed.  Returns the length of the formatted string.
+
+mprintk() Appends the formatted string to the specified mprintk
+instance.  Returns the length of the formatted string.
+
+mprintk_flush() appends the formatted string to the specified mprintk
+instance, prints out the accumulated message and resets the buffer.
+Returns the length of the formatted string.
+
+Here's a simple example.
+
+    DEFINE_MPRINTK(mp, 2 * 80);
+
+    mprintk_set_header(&mp, KERN_INFO "Marvin: ");
+    mprintk(&mp, "Life.\n");
+    mprintk(&mp, "Don't talk to me ");
+    mprintk_flush("about %s.\n", life);
+
+Which becomes
+
+    <6>Marvin: Life.
+    <6>Marvin  Don't talk to me about life.
+
+mprintk allows log levels both in front of the header and in front of
+each message chunk (formatted string of each mprintk[_add]() call).
+Log levels specified in front of a message chunk applies only to that
+message chunk and has priority over the header log level.  Message
+chunks without explicit log level use the header log level.
+
+    DEFINE_MPRINTK(mp, 4 * 80);
+
+    mprintk_set_header(&mp, KERN_INFO "Marvin: ");
+    mprintk(&mp, KERN_ERR "Here I am, brain the size of a planet and\n"
+                 "they ask me to take you down to the bridge.\n");
+    mprintk(&mp, "Call that job satisfaction?\n");
+    mprintk_flush(&mp, "'Cos I don't.\n");
+
+Which becomes
+
+    <3>Marvin: Here I am, brain the size of a planet and
+    <3>Marvin  they ask me to take you down to the bridge.
+    <6>Marvin: Call that job satisfaction?
+    <6>Marvin  'Cos I don't.
+
+Note how KERN_ERR is applied to the first message chunk while the
+header log level is used for the last message chunks which don't have
+explicit log level specified.  The header is printed again on the
+third line because of log level change.
+
+Remember log level is only meaningful when a new line starts?  That
+applies the same to mprintk message chunks.  If a message chunk
+doesn't start a new line, log level in front of it will be treated as
+verbatim string.
+
+Also, mprintk doesn't allow switching log level in the middle of a
+message chunk.  Don't do it.
+
+
+[2-2-3] Error handling
+
+One good thing about mprintk is that you don't have to pay attention
+to error handling.  There can be two error conditions - buffer
+overflow and NULL buffer due to allocation failure.
+
+If adding a new message chunk overflows the buffer, mprintk prints out
+the accumulated message followed by the new message chunk which caused
+overflow.  If the overflow is the first one since mprintk
+initialization, a warning message and stack dump are printed to aid
+debugging.
+
+In rare cases, buffer overflow can also happen while setting the
+header, if this happens, it's handled the same way as message chunk
+overflow; however, after such a failure, if the messasge is multiline,
+lines after the first one won't have proper header or header log level
+- the default log level, WARNING, will be used for lines without
+explicit log level.
+
+When buffer is allocated using kmalloc(), the allocation might fail.
+mprintk allows NULL buffer initialization.  In which case, mprintk
+simply forwards messages to printk.  As in the header overflow case,
+header handling can be broken but no message is lost.
+
+All in all, you don't need to do any error handling when using
+mprintk.  It's just like printk.  It's guaranteed to deliver the
+message and there's no need to check the return values.
+
+    struct mprintk mp;
+    int i;
+
+    mprintk_init_alloc(&mp, GFP_KERNEL);
+
+    mprintk_set_header(&mp, "Beeblebrox: ");
+    for (i = 0; i < 5; i++)
+            mprintk(&mp, "Yeah. Listen, I'm Zaphod Beeblebrox,\n"
+                         "my father was Zaphod Beeblebrox the Second,\n"
+                         "my grandfather Zaphod Beeblebrox the Third...\n");
+    mprintk_flush(&mp, "Rubbish...\n");
+
+    mprintk_free(&mp);
+
+The above code segment will print 16 lines sans one overflow message
+and stack dump no matter what and won't leak memory.
+
+
+[2-3] Some guidelines
+
+* Don't build gigantic messages.  Don't span over a few lines.  Just
+  put what really needs to be an atomic message into one message.
+  Keep in mind that printk silently clips messages at 1k.
+
+* Prefer on-stack buffer and when using on-stack buffer use
+  DEFINE_MPRINTK().  If you observe the previous guideline, on-stack
+  buffer should be sufficient.  It's the simplest and can't leak
+  memory.
+
+* With the header and automatic log level adjustments, the end result
+  can be a bit longer.  Give it some extra room.  I find it useful to
+  specify buffer length in multiples of 80 as lines shouldn't go over
+  80 column anyway.  If the message can be four lines long,
+  specify 4 * 80.
+
+* Specify log level at the header and refrain from overriding log
+  level from message chunks unless necessary.  If you encounter an
+  error condition while building an informational message, printing an
+  error message with a separate call to printk[_header]() and resuming
+  building the informational message is usually the right thing to do.
+
+
+[2-4] mprintk's friends
+
+int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+
+    Identical to mprintk_set_header but takes va_list @args instead of
+    argument list.
+
+int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+
+    Identical to mprintk but takes va_list @args instead of argument
+    list.
+
+int vmprintk_flush(struct mprintk *mp, const char *fmt, va_list args)
+
+    Identical to mprintk_flush but takes va_list @args instead of
+    argument list.
+
+
+[3] How libata uses printk_header and mprintk
+
+Me being a libata guy, the first user of printk_header and mprintk is
+libata.  libata has printk helpers at each level - port, link and
+device.  Let's take a look at the port one.
+
+    int ata_port_printk(struct ata_port *ap, const char *lv,
+                        const char *fmt, ...)
+    {
+            va_list args;
+            char hbuf[16];
+            int ret;
+
+            snprintf(hbuf, sizeof(hbuf), "%sata%u: ", lv, ap->print_id);
+
+            va_start(args, fmt);
+            ret = vprintk_header(hbuf, fmt, args);
+            va_end(args);
+
+            return ret;
+     }
+
+It creates a header and calls vprintk_header() with it and passes the
+format string and arguments.  Note the separate @lv argument.  This is
+remnant of the previous define-based implementation which didn't use
+printk_header and thus had to manually put the message level in front
+of the header.  With printk_header, the formatted string can carry the
+log level in front of it and printk_header will do the right thing.
+
+Also, there is a port-level helper to set header of a mprintk buffer.
+
+    void ata_port_mp_header(struct ata_port *ap, const char *lv,
+                            struct mprintk *mp)
+    {
+            mprintk_set_header(mp, "%sata%u: ", lv, ap->print_id);
+    }
+
+After initializing mprintk and calling the above function,
+mprintk_add() and mprintk() can be used freely to assemble and print
+messages.  For examples, take a look at ata_dev_configure() in
+drivers/ata/libata-core.c and ata_eh_link_report() in
+drivers/ata/libata-eh.c.  Note that both functions use ap->sector_buf.
+This is 512 byte buffer owned by the EH thread which happens to be the
+only thread which does EH reporting and device configuration.
+
+Happy hacking.
+
+
+REFERENCES
+
+{1} On SMP, if a CPU does printk while another one is executing
+    console drivers to push out messages, the new message would simply
+    be queued and printk returns.
+
+{2} Documentation/serial-console.txt
+
+{3} Documentation/networking/netconsole.txt
+    Note that netconsole can't be the primary console - the one which
+    provides standard IOs to init - as it can't read from the user.
+    Also, its synchronisity is further limited.  On write completion,
+    all that can be assured is that the packets containing the message
+    have been sent.  Whether or when the message has arrived on the
+    destination is unknown.
+
+{4} Documentation/sysctl/kernel.txt:printk
+
+{5} Documentation/sysctl/kernel.txt:printk_ratelimit,printk_ratelimit_burst
+
-- 
1.5.2.4

