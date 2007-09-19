Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbXISAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbXISAYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 20:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXISAYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 20:24:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38058 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXISAYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 20:24:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=qwajRgp6h1TPD+nY64l7aavn8NzeWhpa1ODKcm8/Fb9IQVulivHcjYQarNDAMm2Z7
	QnRm8yobHFAp1m8hJh+Jg==
Message-ID: <46F06C17.5050203@google.com>
Date: Tue, 18 Sep 2007 17:23:51 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, pj@sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] cpuset dirty limits
References: <469D3342.3080405@google.com> <46E741B1.4030100@google.com> <46E743F8.9050206@google.com> <20070914161540.5b192348.akpm@linux-foundation.org> <Pine.LNX.4.64.0709171153010.27542@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709171153010.27542@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 14 Sep 2007, Andrew Morton wrote:
> 
>>> +	mutex_lock(&callback_mutex);
>>> +	*cs_int = val;
>>> +	mutex_unlock(&callback_mutex);
>> I don't think this locking does anything?
> 
> Locking is wrong here. The lock needs to be taken before the cs pointer 
> is dereferenced from the caller.

	I think we can just remove the callback_mutex lock. Since the change is
coming from an update to a cpuset filesystem file, the cpuset is not
going anywhere since the inode is open. And I don't see that any code
really cares whether the dirty ratios change out from under them.

> 
>>> +	return 0;
>>> +}
>>> +
>>>  /*
>>>   * Frequency meter - How fast is some event occurring?
>>>   *
>>> ...
>>> +void cpuset_get_current_ratios(int *background_ratio, int *throttle_ratio)
>>> +{
>>> +	int background = -1;
>>> +	int throttle = -1;
>>> +	struct task_struct *tsk = current;
>>> +
>>> +	task_lock(tsk);
>>> +	background = task_cs(tsk)->background_dirty_ratio;
>>> +	throttle = task_cs(tsk)->throttle_dirty_ratio;
>>> +	task_unlock(tsk);
>> ditto?
> 
> It is required to take the task lock while dereferencing the tasks cpuset 
> pointer.

	Agreed.
	-- Ethan
