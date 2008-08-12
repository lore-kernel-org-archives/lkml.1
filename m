Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbYHLEDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbYHLEDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 00:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbYHLEDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 00:03:23 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:50724 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYHLEDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 00:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ryKyQ/pmDoFp5BAZ7Hpp7yOkxjisuKuPSq0JBXpy9r0VfwRA704ZOpOlZM7urcWDoL
         g+xtf9Xgm3XCb0EL+nSzUQlk/DBU1S92k1WVyzsk9BK/XIjXiA87NUIjJfb6vWwWA3ab
         ATYGB3X6h298q+a+pGU6DRlodSHYzEzr+HL5w=
Message-ID: <12e8e7240808112103m21659d4fg3f30a139ae493473@mail.gmail.com>
Date: Tue, 12 Aug 2008 00:03:21 -0400
From: "Javeed Shaikh" <syscrash2k@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
In-Reply-To: <12e8e7240808111951o19afce35h48b693a618bd6120@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12e8e7240808111951o19afce35h48b693a618bd6120@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spoke too soon. The problem still exists with my workaround on the
latest git kernel,
but it seems to be harder to reproduce.

On Mon, Aug 11, 2008 at 10:51 PM, Javeed Shaikh <syscrash2k@gmail.com> wrote:
> Ico Doornekamp wrote:
>> Hello,
>>
>> Recently my X terminals showed annoying behaviour where the application
>> in the terminal was not resized properly to the actual size of the X
>> terminal emulator window, resulting in a lot of misaligned text on the
>> screen. Hunting the issue down from the windowmanager and the terminal
>> emulator program, I suspect the problem might lie in the kernel. I'm
>> running 2.6.26 on a dual core i386.
>>
>> What I see is this: the userspace application receives a SIGWINCH signal
>> and acquires the terminal size usign the TIOCGWINSZ ioctl. It seems that
>> in some cases the old instead of the new terminal size is returned.
>> A small delay before the ioctl seems to 'fix' this behaviour.
>>
>> I noticed some changes involving locking in the the pty code in the last
>> kernel verions, could one of these changes cause the above behaviour ? If
>> so, wouldn't this affect much more users ?
>>
>> Ico
>
> Hi,
>
> I've been experiencing similar issues.
> Here's a screenshot: http://omploader.org/vbzA1 .
> Note how emacs is only taking up half of the terminal's total height.
>
> However, my diagnostics are different from yours. Sending SIGWINCH
> (in this case, to emacs) fixes the issue, at least temporarily. However,
> sending SIGWINCH to the shell process under which emacs is running
> (using a negative PID, to specify the "process group") has no visible effect.
> I believe the issue has to do with sending SIGWINCH to process groups,
> though I do not have enough experience in this area to be sure.
>
> git-bisect tracked it down to this:
> 46151122e0a2e80e5a6b2889f595e371fe2b600d is first bad commit
> commit 46151122e0a2e80e5a6b2889f595e371fe2b600d
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Thu May 8 17:00:42 2008 +0200
>
>    sched: fix weight calculations
>
> Starting at v2.6.26, I wasn't able to easily revert the commit. However,
> the following "patch" seems to have alleviated the problem.
>
> === begin patch ===
> diff --git a/kernel/sched_features.h b/kernel/sched_features.h
> index 1c7283c..0e269ed 100644
> --- a/kernel/sched_features.h
> +++ b/kernel/sched_features.h
> @@ -1,4 +1,4 @@
> -SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
> +SCHED_FEAT(NEW_FAIR_SLEEPERS, 0)
>  SCHED_FEAT(WAKEUP_PREEMPT, 1)
>  SCHED_FEAT(START_DEBIT, 1)
>  SCHED_FEAT(AFFINE_WAKEUPS, 1)
> === end patch ===
>
> This is merely a workaround, however.
>
> I was able to easily revert commit 46151122e0a2e80e5a6b2889f595e371fe2b600d on
> the latest git version of the kernel. However, it did not alleviate the problem.
>
> As in v2.6.26, the above patch (disabling NEW_FAIR_SLEEPERS) seems to work well.
>
