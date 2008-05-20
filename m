Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbYETJrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbYETJrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYETJqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:46:54 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:55903 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYETJqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W4CCMj/95q7cpqJjo6z5GC5mS6PRCKfVgVXP3V812/SHMiLCjlaJzg+u2Kl83ACQbX/EChw/yigIMVVTw5GtLaliS1yFLi98AmIsmvbbO5HGM3Va3tIky/rQKgPgxLVNv2L1U7ssnSFyQ67evExvm7Y8D61zEpkVSNeR4afynzY=
Message-ID: <aa79d98a0805200246w6f925f4ai83bd5bae43e37a95@mail.gmail.com>
Date: Tue, 20 May 2008 13:46:50 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] eCryptFS: fix missed mutex_unlock
Cc: "Michael A. Halcrow" <mhalcrow@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520002832.89e74522.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518142611.GA18000@cvg>
	 <20080520002832.89e74522.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:28 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 18 May 2008 18:26:11 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> ---
>>
>> Ingo, could you please apply it and test? Actually I really doubt if it help
>> with the locking problem you pointed. There are two procedures
>> in miscrev.c - ecryptfs_miscdev_poll() and ecryptfs_miscdev_read()
>> which takes/releases mutexes in a bit strange way... investigating,
>> but this patch is needed anyway.
>>
>> Index: linux-2.6.git/fs/ecryptfs/crypto.c
>> ===================================================================
>> --- linux-2.6.git.orig/fs/ecryptfs/crypto.c   2008-05-18 16:44:20.000000000 +0400
>> +++ linux-2.6.git/fs/ecryptfs/crypto.c        2008-05-18 17:56:12.000000000 +0400
>> @@ -1903,6 +1903,7 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
>>               if (rc) {
>>                       printk(KERN_ERR "Error adding new key_tfm to list; "
>>                                       "rc = [%d]\n", rc);
>> +                     mutex_unlock(&key_tfm_list_mutex);
>>                       goto out;
>>               }
>>       }
>
> Better to do it this way, I think:
>
> --- a/fs/ecryptfs/crypto.c~ecryptfs-fix-missed-mutex_unlock
> +++ a/fs/ecryptfs/crypto.c
> @@ -1906,9 +1906,9 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
>                        goto out;
>                }
>        }
> -       mutex_unlock(&key_tfm_list_mutex);
>        (*tfm) = key_tfm->key_tfm;
>        (*tfm_mutex) = &key_tfm->key_tfm_mutex;
>  out:
> +       mutex_unlock(&key_tfm_list_mutex);
>        return rc;
>  }
> _
>
> Holding the lock for an additional few instructions may not be strictly
> needed, but we might avoid the reintroduction of such bugs?
>
>

Good idea, thanks! Could you update the patch, please?
