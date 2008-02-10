Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYBJLvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYBJLvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 06:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYBJLvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 06:51:38 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:51443 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYBJLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 06:51:36 -0500
Date: Sun, 10 Feb 2008 12:51:27 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: Christoph Hellwig <hch@infradead.org>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ipvs: Cleanup sync daemon code
In-Reply-To: <20080210045952.GA8255@infradead.org>
Message-ID: <Pine.LNX.4.64.0802101236530.15729@titan.stealer.net>
References: <Pine.LNX.4.64.0802100029150.15729@titan.stealer.net>
 <20080210045952.GA8255@infradead.org>
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 10 Feb 2008 11:51:35 +0000
	Bayes: 0.0194 Tokens: new, 212; hammy, 4; neutral, 7; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0194]
X-Spam-Signature: 47162c7442c0530914c309997abd9651051df98f
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Christoph Hellwig wrote:

> On Sun, Feb 10, 2008 at 12:38:11AM +0100, Sven Wegener wrote:
>>  struct ip_vs_sync_thread_data {
>> -	struct completion *startup;
>> +	struct completion *startup; /* set to NULL once completed */
>
> This is not needed anmore.  kthread_run guarantees that the newly
> creates thread is run before returning to the caller.

The completion is currently used to return an error code for errors that 
happen during initialization in the threads (open socket, allocate 
memory). We could move the setup code out of the threads and have them 
only run an error-safe loop.

>> +/* wait queue for master sync daemon */
>> +static DECLARE_WAIT_QUEUE_HEAD(sync_master_wait);
>
> I don't think you need this one either.  You can use wake_up_process
> on the task_struct pointer instead.

Thanks, now using schedule_timeout with wake_up_process.

>>  	spin_lock(&ip_vs_sync_lock);
>>  	list_add_tail(&sb->list, &ip_vs_sync_queue);
>> +	if (++ip_vs_sync_count == 10)
>> +		wake_up_interruptible(&sync_master_wait);
>>  	spin_unlock(&ip_vs_sync_lock);
>>  }
>
>> -static int sync_thread(void *startup)
>> +static int sync_thread(void *data)
>
> Btw, it might make sense to remove sync_thread and just call the
> master and backup threads directly.

When the setup code has been moved out of the threads, the code gets much 
simpler.

>> +void __init ip_vs_sync_init(void)
>> +{
>> +	/* set up multicast address */
>> +	mcast_addr.sin_family = AF_INET;
>> +	mcast_addr.sin_port = htons(IP_VS_SYNC_PORT);
>> +	mcast_addr.sin_addr.s_addr = htonl(IP_VS_SYNC_GROUP);
>>  }
>
> Why can't this be initialized at compile time by:
>
> static struct sockaddr_in mcast_addr = {
> 	.sin_family		= AF_INET,
> 	.sin_port		= htons(IP_VS_SYNC_PORT),
> 	.sin_addr.s_addr	= htonl(IP_VS_SYNC_GROUP),
> }
>
> (the hton* might need __constant_hton* also I'm not sure without trying)

Thanks.
