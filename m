Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbZACP4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbZACP4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 10:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbZACPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 10:55:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28142 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902AbZACPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UEwJFAAAJX8gNgEwgZeOY00qkK6bFew4v5G6gCecholeD4rf7V84USiUt8D5gIeuyU
         3Yo+C/ZRFBeeYsEO/c25NVhgmE/xBaNy0wLKumDVQZZkFV08Cdk3X7jaXH44c54Itt1P
         iyidcb5CjvXyguwRBW14wWmqRyk9uyBSorskQ=
Message-ID: <495F8A86.7040403@gmail.com>
Date: Sat, 03 Jan 2009 16:55:50 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] ftrace: unsigned idx cannot be less than 0
References: <495E2987.3070501@gmail.com> <20090102154805.GA6833@nowhere> <495E68F5.5010309@gmail.com> <20090102211140.GA5770@nowhere>
In-Reply-To: <20090102211140.GA5770@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> -		if (iter->idx < 0)
>>>> +		if (iter->idx == 0)

>>> I'm not sure this is the right fix.
>>> If you look at t_next, if there is no more page to look at,
>>> iter_idx takes -1.
>>>
>>> A 0 value would mean: we are in the first index on the page, which means
>>> there is something to read and we don't want to return NULL.
>>>
>>> I guess that would be better to turn idx into a signed int.

>> If we turn idx in a signed int, isn't it true that
>> in kernel/trace/ftrace.c, line 806:

>> since iter->pg->index is an unsigned long, when larger than INT_MAX this
>> could result in an endless loop?
> 
> Actually, this is not supposed to reach such a threshold.
> Looks like it wouldn't increase over ENTRIES_PER_PAGE (defined
> in ftrace.c) which is smaller than PAGE_SIZE.
> So it will stay far from an overflow.

unless signed idx cannot become less than 0

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2f32969..e256648 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -786,7 +786,7 @@ enum {
 
 struct ftrace_iterator {
 	struct ftrace_page	*pg;
-	unsigned		idx;
+	int			idx;
 	unsigned		flags;
 	unsigned char		buffer[FTRACE_BUFF_MAX+1];
 	unsigned		buffer_idx;

