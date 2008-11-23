Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYKWJPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYKWJPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYKWJOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:14:54 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:65014 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYKWJOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EV7Nvn5HRnJ6mCX7EbTXsYo13ThmKQJTom71d0a6kufBWbEW/1LwayW6b+SzQTZl2m
         7GWhRfqVydMfPjVPR5LpFG2upL8FMYjLg5ErEudNUn83qWztzhe+3106Z1xvzVRviPyR
         AcxfpnPYfh3fN22JmF9Lz5lnPyWcszrK9rdJ0=
Message-ID: <49291F06.5040907@gmail.com>
Date: Sun, 23 Nov 2008 18:14:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       hch@infradead.org, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: poll: allow f_op->poll to sleep, take #3
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com> <20081123085902.GI30453@elte.hu>
In-Reply-To: <20081123085902.GI30453@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
>> On Sun, 23 Nov 2008, Tejun Heo wrote:
>>
>>> +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>> +{
>>> +	struct poll_wqueues *pwq = wait->private;
>>> +	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
>>> +
>>> +	set_mb(pwq->triggered, 1);
>>> +
>>> +	/* perform the default wake up operation */
>>> +	return default_wake_function(&dummy_wait, mode, sync, key);
>>> +}
>> Wouldn't it be nicer to un-static try_to_wake_up() (or a wrapper) 
>> instead of setting up a fake wait queue just to use 
>> default_wake_function(), just to wake up a task?
> 
> the already existing single-task-wakeup shortcut method made available 
> by the scheduler is wake_up_process(). A number of primitives where 
> waitqueue overhead is of concern already make use of it. 
> (mutexes/rtmutexes and more)
> 
> if you need a different mode flag, then please extend the 
> wake_up_process() family of APIs.

Well, the problem is that for wait wake up functions @mode and @sync are
passed as parameter and should be passed over to actual wake up function
as-is, if I add @mode and @sync to wake_up_process() family of APIs,
it's just try_to_wake_up().

Thanks.

-- 
tejun
