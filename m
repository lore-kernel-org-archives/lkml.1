Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbZDHJdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbZDHJdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZDHJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:33:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbZDHJdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:33:12 -0400
Message-ID: <49DC6F01.6030203@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 17:31:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tracing: fix splice return too large
References: <49D46674.9030804@cn.fujitsu.com> <20090403131629.GA8875@elte.hu>
In-Reply-To: <20090403131629.GA8875@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> -	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
>> +	if (*ppos & (PAGE_SIZE - 1)) {
>> +		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (len & (PAGE_SIZE - 1)) {
>> +		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
>> +		if (len < PAGE_SIZE)
>> +			return -EINVAL;
>> +		len &= PAGE_MASK;
>> +	}
> 
> Hm, the fix looks good, but is it a good idea to allow the 
> triggering of this message from user-space?
> 

But it is only triggered once.

If user get content from trace_pipe_raw with non-page-align,
the content is garbage. It's wasting, the kernel disallows it.
This message tell user why he read failed.

These 4 patches make trace_pipe_raw more robustious and consistent
(read by read(2) and splice). I focus on handling raw ftrace data
in userspace, these raw ftrace data should be trustiness.

Thanks.
Lai.

