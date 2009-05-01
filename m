Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbZEACN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbZEACN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbZEACNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:13:18 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:41815 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZEACNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PVB4ZIoABWUWI/Ffifz+dTJ8HCqoYOu8w52x2XdTuckx3E0vbN/GZmY22fYT5AE0iD
         AVrvrD39/LHExHTMjpwyf12C0sx4egHEcJJ51wK5eb551IvRRsaNasri4jdXS8EIN87B
         CgWYkZ4ZY4Z2Iz76dvOKooZmMnQ6EXTkhJju4=
MIME-Version: 1.0
In-Reply-To: <49F9D82D.50901@hp.com>
References: <20090430133627.D217.A69D9226@jp.fujitsu.com>
	 <49F9D82D.50901@hp.com>
Date: Fri, 1 May 2009 11:13:17 +0900
X-Google-Sender-Auth: bbebc0497763e4fc
Message-ID: <2f11576a0904301913h5aa0ed79gc8c5d98e71445858@mail.gmail.com>
Subject: Re: [PATCH] blktrace: swap arg name "from" and "to" of 
	blk_add_trace_remap
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe this may be more messed up than you believe: Consider the last
> function: blk_log_remap. Notice how you are printing the /device/ and
> /sector_from/ as one pair. Isn't that confusing too: wouldn't one expect
> /device_from/ and /sector_from/ to be paired up?
>
> I ran into this problem a long time ago - hence the current code in
> blkparse contains:
>
>        if (act[0] == 'A') {    /* Remap */
>                get_pdu_remap(t, &r);
>                t->device = r.device_from;
>        }
>
> Which puts the device_from out at the beginning of the line, and then
> the 'device' + 'sector' (== 'sector_from') out at the end of the line.
> (Which, of course, is all confusing.)

Good viewpoint!
Currently, 99% blktrace user use blktrace and blkparse command, not
ftrace framework.
So, ABI changing is proper way?

I'd like to hear Jens and Li opinion.



> To really fix this, I think one needs to:
>
> (a) adjust the kernel to make "r.device_from" and "r.sector_from" refer
> to the same part of the trace, and the "r.device" and "t->sector" refer
> to the other part of the trace.
>
> (b) fix blkparse (& btt & ...) to do the same thing - not make
> adjustments for the stupid naming...
>
> If we leave the kernel->user space ABI alone:
>
> first u32: device mapped /from/
> second u32: device mapped /to/
> u64: sector mapped from
>
> We can then change the names. I've followed this e-mail up with a pair
> of kernel-side patches and will submit user side fixes for blkptrace later.
