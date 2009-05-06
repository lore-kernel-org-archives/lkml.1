Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZEFINr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZEFINr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZEFIM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:12:29 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:51920 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZEFIM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=rk2J+nci448bNsqYSQIUrlKGmARdiE5XR1LlcNEqGJzIj/SEA5WaCawe+m/9UNRVuV
         /JlfNi9kNVykFgpk/6DQbp6ZjEIRdiR2axmSGgYT8mdZLHZSqWo8tLMQUnAD2KKpZd49
         Dpb16nics/nx3pbr/208Q0jri1ChJIabi3z2w=
Date: Wed, 6 May 2009 10:12:21 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk %0*X is broken.
Message-ID: <20090506081221.GA15317@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506071839.GA14412@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/6 Ingo Molnar <mingo@elte.hu>:
>
> Cc:-ed more folks who modified lib/vsprintf.c recently.
>
>        Ingo
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> it seems someone broke
>>
>> printk(   "%0*X\n", width, x);
>>
>> looks like 0 is dumped.

After %, we look for flags. The problem is that when a flag is found, we
don't advance in the format string. And thus we start looking for the
precision, which is read as 0, because we are still at the 0. I think
this patch should fix it.

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7536ace..ae7d4b2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -800,14 +800,15 @@ static int format_decode(const char *fmt, struct printf_spec *spec)
 	if (fmt != start || !*fmt)
 		return fmt - start;
 
+	/* this skips the first '%' */
+	++fmt;
+
 	/* Process flags */
 	spec->flags = 0;
 
-	while (1) { /* this also skips first '%' */
+	while (1) {
 		bool found = true;
 
-		++fmt;
-
 		switch (*fmt) {
 		case '-': spec->flags |= LEFT;    break;
 		case '+': spec->flags |= PLUS;    break;
@@ -819,6 +820,8 @@ static int format_decode(const char *fmt, struct printf_spec *spec)
 
 		if (!found)
 			break;
+
+		++fmt;
 	}
 
 	/* get field width */
