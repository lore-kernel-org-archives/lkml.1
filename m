Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZGFGXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZGFGXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZGFGXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:23:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZGFGXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:23:24 -0400
Message-ID: <4A5198A0.6030904@redhat.com>
Date: Mon, 06 Jul 2009 14:24:32 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
       Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <jbacik@redhat.com>,
       Chris Mason <chris.mason@oracle.com>, akpm@linux-foundation.org,
       linux-btrfs@vger.kernel.org, Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [Patch] btrfs: use file_remove_suid() after i_mutex is held
References: <20090706053128.6318.16410.sendpatchset@localhost.localdomain> <20090705224823.5679075f@infradead.org>
In-Reply-To: <20090705224823.5679075f@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 6 Jul 2009 01:29:14 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> file_remove_suid() should be called with i_mutex held,
>> file_update_time() too. So move them after mutex_lock().
>>
>> Plus, check the return value of kmalloc().
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>>
>> ---
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 7c3cd24..cd36301 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -944,14 +944,17 @@ static ssize_t btrfs_file_write(struct file
>> *file, const char __user *buf, if (count == 0)
>>  		goto out_nolock;
>>  
>> +	mutex_lock(&inode->i_mutex);
>> +
>>  	err = file_remove_suid(file);
>>  	if (err)
>> -		goto out_nolock;
>> +		goto out;
>>  	file_update_time(file);
>>  
>>  	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
>> +	if (!pages)
>> +		goto out;
>>  
>>     
> Hi,
>
> I don't think you can keep this at GFP_KERNEL once you hold i_mutex....
> very likely this needs to now turn into GFP_NOFS!
>   

Good point!
Hmm,  GFP_KERNEL adds __GFP_FS while GFP_NOFS not...
Just moving that kmalloc() up, before mutex_lock(), I think, can solve
this.

I will update this patch now...

Thanks!

