Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbYENSW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbYENSW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYENSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:22:10 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52568 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762072AbYENSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:22:05 -0400
Message-ID: <482B2DC9.3050503@linux.vnet.ibm.com>
Date: Wed, 14 May 2008 23:52:01 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 2/3] [PATCH] reiserfs: convert j_flush_sem to mutex
References: <20080508063557.757413878@suse.com> <20080508063651.715221085@suse.com> <482AFA28.8020403@suse.com>
In-Reply-To: <482AFA28.8020403@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney wrote:
> Jeff Mahoney wrote:
>>  j_flush_sem is a semaphore but uses it as if it were a mutex. This
>>  patch converts it to a mutex.
>> --- a/fs/reiserfs/journal.c
>> +++ b/fs/reiserfs/journal.c
>> @@ -1411,8 +1411,8 @@ static int flush_journal_list(struct sup
>>  
>>  	/* if flushall == 0, the lock is already held */
>>  	if (flushall) {
>> -		down(&journal->j_flush_sem);
>> -	} else if (!down_trylock(&journal->j_flush_sem)) {
>> +		mutex_lock(&journal->j_flush_mutex);
>> +	} else if (!mutex_trylock(&journal->j_flush_mutex)) {
>>  		BUG();
>>  	}
> 
> Oops. This chunk didn't get refreshed, here's the right one.
> 
> -Jeff

Thanks, the patch resolves the kernel bug.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/reiserfs/journal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@ -1410,7 +1410,7 @@ static int flush_journal_list(struct sup
>  	/* if flushall == 0, the lock is already held */
>  	if (flushall) {
>  		mutex_lock(&journal->j_flush_mutex);
> -	} else if (!mutex_trylock(&journal->j_flush_mutex)) {
> +	} else if (mutex_trylock(&journal->j_flush_mutex)) {
>  		BUG();
>  	}
> 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
