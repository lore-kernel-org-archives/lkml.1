Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYLZGrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYLZGrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLZGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 01:47:12 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:62866 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYLZGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 01:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wugtEuoZ0xQ8mldfkMfecreovBYgCz8UYCe8yYpeXIEsReRJ8BQy/ypc66IjrW0lfu
         VUHkr7b1D/GYVY9obyLD0lpOaWzOUH2QUEscLWwtyIVJtz8ZeJp4cA1Cg4R25wU8cZMM
         +jA8LhPV7t0ZUc3QhU3Xy6rYcmuak7iA6Vgv0=
Date: Fri, 26 Dec 2008 14:45:48 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Check return from argv_split() in do_coredump().
Message-ID: <20081226144548.GB3156@hack.private>
References: <200812240616.mBO6GGEe078727@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812240616.mBO6GGEe078727@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 03:16:16PM +0900, Tetsuo Handa wrote:
>do_coredump() accesses helper_argv[0] without checking helper_argv != NULL.
>Though, likely helper_argv != NULL.
>
>Below versions have this problem.
>
>  2.6.24.7
>  2.6.25.20
>  2.6.26.8
>  2.6.27.10
>  2.6.28-rc9
>  mmotm 2008-12-22-16-14
>
>Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>---
> fs/exec.c |    5 +++++
> 1 file changed, 5 insertions(+)
>
>--- linux-2.6.28-rc9-mm1.orig/fs/exec.c
>+++ linux-2.6.28-rc9-mm1/fs/exec.c
>@@ -1809,10 +1809,15 @@ int do_coredump(long signr, int exit_cod
> 	if ((!ispipe) && (core_limit < binfmt->min_coredump))
> 		goto fail_unlock;
> 
>  	if (ispipe) {
> 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
>+		if (!helper_argv) {
>+			printk(KERN_WARNING "%s failed to allocate memory\n",
>+			       __func__);
>+			goto fail_unlock;

How about going to the line:

        current->fsuid = fsuid;

? Because when argv_split() fails, helper_argv is NULL and doesn't need
to be checked again.

Otherwise,

Reviewed-by: WANG Cong <wangcong@zeuux.org>

Thanks.

-- 
"Against stupidity, the gods themselves, contend in vain."

