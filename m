Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbZLQWt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbZLQWt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbZLQWt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:49:26 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:42553 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108AbZLQWtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lnooRw+DzTTeowhMfiQAWpRPi/uS6hGgIN3ilJ0RbhFfU50y4zoY+9N3WEVGasX262
         ZabNkwwd3Sa9IVviMrlNCWr+DUdy06hiGNkfN+IXKq5PH2aCy2/bEaxj/B3tsihKAPbr
         0V4Yp183ItGrSeBEad80RxrRqeAuFix6Wv7Jg=
MIME-Version: 1.0
In-Reply-To: <20419.1260982769@redhat.com>
References: <1260921350-6539-1-git-send-email-vapier@gentoo.org> 
	<20419.1260982769@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 17 Dec 2009 17:49:04 -0500
Message-ID: <8bd0f97a0912171449x1b6cad88kd5a58c1d00c20d3c@mail.gmail.com>
Subject: Re: [uClinux-dev] Re: [PATCH] NOMMU: add [stack] label to per-process 
	maps output
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 11:59, David Howells wrote:
> Mike Frysinger wrote:
>> +             if (vma->vm_start <= mm->start_brk &&
>> +                             vma->vm_end >= mm->brk) {
>
> Hmmm...  That ought to involve mm->start_stack somewhere...  (Or, more
> probably, task->stack_start:-/)

with MMU, the [heap] (i.e. brk) and [stack] are different mappings.
under NOMMU, they're the same mapping, except that no one uses the brk
and the "heap" is really all of dynamic kernel memory.  so we have to
avoid the brk/[heap] check and simply copy over the [stack] one:
    } else if (mm) {
        if (vma->vm_start <= mm->start_stack &&
                vma->vm_end >= mm->start_stack) {
            pad_len_spaces(m, len);
            seq_puts(m, "[stack]");
        }
    }

the semi-annoying thing is that FLAT combines a whole lot of stuff
(including the stack) into the same mapping giving us the output:
root:/> cat /proc/155/maps
029f0000-029f9000 rwxp 00000000 00:00 0          [stack]

but i guess this is no worse than the current ?
-mike
