Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYKYAx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYKYAx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYKYAxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:53:19 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:59638 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYKYAxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:53:18 -0500
Message-ID: <492B4C43.8020506@oracle.com>
Date: Mon, 24 Nov 2008 16:52:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, peterz@infradead.org,
       david@fromorbit.com, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: add dirty_background_bytes and dirty_bytes sysctls
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>	<alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com> <20081124153843.d3c4782c.akpm@linux-foundation.org>
In-Reply-To: <20081124153843.d3c4782c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.492B4C47.0018:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 23 Nov 2008 10:55:16 -0800 (PST)
> David Rientjes <rientjes@google.com> wrote:
> 
>> This change introduces two new sysctls to /proc/sys/vm:
>> dirty_background_bytes and dirty_bytes.
>>
>>
>> ...
>>
>> @@ -365,23 +429,29 @@ void
>>  get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
>>  		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
>>  {
>> -	int background_ratio;		/* Percentages */
>> -	int dirty_ratio;
>>  	unsigned long background;
>>  	unsigned long dirty;
>>  	unsigned long available_memory = determine_dirtyable_memory();
>>  	struct task_struct *tsk;
>>  
>> -	dirty_ratio = vm_dirty_ratio;
>> -	if (dirty_ratio < 5)
>> -		dirty_ratio = 5;
>> +	if (vm_dirty_bytes)
>> +		dirty = (vm_dirty_bytes + PAGE_SIZE) / PAGE_SIZE;
> 
> It would be conventional to use DIV_ROUND_UP() here.
> 
>> +	else {
>> +		int dirty_ratio;
> 
> hm, I wonder why vm_dirty_ratio has a signed type.  
> 
>> -	background_ratio = dirty_background_ratio;
>> -	if (background_ratio >= dirty_ratio)
>> -		background_ratio = dirty_ratio / 2;
>> +		dirty_ratio = vm_dirty_ratio;
>> +		if (dirty_ratio < 5)
>> +			dirty_ratio = 5;
>> +		dirty = (dirty_ratio * available_memory) / 100;
>> +	}
>> +
>> +	if (dirty_background_bytes)
>> +		background = (dirty_background_bytes + PAGE_SIZE) / PAGE_SIZE;
> 
> DIV_ROUND_UP()?

Note that DIV_ROUND_UP() would make that

		background = (dirty_background_byte + PAGE_SIZE - 1) / PAGE_SIZE;

but that's usually what is needed/intended.

>> +	else
>> +		background = (dirty_background_ratio * available_memory) / 100;
>>  
>> -	background = (background_ratio * available_memory) / 100;
>> -	dirty = (dirty_ratio * available_memory) / 100;
>> +	if (background >= dirty)
>> +		background = dirty / 2;
>>  	tsk = current;
>>  	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
>>  		background += background / 4;

-- 
~Randy
