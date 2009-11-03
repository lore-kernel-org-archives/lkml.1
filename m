Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZKCXnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZKCXnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZKCXnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:43:08 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35702 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZKCXnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:43:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BFuy4li+BVie2aRxJkkCjYwi+GvyrEoHg0GQxSg1k3/i5N7LRmqGt6tB9MjtOedoRc
         DOw8fwxGMw8q96ijr8LnLpiWDbbFq6IucoO/qecPhXIFJC8cIDAuD17ZEUGq4kOQRxpy
         YtwuHmMWKXFOd1DbQ8uWlEH8gjb595Ac5OivY=
MIME-Version: 1.0
In-Reply-To: <20091029222335.GJ18464@mit.edu>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.haF.Are5KB@chimera>
	 <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com>
	 <20091029222335.GJ18464@mit.edu>
Date: Tue, 3 Nov 2009 18:43:11 -0500
X-Google-Sender-Auth: 9b726ddeee057afe
Message-ID: <cb0375e10911031543n5cfcc090k8780449a1413b067@mail.gmail.com>
Subject: Re: [Bug #14472] EXT4 corruption
From: Andrew Lutomirski <luto@mit.edu>
To: Theodore Tso <tytso@mit.edu>, Andrew Lutomirski <luto@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Shawn Starr <shawn.starr@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 5:23 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Oct 29, 2009 at 03:57:32PM -0400, Andrew Lutomirski wrote:
>>
>> This but is *not* fixed.  I just triggered it a few minutes ago by
>> abusing i915 and drm, which caused a panic.  This is slightly newer
>> than 2.6.32-rc5, with a couple of i915 bugfixes thrown in.
>
> Andrew, can you test to see if this patch helps?
>
> Thanks,
>
>                                                - Ted
>
> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Tue Oct 27 15:36:38 2009 +0530
>
>    ext4: discard preallocation during truncate
>
>    We need to make sure when we drop and reacquire the inode's
>    i_data_sem we discard the inode preallocation. Otherwise we
>    could have blocks marked as free in bitmap but still belonging
>    to prealloc space.
>
>    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c5bc5d..a1ef1c3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -209,6 +209,12 @@ static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
>        up_write(&EXT4_I(inode)->i_data_sem);
>        ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
>        down_write(&EXT4_I(inode)->i_data_sem);
> +       /*
> +        * We have dropped i_data_sem. So somebody else could have done
> +        * block allocation. So discard the prealloc space created as a
> +        * part of block allocation
> +        */
> +       ext4_discard_preallocations(inode);
>
>        return ret;
>  }
>


It looks like 2.6.32-rc6 is supposed to fix this bug, but it also
looks like this patch didn't make it in.  Should I still be using this
patch?

Thanks,
Andy
