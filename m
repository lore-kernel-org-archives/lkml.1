Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXI0VSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXI0VSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbXI0VSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:18:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:60620 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbXI0VSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NhgcUz0Ff3x7svYbWsYpTV0jGB+SL+XVUS3uLXZ8WnhEPVbMZMmF9F0lLi3mhVlxjfRlUs8CV4M69EeEKdYj/DIDEU9UI5/1uwug70oH7F9gmtCW+DKcGS4Rk41npqsZBqCRr7YBLSNoxS0GctXyOOGLkqkNvcgBKwgKM4ppcPM=
Message-ID: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
Date: Thu, 27 Sep 2007 23:18:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] New kernel-message logging API (take 2)
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A big thanks to everybody who read and replied to my first e-mail; I
have tried my best to incorporate your feedback and suggestions. I
also added some CCs who recently participated in logging-related
discussions.


Changes (since Sept. 22):

  * Extensibility -> Allowing the compiler to eliminate messages below
    a certain threshold requires changing the API.
  * Add some special-purpose logging functions
    (printk_detected(), _registered(), _settings(), and _copyright())
  * Fine-grained log-level control. "Everything above" or "everything
    below" can be emulated by turning the specific log-levels on or off.
  * Define an extra header containing the (optional) secondary
    interface (err()/warn()/info())
  * Remove kprint_*() aliases.
  * kprint_<level>() is better than kprint(<level), ) because in the
    case of the default log-level, the argument can be omitted.
  * Memory allocated for entries and arguments is done in a ring-buffer
    with variable-sized chunks. Arguments are chained with a singly-
    linked list.
  * Use SUBSYSTEM and KBUILD_MODNAME
  * Rename kprint buffers to kprint blocks


Vegard



1. Requirements

   * Backwards compatibility with printk(), syslog(), etc. There is no
way the whole kernel can be converted to a new interface in one go.
printk() is used all over the kernel, in many different ways,
including calls from assembly, multi-line prints spread over several
calls, etc.

   * Extensibility. Features like eliminating messages below a given
threshold or recording the location (i.e. source file/line) of a
message [1] should be both selectable at compile-time and (if compiled
in) at run-time.

2. API

2.1. linux/kprint.h

  This header defines the primary (i.e. lowest-level) interface to
kprint that is made available to the rest of the kernel.

2.1.1. kprint()

	#define kprint(fmt, ...)

  This function is the equivalent of the old printk(), except that it
does not take a log-level parameter, but emits messages using the
default log-level. The string must be a single line of information
(i.e. it must not contain any newlines). kprint() is implemented as a
macro, and must not be called from assembly.

2.1.2. Log-levels

  To support the different log-levels, there exists one kprint_*()
function for each log-level, for example kprint_info(). This contrasts
with the printk() interface, but allows the log-level argument to be
passed as an argument (instead of prepending it to the message string)
and omitted if the default log-level should be used.

  The string must be a single line of information. Calling
kprint_emerg("Oops.") is equivalent to calling printk(KERN_EMERG
"Oops.\n"). These functions are implemented as macros, and must not be
called from assembly. The different log-levels (and their functions)
are:

	enum kprint_loglevel {
		KPRINT_EMERG,	/* kprint_emerg() */
		KPRINT_ALERT,	/* kprint_alert() */
		KPRINT_CRIT,	/* kprint_crit() */
		KPRINT_ERROR,	/* kprint_err() */
		KPRINT_WARNING,	/* kprint_warn() */
		KPRINT_NOTICE,	/* kprint_notice() */
		KPRINT_INFO,	/* kprint_info() */
		KPRINT_DEBUG,	/* kprint_debug() */
	};

  The individual log-levels can be enabled/disabled in the kernel
configuration and subsequently removed from the kernel (by the
compiler) entirely. It is not an option to filter out messages that
are simply above a certain log-level, although it could be more
convenient; controlling each log-level is the more general approach
and can be used to emulate the threshold filter. [8]

