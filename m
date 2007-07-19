Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbXGSFCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbXGSFCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 01:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXGSFCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 01:02:14 -0400
Received: from wynq.bellnexxia.net ([209.226.175.204]:55249 "EHLO
	toq8-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXGSFCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 01:02:13 -0400
X-Greylist: delayed 9343 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 01:02:13 EDT
Message-ID: <469ECBD1.8080404@yahoo.ca>
Date: Wed, 18 Jul 2007 22:26:25 -0400
From: Stephane Couture <muscou@yahoo.ca>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Andrew Morton <akpm@linux-foundation.org>
CC: Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
Subject: Re: early_printk accessing __log_buf
References: <200707181756.44074.rgetz@blackfin.uclinux.org>	<20070718151617.fe6a2943.akpm@linux-foundation.org>	<200707181939.46910.rgetz@blackfin.uclinux.org> <20070718172603.231351ea.akpm@linux-foundation.org>
In-Reply-To: <20070718172603.231351ea.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 18 Jul 2007 19:39:46 -0400
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
>> On Wed 18 Jul 2007 18:16, Andrew Morton pondered:
>>> I'd suggest that any interface into here should be via function calls,
>>> not via direct access to printk internals: think up some nice
>>> copy_me_some_of_the_log_buffer() interface.
>> If so - I would still like to put it in:
>>  - ifdef CONFIG_EARLY_PRINTK
>>  - and define as __init
>>
>> so that people don't use it when they shouldn't (when the kernel is up an 
>> running).
>>
>> Something simple like - early_copy_log_buff(void *dest, size_t n) 
>>
>> copies n bytes from log_buf to memory area dest. Returns number of bytes that 
>> could not be copied. Can find out how many bytes are in the log_buff by 
>> calling with zero size.
>>
>> This is not destructive to existing interfaces (log_start and con_start are 
>> not updated/used). This should ensure that if booting does work - that normal 
>> messages come out the standard method.
>>
>> Any other suggestions?
>>
> 
> When I was at $EARLIER_EMPLOYER, we had code in there to copy the last
> kilobyte-odd of the log buffer into flash when the box oopsed.
> 
> So there's one instance proof that something more general would be needed. 
> Probably there are others, but they'll mainly be in the consumer/embedded
> area, and those sorts of engineers don't read this mailing list much.
> 

We log everything to SRAM so having the option to select the buffer 
destination address would be nice.  My crude way of doing it:

--- 2.6.21/kernel/printk.c@@/main/1      2007-04-27 05:34:35.000000000
-0400
+++ 2.6.21/kernel/printk.c@@/main/2      2007-05-01 02:27:18.000000000 -0400
@@ -94,7 +94,12 @@
   */
  static unsigned long log_start;        /* Index into log_buf: next 
char to be read by syslog() */
  static unsigned long con_start;        /* Index into log_buf: next 
char to be sent to consoles */
+#ifndef CONFIG_LOG_BUF_ALTERNATE_ADRS
  static unsigned long log_end;  /* Index into log_buf: 
most-recently-written-char + 1 */
+#else
+extern int alt_log_end_adrs;
+#define log_end (*(unsigned long*)alt_log_end_adrs)
+#endif

  /*
   *     Array of consoles built from command line options (console=)
@@ -117,8 +122,14 @@

  #ifdef CONFIG_PRINTK

+#ifndef CONFIG_LOG_BUF_ALTERNATE_ADRS
  static char __log_buf[__LOG_BUF_LEN];
  static char *log_buf = __log_buf;
+#else
+extern int alt_log_buf_adrs;
+#define __log_buf ((unsigned char*)alt_log_buf_adrs)
+#define log_buf ((unsigned char*)alt_log_buf_adrs)
+#endif
  static int log_buf_len = __LOG_BUF_LEN;
  static unsigned long logged_chars; /* Number of chars produced since 
last read+clear operation */


