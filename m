Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZGOBJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZGOBJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZGOBJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:09:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54510 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756802AbZGOBJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:09:50 -0400
Message-ID: <4A5D2BF6.6010802@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 09:08:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: event tracing, ringbuffer and RB_MAX_SMALL_DATA
References: <1247591891.7178.20.camel@johannes.local>
In-Reply-To: <1247591891.7178.20.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> Hi,
> 
> By code inspection, I think there's a bug if your event contains only
> 
> 	__dynamic_array(u8, buf, buflen)
> 
> and your buflen is only, say, 3. Then the event size will be the common
> event size (12 bytes) plus this, so 15, which is well below
> RB_MAX_SMALL_DATA (4*28 = 112), so it'll be divided by four to be stored
> into type_len. At this point, however, you've lost the information that
> your dynamic array was only three bytes, and it'll be considered _four_
> bytes long by parsers as far as I can tell?
> 

Right, the length of a dynamic array is not recorded, and this
causes 2 problems:

- the event filter is not working properly for dynamic strings
- userspace parsers can't figure out the length of those arrays

I had an idea some time ago, and hopefully will send out a
patch today or tomorrow. 