2.1.3. Classification tags

  It turns out that many messages share a similar purpose. It would be
useful to classify these by a different scheme than severity [6].
Therefore, an additional four special-purpose macros are defined:

   * printk_detected()    A "hardware detected" message
   * printk_registered()  A "device driver (un-)registered" message
   * printk_setting()     A "hardware setting change" message
   * printk_copyright()   A copyright message, such as module authorship
                          information

  Each message will be assigned the appropriate log-level for the
message class in question.

2.1.4. Blocks

  In order to print several related lines as one chunk, the emitter
should first allocate an object of the type struct kprint_block. This
struct is initialized with the function kprint_block_init() which
takes as arguments a pointer to an object of the type struct
kprint_block followed by the log-level number. The emitter may then
make as many or as few calls to kprint_block() that is desired. A
final call to kprint_block_flush() appends the messages to the kernel
message log in a single, atomic operation. After it has been flushed,
the struct is not usable again (unless it is re-initialized). If for
any reason the struct should be de-initialized without writing it to
the log, a call to kprint_block_abort() must be made.

Example: {
	struct kprint_block out;
	kprint_block_init(&out, KPRINT_DEBUG);
	kprint_block(&out, "Stack trace:");

	while(unwind_stack()) {
		kprint_block(&out, "%p %s", address, symbol);
	}
	kprint_block_flush(&out);
}

2.1.5. Subsystem/driver tags

  Many parts of the kernel already prefix their log messages with a
subsystem and/or driver tag to identify the source of a particular
message. With the kprint interface, these tags are redundant. Instead,
the macros SUBSYSTEM and KBUILD_MODNAME are used and recorded along
with each log message. Therefore, each source file should define the
macro SUBSYSTEM before any of the kprint functions are used. If this
macro is not defined, the recorded subsystem will be an empty string.
[6][7]

2.1.6. Early- and assembly functions

  It may happen that certain parts of the kernel might wish to emit
messages to the log (and console, if any) in an early part of the boot
procedure, for example before the main memory allocation routines have
been set up properly. For this purpose, a function kprint_early()
exists. This "early" is a minimal way for the kernel to log its
functions, and may as such not include all the features of the full
kprint system. When the kernel is beyond the critical "early" point,
the messages (if any) in the "early" log may be moved into the main
logging store and kprint_early() must not be used again.
kprint_early() is a function and may be called from assembly.

  To allow non-early calls from assembly, a function kprint_asm()
exists. This function takes a log-level number followed by a string
literal and a variable number of arguments.

2.1.7 Backwards compatibility

  The legacy printk() function is replaced by a backwards-compatible
interface but different implementation. In short, printk should parse
messages, remove (and convert) initial log-level tokens, remove any
newlines (splitting the string into several lines), and call the
appropriate kprint()-system functions.

  Because printk() itself remains a function with the same
specification, all printing/logging mechanisms based on it, such as
dev_printk(), sdev_printk(), and ata_dev_printk() will remain
functional. Alternatively, the macros could be changed to use the new
kprint API.


2.2. linux/kprint-light.h

  The kprint "light" interface provides a simpler interface that
covers the most frequent usage patterns. It should be noted that this
interface is preferred over the primary interface as it encourages the
use of a smaller set of log-levels [5].

  The interface consists primarily of the three macros, err(), warn(),
and info() that emit messages at the corresponding log-level.

  This header is optional and must not be included by other header
files. The names defined by this header are already used by different
parts of the kernel, but in different ways. With an optional header,
new code (or code converted to the kprint API) can explicitly request
these definitions while leaving old locations unchanged.


