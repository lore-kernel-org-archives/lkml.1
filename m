Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZHFFGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZHFFGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZHFFGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:06:16 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:45644 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZHFFGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jC7C3BfpO4nKO/9eQO6jXWzBskpXjugpXeMpes4vssWx0I/GGod1kU7T/kDZ4x8awl
         c3yysm8ARryUT7q97UPf7mOgLGpt4p6ZJsqJB0raz7MFDeeoYk9u0P43oO7DoDzPMfD2
         WlEc/6ihjPupKBic8fld7dxBQea9mag2ipqJg=
MIME-Version: 1.0
In-Reply-To: <20090805163325.14a4a77f.akpm@linux-foundation.org>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
	 <20090804192721.6A49.A69D9226@jp.fujitsu.com>
	 <20090805163325.14a4a77f.akpm@linux-foundation.org>
Date: Thu, 6 Aug 2009 14:06:11 +0900
X-Google-Sender-Auth: 1dcefaa41fdae919
Message-ID: <2f11576a0908052206t421686c9q9a458afee49b1d6f@mail.gmail.com>
Subject: Re: [PATCH 4/4] oom: fix oom_adjust_write() input sanity check.
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1033,12 +1033,15 @@ static ssize_t oom_adjust_write(struct f
>>               count = sizeof(buffer) - 1;
>>       if (copy_from_user(buffer, buf, count))
>>               return -EFAULT;
>> +
>> +     strstrip(buffer);
>
> +1 for using strstrip()
>
> -1 for using it wrongly.  If it strips leading whitespace it will
> return a new address for the caller to use.

Will fix. thanks.

Paul, hehe your kernel/cgroup.c parsing have the same problem. Could you
please fix it too? :-)

> We could mark it __must_check() to prevent reoccurences of this error.
>
> How does this look?

I see.
I'll do and send it.

>
> --- a/fs/proc/base.c~oom-fix-oom_adjust_write-input-sanity-check-fix
> +++ a/fs/proc/base.c
> @@ -1033,8 +1033,7 @@ static ssize_t oom_adjust_write(struct f
>        if (copy_from_user(buffer, buf, count))
>                return -EFAULT;
>
> -       strstrip(buffer);
> -       oom_adjust = simple_strtol(buffer, &end, 0);
> +       oom_adjust = simple_strtol(strstrip(buffer), &end, 0);
>        if (*end)
>                return -EINVAL;
>        if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
>
>
>>       oom_adjust = simple_strtol(buffer, &end, 0);
>
> That should've used strict_strtoul() but it's too late to fix it now.

Perhaps, it's not too late. I never seen userland program pass non number value
into this.
