Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0BRBZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:25:59 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:27745 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751202Ab0BRBZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:25:58 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc code
Date: Thu, 18 Feb 2010 06:25:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: Cong Wang <amwang@redhat.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <4B7C178A.8010708@redhat.com> <m1zl37256o.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl37256o.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002180325.41403.opurdila@ixiacom.com>
X-OriginalArrivalTime: 18 Feb 2010 01:25:56.0830 (UTC) FILETIME=[51F7CFE0:01CAB039]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 February 2010 15:33:03 you wrote:
> Cong Wang <amwang@redhat.com> writes:
> > Octavian Purdila wrote:
> >> On Tuesday 16 February 2010 15:09:51 you wrote:
> >>> Octavian Purdila wrote:
> >>>> On Tuesday 16 February 2010 10:41:07 you wrote:
> >>>>>> +static int proc_skip_wspace(char __user **buf, size_t *size)
> >>>>>> +{
> >>>>>> +     char c;
> >>>>>> +
> >>>>>> +     while (*size) {
> >>>>>> +             if (get_user(c, *buf))
> >>>>>> +                     return -EFAULT;
> >>>>>> +             if (!isspace(c))
> >>>>>> +                     break;
> >>>>>> +             (*size)--; (*buf)++;
> >>>>>> +     }
> >>>>>> +
> >>>>>> +     return 0;
> >>>>>> +}
> >>>>>
> >>>>> In lib/string.c we have skip_spaces(), I think we can use it
> >>>>> here instead of inventing another one.
> >>>>
> >>>> I'm afraid we can't, skip_spaces does not accept userspace buffers.
> >>>
> >>> Well, you need to use copy_from_user() before call it.
> >>
> >> And how much would you copy? You need to either use a stack buffer and
> >> do a loop copy or you would need to copy the whole userspace buffer
> >> which means we need to allocate a kernel buffer. I think its much
> >> cleaner the way is currently done.
> >
> > Yeah, maybe just a personal preference. :-/
> 
> There can be valid security reasons for copying all of the data before
> processing it.
> 

How so? I only know about security issues when you copy & process the same 
data more than one time.

And all existing code I've looked over (proc_dointvec, proc_dostring, 
bitmap_parse_user) does not copy all of the data. In fact the code in question 
here is just existing code moved to its own function.

There must be a reason for doing that, as copying whole buffer seems like a 
much simple implementation? (my guess is to avoid an extra allocation)

> Semantically if we an guarantee that we either have processed the
> entire buffer or failed the entire buffer and no changes have occurred
> in the kernel that seems like a much easier semantic to work with in
> user space.
> 

OK, but this is not how various proc routines currently handles it. For 
example proc_dointvec won't undo the changes for previous items when we get an 
error and I think for good reasons as I don't see a clean and generic way to 
do the undo stuff. 





