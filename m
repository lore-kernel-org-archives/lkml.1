Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXKMNZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXKMNZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbXKMNZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:25:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51159 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbXKMNZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:25:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp>
	<20071107192211.c1c22e97.akpm@linux-foundation.org>
	<200711080819.lA88J8Pv072259@www262.sakura.ne.jp>
	<m14pfr6bnf.fsf@ebiederm.dsl.xmission.com>
	<200711130307.lAD37Nee045340@www262.sakura.ne.jp>
	<20071112191320.55e49462.akpm@linux-foundation.org>
	<200711130350.lAD3oWnt054039@www262.sakura.ne.jp>
Date: Tue, 13 Nov 2007 06:24:39 -0700
In-Reply-To: <200711130350.lAD3oWnt054039@www262.sakura.ne.jp> (Tetsuo Handa's
	message of "Tue, 13 Nov 2007 12:50:32 +0900")
Message-ID: <m1bq9y2s88.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> writes:

> Hello.
>
> Andrew Morton wrote:
>> I believe (args->nlen > CTL_MAXNAME) was correct.
> I'll leave it to you.
> But if you want to allow args->nlen == CTL_MAXNAME,
> you also need to update do_sysctl().

Which has been that way since before I decided to touch it. 2.6.12-rc1.
I haven't tracked it before then as I don't expect to see anything.

And that is why -ENOTDIR.  That is the historical error code from sysctl in
this case.

> int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user
> *oldlenp,
>                void __user *newval, size_t newlen)
> {
>         ...
>         if (nlen <= 0 || nlen >= CTL_MAXNAME)
>                 return -ENOTDIR;
>         ...
> }

CTL_MAXNAME is fairly arbitrary, and since the set of binary paths is fixed.
So it feels to me like the code really should read:

        if (nlen <= 0 || nlen > CTL_MAXNAME)
                return -ENOTDIR;

In both places. Just because that is what the comment describes.

I think in reality CTL_MAXNAME is actually 5 but I would have to look a little
more closely to confirm that.

Eric
