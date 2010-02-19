Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0BSPt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:49:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35140 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0BSPtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:49:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QqFgvfF7KlHrSqJidgG/IRkRvDzd4mnq3Tvn9SCyVueMdQQfi+wpUa8Gtm3WUtwObh
         nBp8IgIoZuO0KfjBtnfQ+BmWBz1qhtvL4BJOWeRa/arJBef4jPdcw1LFZD/IlukIWMYB
         MTxu6WlRL5NWoA3PtlN6ZQxviMBIXMNvIGoE0=
MIME-Version: 1.0
In-Reply-To: <20100219085831.GA10837@in.ibm.com>
References: <4B7881AC.5070209@redhat.com>
	 <1266516001-7753-3-git-send-regression-fweisbec@gmail.com>
	 <20100219085831.GA10837@in.ibm.com>
Date: Fri, 19 Feb 2010 16:49:53 +0100
Message-ID: <c62985531002190749o250f7598gde0ab14cff4cce9a@mail.gmail.com>
Subject: Re: [PATCH 2/2] hw-breakpoint: Keep track of dr7 local enable bits
From: Frederic Weisbecker <fweisbec@gmail.com>
To: prasad@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/19 K.Prasad <prasad@linux.vnet.ibm.com>:
> On Thu, Feb 18, 2010 at 07:00:01PM +0100, Frederic Weisbecker wrote:
>
>> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
>> index 017d937..0c1033d 100644
>> --- a/arch/x86/kernel/ptrace.c
>> +++ b/arch/x86/kernel/ptrace.c
>> @@ -702,7 +702,7 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
>>       } else if (n == 6) {
>>               val = thread->debugreg6;
>>        } else if (n == 7) {
>> -             val = ptrace_get_dr7(thread->ptrace_bps);
>> +             val = thread->ptrace_dr7;
>
> Some more comments that I missed out in the previous mail...
>
> Shouldn't ptrace_get_dr7() function be entirely removed now, given that
> its only caller no longer invokes it?


Not in this set. This is an urgent fix, we shouldn't take corner risks
so late in the process.

Also, this thread->ptrace_dr7 is a temporary thing, a hack to fix a
regression without
taking too much risk. But we need something more proper in the longer term, like
storing this information in the arch_hw_breakpoint (we shouldn't bloat
the thread
structure with such mostly unused field).

I have some ideas to get the arch_hw_breakpoint more "arch", to
register breakpoints
using arch informations only, so that we don't depend on a generic
breakpoint attribute
conversion for ptrace, which may be too limited for tricky arch
breakpoint implementations,
and an unecessary midlayer there.
I'll tell you more while answering to your ppc breakpoint implementation.



>>       }
>>       return val;
>>  }
>> @@ -778,8 +778,11 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
>>                       return rc;
>>       }
>>       /* All that's left is DR7 */
>> -     if (n == 7)
>> +     if (n == 7) {
>>               rc = ptrace_write_dr7(tsk, val);
>
> And ptrace_write_dr7() should be made to populate thread->ptrace_dr7 if
> it is going to return a success.


Yeah we can do that from ptrace_write_dr7(). Either way.
It's just more quick to do that here. I did not think much
about it as I don't think about ptrace_dr7 as a long term field.

Thanks.


>> +             if (!rc)
>> +                     thread->ptrace_dr7 = val;
>> +     }
>>
>>  ret_path:
>>       return rc;
