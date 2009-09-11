Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbZIKWPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbZIKWPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZIKWPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:15:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZIKWPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:15:03 -0400
Subject: Re: [PATCH] Prevent NULL pointer dereference in
 ftrace_raw_event_block_bio_bounce
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AAAC9B1.9060505@osadl.org>
References: <4AAAC9B1.9060505@osadl.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 18:15:04 -0400
Message-Id: <1252707304.18996.739.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 00:05 +0200, Carsten Emde wrote:
> Booting 2.6.31 and executing
>    echo 1 >/sys/kernel/debug/tracing/events/enable
> leads to
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c032a583>] ftrace_raw_event_block_bio_bounce+0x4b/0xb9
> 
> Apparently,
>    bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
> is called in block/blk-map.c:58 where bio->bi_bdev in set to NULL and 
> still is NULL when an attempt is made to evaluate bio->bi_bdev->bd_dev 
> in include/trace/events/block.h:189.
> 
> The tracepoint should ensure bio->bi_bdev is not dereferenced, if NULL.
> 
> Signed-Off-By: Carsten Emde <C.Emde@osadl.org>

Thanks Carsten!

I'll apply it and push it off to Ingo.

-- Steve

> 
> --- a/include/trace/events/block.h 2009-09-11 21:20:56.000000000 +0200
> +++ b/include/trace/events/block.h 2009-09-11 22:01:52.000000000 +0200
> @@ -186,7 +186,8 @@
>   	),
> 
>   	TP_fast_assign(
> -		__entry->dev		= bio->bi_bdev->bd_dev;
> +		__entry->dev		= bio->bi_bdev ?
> +					  bio->bi_bdev->bd_dev : 0;
>   		__entry->sector		= bio->bi_sector;
>   		__entry->nr_sector	= bio->bi_size >> 9;
>   		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
> 

