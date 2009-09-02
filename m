Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbZIBHhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbZIBHhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZIBHhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:37:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62416 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZIBHhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:37:35 -0400
Message-ID: <4A9E20BF.6000609@cn.fujitsu.com>
Date: Wed, 02 Sep 2009 15:37:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: make splice_read work when data is	sufficient
References: <4A95F743.2090101@cn.fujitsu.com> <20090829094503.GA6418@nowhere> <4A9D13C1.4030902@cn.fujitsu.com> <20090901223659.GB6108@nowhere>
In-Reply-To: <20090901223659.GB6108@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Sep 01, 2009 at 08:29:53PM +0800, Lai Jiangshan wrote:
>> Frederic Weisbecker wrote:
>>>>  	 */
>>>> +	cpu_buffer->reader_page->read = 0;
>>>
>>>
>>> Wasn't this reset done before?
>>>
>>>
>> This is not reset. It is still used just before this line.
> 
> 
> 
> Yeah but after that it's not used anymore because this page

It may be used in next rb_get_reader_page(), see next:

> won't anymore be used as a reader page but will be integrated
> as a writable ring buffer page.
> 
> One day it may be reused as a reader page still, but before
> any use, rb_reset_reader_page() will be called to reset this offset.
> 
> So I just don't understand why you need to do that.
> 
> 

Oh, I know what you mean.

My patch changes the rb_get_reader_page().

rb_get_reader_page(cpu_buffer, 0) is still the same behavior exactly as before.

But rb_get_reader_page(cpu_buffer, 1) returns NULL when
reader page is empty and head page is not full,
in this condition, we do local_set(&cpu_buffer->reader_page->page->commit, 0),
so we need reset cpu_buffer->reader_page->read. Because cpu_buffer->reader_page
will be accessed again in next rb_get_reader_page().

Lai

