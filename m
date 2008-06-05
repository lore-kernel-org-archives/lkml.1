Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYFEI3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYFEI3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYFEI2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:28:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:22107 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYFEI2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qT9bVm+eDjGthIQBrXtdZ0WRyjc298DFUZ2ZQD+ufSM6Ow6DkhhR+lI1XOTVDz0HTY
         pAyxwm0Bbl79LuQAkDpY7gZc24AzJA9/Ui/OvBNdE+FAGBpy2ZzFf2m/rV1xOu7Iu1TY
         i+OCh3l42yhvAom38VCPJwsNY5hFaT3vmaKxw=
Message-ID: <6278d2220806050128x6e892df3p1632d6ae6b40b55b@mail.gmail.com>
Date: Thu, 5 Jun 2008 09:28:51 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>, chucklever@gmail.com
Subject: Re: [2.6.26-rc4] mount.nfsv4/memory poisoning issues...
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080604203504.62730951@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
	 <20080604203504.62730951@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 1:35 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 5 Jun 2008 00:33:54 +0100
> "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
>
>> Having experienced 'mount.nfs4: internal error' when mounting nfsv4 in
>> the past, I have a minimal test-case I sometimes run:
>>
>> $ while :; do mount -t nfs4 filer:/store /store; umount /store; done
>>
>> After ~100 iterations, I saw the 'mount.nfs4: internal error',
>> followed by symptoms of memory corruption [1], a locking issue with
>> the reporting [2] and another (related?) memory-corruption issue
>> (off-by-1?) [3]. A little analysis shows memory being overwritten by
>> (likely) a poison value, which gets complicated if it's not
>> use-after-free...
>>
>> Anyone dare confirm this issue? NFSv4 server is x86-64 Ubuntu 8.04
>> 2.6.24-18, client U8.04 2.6.26-rc4; batteries included [4].
>>
>> I'm happy to decode addresses, test patches etc.
>>
>> Daniel
>>
>
> Looks like it fell down while trying to take down the kthread during a
> failed mount attempt. I have to wonder if I might have introduced a
> race when I changed nfs4 callback thread to kthread API. I think we may
> need the BKL around the last 2 statements in the main callback thread
> function. If you can easily reproduce this, could you test the
> following patch and let me know if it helps?
>
> Note that this patch is entirely untested, so test it someplace
> non-critical ;-).
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
>
>
> diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
> index c1e7c83..a3e83f9 100644
> --- a/fs/nfs/callback.c
> +++ b/fs/nfs/callback.c
> @@ -90,9 +90,9 @@ nfs_callback_svc(void *vrqstp)
>                preverr = err;
>                svc_process(rqstp);
>        }
> -       unlock_kernel();
>        nfs_callback_info.task = NULL;
>        svc_exit_thread(rqstp);
> +       unlock_kernel();
>        return 0;
>  }

This doesn't resolve the issue, alas. I'll hunker down to the
bisection in the next few days.

Thanks,
  Daniel
-- 
Daniel J Blueman
