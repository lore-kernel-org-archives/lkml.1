Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZA3WCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZA3WCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZA3WCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:02:00 -0500
Received: from relay03.pair.com ([209.68.5.17]:3386 "HELO relay03.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755454AbZA3WB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:01:57 -0500
X-pair-Authenticated: 66.134.71.115
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Fri, 30 Jan 2009 14:01:49 -0800
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
From: Grant Erickson <gerickson@nuovations.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Wolfgang Denx <wd@denx.de>
Message-ID: <C5A8B8CD.143B5%gerickson@nuovations.com>
Thread-Topic: [RFC] Add Alternative Log Buffer Support for printk Messages
Thread-Index: AcmDJll7NTrcufSqmkCvsTJ7p6iQoA==
In-Reply-To: <20090130115108.592ba38d.akpm@linux-foundation.org>
Organization: Nuovation System Designs, LLC
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/09 11:51 AM, Andrew Morton wrote:
> On Wed, 21 Jan 2009 09:39:46 -0800
> Grant Erickson <gerickson@nuovations.com> wrote:
>> This merges support for the previously DENX-only kernel feature of
>> specifying an alternative, "external" buffer for kernel printk
>> messages and their associated metadata. In addition, this ports
>> architecture support for this feature from arch/ppc to arch/powerpc.
>> 
>> When this option is enabled, an architecture- or machine-specific log
>> buffer is used for all printk messages. This allows entities such as
>> boot loaders (e.g. U-Boot) to place printk-compatible messages into
>> this buffer and for the kernel to coalesce them with its normal
>> messages.
>> 
>> Signed-off-by: Grant Erickson <gerickson@nuovations.com>
>> ---
>> 
>> The code has historically been used and proven to work on the LWMON5
>> platform under arch/ppc and is now used (by me) successfully on the
>> AMCC Haleakala and Kilauea platforms.
>> 
>> As implemented for arch/powerpc, two suboptions for the alternative
>> log buffer are supported. The buffer may be contiguous with the
>> metadata and message data colocated or the metadata and message
>> storage may be in discontiguous regions of memory (e.g. a set of
>> scratch registers and an SRAM buffer). On Kilauea and Haleakala, I
>> have used the former; whereas LWMON5 has traditionally used the latter.
>> 
>> The code here is, more or less, as-is from the DENX GIT tree. Comments
>> welcome. Some prior discussion from the linuxppc-dev mailing list is at
>> http://ozlabs.org/pipermail/linuxppc-dev/2008-November/065589.html.
>> 
> 
> I'm not completely clear what all this exactly does.  Let me try...
> 
> We have an external log buffer, into which stuff was written by (say)
> the boot prom code.
> 
> We want that to come out on the console during bootup.
> 
> So what we do is to divert the normal printk log buffer so that it
> starts writing at the tail of that existing external buffer.  We emit
> the entire buffer some time during bootup.  We henceforth continue to
> use that external buffer in the normal manner. If so, why do it this way?

Andrew,

Thanks for your feedback. Your summary is precisely the intent. As I
mentioned in check-in notice, this isn't my work per se, but a fix of prior
unsubmitted work. Consequently, I can only speculate on the original
implementation choices of the primary authors (Yuri Tikhonov
<yur@emcraft.com> on behalf of Denx from what I can ascertain from GIT
logs). I've added Wolfgang in the event he can add background where
appropriate.

I believe this to be a useful feature for the embedded system space;
however, I am not wedded in any way to the current implementation and am
happy to evolve it as needed to meet the needs of key stakeholders.

> Why not just copy the external buffer's contents into the normal buffer during
> bootup?  ie: printk("%s", external_buffer).

Again, conjecturing, I suspect the goal was to ensure that the boot messages
appear on the console or in the syslog before kernel messages of that
particular boot cycle. Depending on the board and architecture in question,
the kernel log buffer may have several messages in it by the time the log
coalescing code runs. For example, on the board I tested this on:

    # dmesg
    U-Boot 1.3.3 (Jan  9 2009 - 10:24:45)
    POST memory PASSED
    POST ecc PASSED
    POST cache PASSED
    POST ethernet PASSED
    Using Kilauea machine description
    log_buf=fdffc000
    Linux version 2.6.27.7 (gerickson@ubuntu-fusion) (gcc version 4.0.0
(DENX ELDK 4.1 4.0.0)) #1 Fri Jan 9 10:30:30 PST 2009

"Using Kilauea..." is already in the kernel buffer when the time comes
around to coalesce the buffer.

In the case of u-boot, it uses logging code nearly identical to Linux, so
employing the straightforward approach of 'printk("%s", external_buffer)'
would result in:

    # dmesg
    U-Boot 1.3.3 (Jan  9 2009 - 10:24:45)
    <4>POST memory PASSED
    <4>POST ecc PASSED
    <4>POST cache PASSED
    <4>POST ethernet PASSED
    Using Kilauea machine description

Not the end of the world, but not ideal either.

> I think a quite bad part of this feature is that it renders the
> kernel's log_buf_len boot parameter (and its Kconfig defult)
> ineffective.  That's a pretty useful feature - people often set it to
> 1MB or more during problem diagnosis, and the new unalterable 16kbytes
> is very very small.

Agreed; however, I'm not sure how often this technique is employed in
embedded systems versus desktop systems.

I'd be happy to keep the existing log buffer and perform a prepend from the
boot buffer to it rather than an append of the kernel buffer to the boot
buffer. Thoughts?

>> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
>> index 3a2dc7e..60282f1 100644
>> --- a/arch/powerpc/kernel/prom.c
>> +++ b/arch/powerpc/kernel/prom.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/debugfs.h>
>>  #include <linux/irq.h>
>>  #include <linux/lmb.h>
>> +#include <linux/logbuff.h>
>>  
>>  #include <asm/prom.h>
>>  #include <asm/rtas.h>
>> @@ -61,6 +62,15 @@
>>  #define DBG(fmt...)
>>  #endif
>>  
>> +#ifdef CONFIG_LOGBUFFER
>> +#ifdef CONFIG_ALT_LB_LOCATION
> 
> CONFIG_ALT_LB_LOCATION depends upon CONFIG_LOGBUFFER, so we only need
> 
> #ifdef CONFIG_ALT_LB_LOCATION
> 
> here.  There are several instances of this in the patch.

On the PPC mailing list, there were some solid proposals using the device
tree that would make the configuration a bit cleaner. In those cases,
there's simply a board/architecture method/probe enabled by Kconfig that
would perform the aforementioned prepend operation.

Thoughts? 

>> +#ifndef _LOGBUFF_H_
>> +#define _LOGBUFF_H_
>> +
>> +#ifdef CONFIG_LOGBUFFER
>> +
>> +#define LOGBUFF_MAGIC  0xc0de4ced
> 
> What is the meaning of this value?  Is it random, or does it correspond
> to some powerpc firmware thing, or??

It's defined by u-boot and used by u-boot in relation to how it manages POST
status and its log buffer.

> Do we actually need this magic number?  All it appears to do is to
> cause a warning.
> 
> The magic number could/should be placed in magic.h.

Wolfgang?

> 
>> +#define LOGBUFF_LEN  16384
>> +#define LOGBUFF_OVERHEAD 4096
>> +#define LOGBUFF_RESERVE  (LOGBUFF_LEN + LOGBUFF_OVERHEAD)
> 
> What is LOGBUFF_OVERHEAD supposed to do?
> 
> afacit both LOGBUFF_OVERHEAD and LOGBUFF_RESERVE are unused and
> could/should be removed.

Again, I am simply conjecturing here; however, I would guess that for the
case of the co-located boot log metadata and buffer data, there was a desire
to provide a buffer of the same page-aligned size as the default kernel
buffer (16 KiB) and then a desire to use 5 words of metadata but, again,
keep things "easy" by just stealing/reserving a whole, additional page.

Wolfgang?

>> +#ifdef CONFIG_ALT_LB_LOCATION
>> +# define LOGBUFF_VOLATILE volatile
>> +#else
>> +# define LOGBUFF_VOLATILE
>> +#endif /* defined(CONFIG_ALT_LB_LOCATION) */
> 
> Why does this code use volatiles?  Please see
> Documentation/volatile-considered-harmful.txt

I've definitely read and understand it. Again, conjecturing here, but I
would guess that for the non-colocated buffer/metadata case, the original
author(s) were perhaps trying to avoid placing xe32_to_cpu or such in the
generic kernel logging code.

If we take the prepend-and-preserve-the-kernel-buffer tack, I think this
would all largely get cleaned-up and disappear. Prepend I/O would then be
relegated to architecture- or board-specific code.

Thoughts? Wolfgang?

>> lock_kernel();
>> tick_init();
>> boot_cpu_init();
>> diff --git a/kernel/printk.c b/kernel/printk.c
>> index f492f15..59884e2 100644
>> --- a/kernel/printk.c
>> +++ b/kernel/printk.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/security.h>
>>  #include <linux/bootmem.h>
>>  #include <linux/syscalls.h>
>> +#include <linux/logbuff.h>
>>  
>>  #include <asm/uaccess.h>
>>  
>> @@ -101,9 +102,39 @@ static DEFINE_SPINLOCK(logbuf_lock);
>>   * The indices into log_buf are not constrained to log_buf_len - they
>>   * must be masked before subscripting
>>   */
>> +#ifdef CONFIG_LOGBUFFER
>> +/* Indexes to the local log buffer */
>> +static unsigned long _log_start;
>> +static unsigned long _con_start;
>> +static unsigned long _log_end;
>> +static unsigned long _logged_chars;
>> +/* These will be switched to the external log buffer */
>> +#ifndef CONFIG_ALT_LB_LOCATION
>> +/* usual logbuffer location */
>> +static unsigned long *ext_log_start = &_log_start;
>> +static unsigned long *ext_con_start = &_con_start;
>> +static unsigned long *ext_log_end = &_log_end;
>> +static unsigned long *ext_logged_chars = &_logged_chars;
>> +#define log_start (*ext_log_start)
>> +#define con_start (*ext_con_start)
>> +#define log_end  (*ext_log_end)
>> +#define logged_chars (*ext_logged_chars)
>> +#else /* defined(CONFIG_ALT_LB_LOCATION) */
>> +/* alternative logbuffer location */
>> +static volatile unsigned long *ext_log_start = &_log_start;
>> +static volatile unsigned long *ext_con_start = &_con_start;
>> +static volatile unsigned long *ext_log_end = &_log_end;
>> +static volatile unsigned long *ext_logged_chars = &_logged_chars;
>> +#define log_start       (*((volatile u32 *)ext_log_start))
>> +#define con_start       (*((volatile u32 *)ext_con_start))
>> +#define log_end         (*((volatile u32 *)ext_log_end))
>> +#define logged_chars    (*((volatile u32 *)ext_logged_chars))
>> +#endif /* !defined(CONFIG_ALT_LB_LOCATION) */
>> +#else /* !defined(CONFIG_LOGBUFFER) */
>>  static unsigned log_start; /* Index into log_buf: next char to be read by
>> syslog() */
>>  static unsigned con_start; /* Index into log_buf: next char to be sent to
>> consoles */
>>  static unsigned log_end; /* Index into log_buf: most-recently-written-char +
>> 1 */
>> +#endif /* CONFIG_LOGBUFFER */
> 
> ick.

See comments above.

If you and Wolfgang are supportive of the prepend and preserve approach, I
think I can take another pass at this and eliminate a good measure of the
implementation concerns.

I welcome your further feedback.

Regards,

Grant


