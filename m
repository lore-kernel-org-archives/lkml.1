Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0BICoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:44:11 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39556 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0BICoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:44:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N0AnsHeIHu2LaXBbuaGaQPCU6kQLfgXD7ZKMhIcDnyb9O8XIr7Ej+LbTpNsaUwxYyL
         ImnINAn2fQJGVtC9A30rr8cd8qEYWWU6bFNWscTVCzcG7tmnyDZfa40281z0cKXb8CCS
         rOZVsSHp8eWXra4HUK39csynaFaW/C96f1NZM=
MIME-Version: 1.0
In-Reply-To: <20100208140648.3c38d909.akpm@linux-foundation.org>
References: <20100206133425.GA2562@darkstar>
	 <20100208140648.3c38d909.akpm@linux-foundation.org>
Date: Tue, 9 Feb 2010 10:44:07 +0800
Message-ID: <a8e1da1002081844j7f91ee3fgf69d71bf235a09ed@mail.gmail.com>
Subject: Re: [PATCH 1/2] printk delay for each line break instead of callback
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 6:06 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 6 Feb 2010 21:34:25 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> printk delay for every callback does not make sense, change to delay every line
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>>
>>  kernel/printk.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-2.6.orig/kernel/printk.c    2010-02-02 13:38:47.646659531 +0800
>> +++ linux-2.6/kernel/printk.c 2010-02-02 13:39:19.446657319 +0800
>> @@ -678,7 +678,6 @@ asmlinkage int vprintk(const char *fmt,
>>       char *p;
>>
>>       boot_delay_msec();
>> -     printk_delay();
>>
>>       preempt_disable();
>>       /* This stops the holder of console_sem just where we want him */
>> @@ -746,6 +745,7 @@ asmlinkage int vprintk(const char *fmt,
>>        */
>>       for ( ; *p; p++) {
>>               if (new_text_line) {
>> +                     printk_delay();
>>                       /* Always output the token */
>>                       emit_log_char('<');
>>                       emit_log_char(current_log_level + '0');
>
> This moves the printk_delay() so that it is now inside
> spin_lock_irqsave(logbuf_lock).
>
> This fixes the race I mentioned in the previous email, but it seems a
> bad idea.  If the delay is long enough, it could even cause other CPUs
> to get hit by the NMI watchdog when trying to acquire logbuf_lock.
>
> A better approach would be to perform the calculation of "how long must
> I delay" at this site, but perform the actual delay later, after the
> raw_local_irq_restore().  This means that if the printk contains
> "a\nb\nc\n" then we won't delay until the final \n, but that seems a
> fairly small problem.
>

Ok, agree. But need another variable to track '\n', if there's no line
break then
it will not delay at the end of printk.

-- 
Regards
dave
