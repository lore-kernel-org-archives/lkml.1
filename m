Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbXFUSG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbXFUSG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760593AbXFUSGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:06:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47685 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760585AbXFUSGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:06:45 -0400
Message-ID: <467ABDF1.5000505@us.ibm.com>
Date: Thu, 21 Jun 2007 11:05:37 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Tom Zanussi <zanussi@us.ibm.com>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>
Subject: Re: [PATCH] relay-file-read-start-pos-fix.patch
References: <4676109F.8020202@us.ibm.com>  <467750E9.4090808@hitachi.com> <1182231301.30702.82.camel@ubuntu> <4678E5FF.7030301@hitachi.com>
In-Reply-To: <4678E5FF.7030301@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ack
Works for me.  Thanks.

Note:
Both Masami's patch and the relay-file-read-start-pos-fix.patch I posted 
earlier are required.

Masami Hiramatsu wrote:

>Hi Tom,
>
>Tom Zanussi wrote:
>  
>
>>Could you send more info on how to reproduce the problem you're seeing?
>>And does this patch fix it?
>>    
>>
>
>Sure, I'll explain how to reproduce it.
>
>Since current SystemTap is not supporting "overwrite" mode,
>you need to apply a patch before trying to reproduce it.
>I already posted the patch to bugzilla. You can get it from below.
>http://sourceware.org/bugzilla/attachment.cgi?id=1896&action=view
>
>Here is an example script (fillup.stp).
>----
>global counter=0
>probe timer.ms(1) {
>        counter++;
>        printf("%08d : %020d\n", counter, gettimeofday_ns());
>}
>----
>
>First of all, run the script with -O (overwrite mode) flag.
>(For simplify my explanation, I also use -m flag here.)
>$ stap -O fillup.stp -m fillup
>Soon after starting, press ^\(Ctrl+\) to detach from it.
>
>The script writes 32 bytes dummy data per 1 milli-second, so
>it writes about 32k bytes per 1 second.
>And the default size of relay channel of systemtap is 512kB
>which contains 4 subbufs (each size of subbufs is 128kB).
>Thus, it fills the relay channel at about 16 seconds and
>wraparounds because it uses overwrite mode.
>
>So, wait more than 16 seconds (for example, 18 sec),
>read the relay channel and count the line number.
>And repeat it.
>$ while true; do sleep 18; \
> cat /sys/kernel/debug/systemtap/fillup/trace0 | wc -l; done
>
>Ideally, it will show the number from 12288(=3*128k/32) to
>16384(=4*128k/32).
>
>However, without my patch, it shows;
>4793
>5721
>9818
>9817
>9819
>13912
>0
>0
>780
>1625
>5723
>5721
>
>And, with my patch;
>15742
>13273
>14901
>12430
>14056
>15682
>13215
>14840
>12370
>13996
>15624
>13154
>
>
>So, I think my patch (which )fixes the problem.
>
>Thanks,
>
>P.S.
>I attached my patch (relay-file-read-overwrite-mode-fix.patch)
>which fixed the problem pointed in previous mail.
>
>Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>
>---
> kernel/relay.c |    8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>
>Index: linux-2.6.22-rc4-mm2/kernel/relay.c
>===================================================================
>--- linux-2.6.22-rc4-mm2.orig/kernel/relay.c	2007-06-13 20:22:02.000000000 +0900
>+++ linux-2.6.22-rc4-mm2/kernel/relay.c	2007-06-20 10:53:06.000000000 +0900
>@@ -812,7 +812,10 @@
> 	}
>
> 	buf->bytes_consumed += bytes_consumed;
>-	read_subbuf = read_pos / buf->chan->subbuf_size;
>+	if (!read_pos)
>+		read_subbuf = buf->subbufs_consumed % n_subbufs;
>+	else
>+		read_subbuf = read_pos / buf->chan->subbuf_size;
> 	if (buf->bytes_consumed + buf->padding[read_subbuf] == subbuf_size) {
> 		if ((read_subbuf == buf->subbufs_produced % n_subbufs) &&
> 		    (buf->offset == subbuf_size))
>@@ -841,8 +844,9 @@
> 	}
>
> 	if (unlikely(produced - consumed >= n_subbufs)) {
>-		consumed = (produced / n_subbufs) * n_subbufs;
>+		consumed = produced - n_subbufs + 1;
> 		buf->subbufs_consumed = consumed;
>+		buf->bytes_consumed = 0;
> 	}
> 	
> 	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
>
>
>
>
>
>  
>


-- 
David Wilder
IBM Linux Technology Center
Beaverton, Oregon, USA 
dwilder@us.ibm.com
(503)578-3789

