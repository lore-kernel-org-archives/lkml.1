Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbYGABai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbYGABai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbYGABa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:30:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:57805 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbYGABa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eP4RFaFBNFxU/f8SYMxP7eKSKpjsL+ZRBdywtyFqiWrCTIOJRaPiaaDR9X+d1z1bSl
         ZUApQGRm9EKVLiLauWSjVHXaDZAEwQ+dm4ba550BiKfSiKLBKbXpu1nkV2wZTKGx5+Wu
         hI4Lk20yurMmdISC3p1ArZJ/IzEBAEvRXZzQM=
Message-ID: <cfd18e0f0806301830s7193c340k1dc857885cfc7803@mail.gmail.com>
Date: Tue, 1 Jul 2008 03:30:24 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "john stultz" <johnstul@us.ibm.com>
Subject: Re: ADJ_OFFSET_SS_READ bug?
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1214863650.3143.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E0007.2020904@gmail.com>
	 <1214863650.3143.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 12:07 AM, john stultz <johnstul@us.ibm.com> wrote:
>
> On Sun, 2008-06-22 at 09:32 +0200, Michael Kerrisk wrote:
>> Roman, John
>>
>> John, thanks for ADJ_OFFSET_SS_READ, which fixed my bug report
>> (http://sourceware.org/bugzilla/show_bug?id=2449,
>> http://bugzilla.kernel.org/show_bug.cgi?id=6761)
>>
>> Roman, thanks for fixing John's fix ;-)
>>
>> However, I'm wondering if there is a potential bug in the
>> implementation of this flag.  Note the following definitions
>> from include/linux/timex.h:
>>
>> #define ADJ_OFFSET              0x0001  /* time offset */
>> [...]
>> #define ADJ_OFFSET_SINGLESHOT   0x8001  /* old-fashioned adjtime */
>> #define ADJ_OFFSET_SS_READ      0xa001  /* read-only adjtime */
>>
>>
>> Using the the above value for ADJ_OFFSET_SS_READ, where the bits match those
>> in ADJ_OFFSET and ADJ_OFFSET_SINGLESHOT, seems unnecessary as far as I can
>> see.  Why was that done?
>
> Hrm. My original fix was to use 0x2000, but from the commit Ingo changed
> it at Ulrich's suggestion. Had something to do with old glibc's doing
> the right thing?
>
>> More to the point, it looks like it creates a bug, since the "read-only
>> adjtime" triggers the code path for ADJ_OFFSET:
>>
>>          if (txc->modes) {
>>                  ...
>>                  if (txc->modes & ADJ_OFFSET) {
>>                          if (txc->modes == ADJ_OFFSET_SINGLESHOT)
>>                                  /* adjtime() is independent from ntp_adjtime() */
>>                                  time_adjust = txc->offset;
>>                          else
>>                                  ntp_update_offset(txc->offset); /*XXX*/
>>                  }
>>                  if (txc->modes & ADJ_TICK)
>>                          tick_usec = txc->tick;
>>
>>                  if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
>>                          ntp_update_frequency(); /*XXX*/
>>          }
>>
>> Unless I misunderstood something, ADJ_OFFSET_SS_READ causes the code marked
>> XXX to be executed, but I don't think that is what is desired.  Is that true?
>
> Yea. That does look like an issue. Thanks for the close inspection and
> review!

You're welcome -- thanks for getting back to me (I was beginning to
wonder if my mail got dropped somewhere)/

> Sort of a quick off the cuff patch, but does the following look like the
> right fix to you?

I haven't tested this, but given your statement about maintaining old
glibc behavior, this looks like the riht fix, so:

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

> Roman: your thoughts?
>
>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 5125ddd..7842a8d 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -379,13 +379,14 @@ int do_adjtimex(struct timex *txc)
>                        if (txc->modes == ADJ_OFFSET_SINGLESHOT)
>                                /* adjtime() is independent from ntp_adjtime() */
>                                time_adjust = txc->offset;
> -                       else
> +                       else if (txc->modes != ADJ_OFFSET_SS_READ)
>                                ntp_update_offset(txc->offset);
>                }
>                if (txc->modes & ADJ_TICK)
>                        tick_usec = txc->tick;
>
> -               if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
> +               if ((txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET)) &&
> +                               (txc->modes != ADJ_OFFSET_SS_READ))
>                        ntp_update_frequency();
>        }
>
>
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