3. Internals

  Most of the kprint entry-points (especially kprint() and its
log-level variations) are implemented as macros in order to be able to
transparently pass extra information into the main kprint machinery.
This makes the interface abstract, because we can change the behaviour
(through the configuration and by adding extensions) without changing
the calling code. As an example, prepending the current file and line
(the __FILE__ and __LINE__ macros) to the message can be done in such
a way that it can be discarded at run-time, or recorded along with
(but separate from) the messages. This allows the compiler to
completely optimize out calls that are below a certain log-level
severity level [2][3].

  With such a modular interface, message attributes (for example the
current time) and arguments can also be recorded separately from the
actual format string, instead of written already formatted to a ring
buffer of characters. Parameters would be formatted to their own
strings (regardless of the original type) and saved in a list.

Example: {
	struct kprint_message {
		const char *format;
		struct kprint_arg *args;

	#ifdef KPRINT_TIMESTAMP
		unsigned long long timestamp;
	#endif

	#ifndef KPRINT_LOCATION
		const char *file;
		unsigned int line;

		const char *function;
	#endif
	};

	struct kprint_arg {
		struct kprint_arg *next;

		/* The string formatted argument, regardless
		 * of original type. */
		char *arg;
	};
}

  This can be a great help, for example in (user-space) localisation
of kernel messages [4], since the "static" message (ie. format string)
can be translated separately and the arguments re-attached at
run-time, possibly in a different order. A new kernel-/user-space
interface would be needed to retrieve the messages in this format,
though the syslog() and /proc/kmsg interfaces will retain backwards
compatibility by formatting messages as they are requested from
user-space.

  This does not mean that user-space is obliged provide any form of
lookup-/translation tables in order to read the kernel log; the kernel
simply hands over the format string used to format a particular
message in addition to the full log message, and this format string
may be used to easily look up translations (if they exist).

4. Considerations

  This scheme is obviously much more complex than the printk() is
today. But at the same time, it is also much more powerful,
extensible, and clearly/cleanly defined.

  The kernel can still used a fixed-size ring-buffer for storing the
kernel log. The ring-buffer would need to allow variable-sized
elements, instead of simply fixed-size chars. With a fixed, static
buffer, we are certain to never run into memory-related problems, even
if the rest of the system is unstable or unusable.

  It should be possible to optimize out multi-line (block) entries
based on log-level filtering even though the log-level is only given
in the first call (the initializer). It may take the shape of an
if-block that spans several macros. This is not very elegant or robust
if the macros are used incorrectly, however. Aborting a message can
also be hard this way (since the abort would usually appear inside an
if-statement that tests for some abnormal condition, thus appear in a
different block, and thoroughly mess up the bracket order).

Example: {
	#define kprint_block_init(block, loglevel)		\
		if(loglevel > CONFIG_KPRINT_LOGLEVEL_MAX) {	\
			kprint_real_block_init(block, loglevel);

	#define kprint_block(block, fmt, ...)			\
		kprint_real_block(block, fmt, ## __VA_ARGS__);

	#define kprint_block_flush(block)			\
			kprint_real_block_flush(block);		\
		}

	/* Thus, this C code: */
	kprint_block_init(&block, KPRINT_INFO);
	kprint_block(&block, "Hello world");
	kprint_block_flush(&block);

	/* Would pre-process into this: */
	if(6 < 4) {
		kprint_real_block_init(&block, 6);
		kprint_real_block(&block, "Hello world");
		kprint_block_flush(&block);
	}
}


References

[1] http://lkml.org/lkml/2007/9/21/267 (Joe Perches)
[2] http://lkml.org/lkml/2007/9/20/352 (Rob Landley)
[3] http://lkml.org/lkml/2007/9/21/151 (Dick Streefland)
[4] http://lkml.org/lkml/2007/6/13/146 (Michael Holzheu)
[5] http://lkml.org/lkml/2007/9/24/320 (Jesse Barnes)
[6] http://lkml.org/lkml/2007/9/22/162 (Miguel Ojeda)
[7] http://lkml.org/lkml/2007/9/25/62 (Vegard Nossum)
[8] http://lkml.org/lkml/2007/9/22/157 (Joe Perches)
