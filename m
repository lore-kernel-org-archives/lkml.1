Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYANQIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYANQIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYANQIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:08:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:20019 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYANQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kwHEBig38wdgsNJc57E2yP8ZNyTxayGOE/cdG2sVGLvYGmwWW5zNNE5y48N4SGC/zLd1t0f77je79pctd1/LroVfDOwc173dX0UsRgK19tuqrQ82CpcXaGkGUayuhU7djQGtYuSE5mhNsAPW4S2K5fY3vY+1PM5V6SzaKZs7t4Q=
Date: Mon, 14 Jan 2008 19:07:45 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Message-ID: <20080114160745.GB6639@cvg>
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com> <478A82AD.3070904@gmail.com> <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com> <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com> <478B7C4A.5090903@gmail.com> <20080114153806.GA6639@cvg> <478B86DA.1010902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B86DA.1010902@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Mon, Jan 14, 2008 at 04:59:22PM +0100]
> On 01/14/2008 04:38 PM, Cyrill Gorcunov wrote:
>> Jiri, I mean rtc_open() is protected by spinlock+status from being
>> opened simultaneously by a few processes. *But* lets imagine the
>> following situation - this fd (file descriptor) is opened by one
>> multithreaded application so all threads have an access to this
>> fd. Then one thread reads rtc periodically thru unlocked_ioctl
>> and another thread set new time from time to time. So the question
>> I have - is it possible to get second thread stopped at attemption to
>> get rtc spinlock while another thread is setting the new time? Or
>> this situation never-ever could be? i'm not really familiar with
>> process management in Linux and as result could be wrong.
>
> Access to global variable 'rtc' (the rtc itself) is serialized through the 
> spinlock, I see no problem there. If you call read-read-write-read from 4 
> tasks in userspace, it might be _still_ (no change) reordered to e.g. 
> write-read-read-read by the scheduler.
>
> In fact, the reading process is stopped while the another one is writing 
> the time (due to spinlock).
>

Yes, process would be stopped, and not *just* stopped but could spend
all his cpu time-slice in attempt to get spinlock (espec if set time is
much longer than read), but if we use mutex here the process could just
sleep instead of trying to get spinlock granted. Am I wrong? Or this is
not worth to do it?

		- Cyrill -
