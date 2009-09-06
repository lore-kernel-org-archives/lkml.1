Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZIFKL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZIFKL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 06:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZIFKLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 06:11:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:1832 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbZIFKLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 06:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pg8Ra4CZayqacOTccSBcPbIpdsuxvGVwztGp/wzPuYO6BCJfyf9o6MP+30kUYZvIq/
         NZHI26q1ToJKmr4Q/CsfxaUvQ+ljMgrWmqc/YPyxuh0jdEFXcArOg7rIBTOkXwP7H4il
         oANAQ1gFkizGdzAShye3aKaQMBolHuqORzxxY=
Message-ID: <4AA38AC6.2010202@gmail.com>
Date: Sun, 06 Sep 2009 12:11:18 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: CONFIG_NO_HZ could cause software timeouts
References: <4A9F9F64.5080305@aimvalley.nl> <4AA2ABC2.1060803@gmail.com> <20090906055841.GC1431@ucw.cz>
In-Reply-To: <20090906055841.GC1431@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2009-09-05 20:19:46, Marcin Slusarz wrote:
>> Norbert van Bolhuis wrote:
>>> The problem occurs when e.g. drivers use time_after(jiffes, timeout).
>>>
>>> CONFIG_NO_HZ could make jiffies advance by more than 1.
>>> This is done by:
>>> tick_nohz_update_jiffies->tick_do_update_jiffies64->do_timer
>>>
>>> If drivers use a timeout value of jiffies+1,
>>> "time_after(jiffies, timeout)" will be true after 1 interrupt
>>> (given that it advances jiffies by at least 2).
>>>
>>> This is exactly what happens in cfi_cmdset_0002.c:do_write_buffer
>>> for our case (Powerpc MPC8313, linux-2.6.28, CONFIG_HZ=250,
>>> CONFIG_NO_HZ=y).
>>>
>>> do_write_buffer does the following:
>>>  unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
>>>  ...
>>>  timeo = jiffies + uWriteTimeout;
>>>  ...
>>>  for (;;) {
>>>   ...
>>>   if (time_after(jiffies, timeo) && !chip_ready(map, adr))
>>>    break;
>>>   if (chip_ready(map, adr)) {
>>>    xip_enable(map, chip, adr);
>>>    goto op_done;
>>>   }
>>>   UDELAY(map, chip, adr, 1);
>>>  }
>>>  /* software timeout */
>>>  ret = -EIO;
>>> opdone:
>>>  ...
>>>
>>> I've seen a few software timeouts after the for-loop
>>> looped only 13 times (= 13 us delay, i.s.o. the expected 1 ms). Typically
>> Are you sure? UDELAY may call schedule(), which can return to this thread
>> after much longer time than 13us...
> 
> Too long wait is expected, but AFAICS he's complaining about too short
> delay and that's a hard bug.

Yeah, I know. But conclusion is a bit fishy - 13 iterations don't necessarily mean 13us.
Bug might be elsewhere.

Marcin

