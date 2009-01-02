Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZABTUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZABTUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbZABTUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:20:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:40416 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZABTUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:20:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gx8D8D6d7zo18UTalzLACqKbdBeRJbp2xxB7Z+8Kbq4kAdqHPevhC/nVLPwtgz1R/D
         KB1OswC11jRddoIPAezdDJKJJj7K0IPS3iB4JsB+qhKJuvX9vH6vVad8MUj49FgYHrbv
         RSBvCRne2Lq/Hr3hh1xeOXiHYPYbyHsBru9H0=
Message-ID: <495E68F5.5010309@gmail.com>
Date: Fri, 02 Jan 2009 20:20:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: unsigned idx cannot be less than 0
References: <495E2987.3070501@gmail.com> <20090102154805.GA6833@nowhere>
In-Reply-To: <20090102154805.GA6833@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Jan 02, 2009 at 03:49:43PM +0100, Roel Kluin wrote:
>> // vi kernel/trace/ftrace.c +787
>> struct ftrace_iterator {
>> ...
>>         unsigned                idx;
>> ...
>> };
>>
>> idx is unsigned and cannot be less than 0.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 2f32969..a344add 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -842,7 +842,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
>>  	void *p = NULL;
>>  
>>  	if (*pos > 0) {
>> -		if (iter->idx < 0)
>> +		if (iter->idx == 0)
>>  			return p;
>>  		(*pos)--;
>>  		iter->idx--;
> 
> 
> Hi Roel,
> 
> I'm not sure this is the right fix.
> If you look at t_next, if there is no more page to look at,
> iter_idx takes -1.
> 
> A 0 value would mean: we are in the first index on the page, which means
> there is something to read and we don't want to return NULL.
> 
> I guess that would be better to turn idx into a signed int.

If we turn idx in a signed int, isn't it true that
in kernel/trace/ftrace.c, line 806:

retry:
if (iter->idx >= iter->pg->index) {
	...
} else {
	iter->idx++;
	if ( a certain rec-> and iter->flags )
		goto retry;
}

since iter->pg->index is an unsigned long, when larger than INT_MAX this
could result in an endless loop?

Roel
