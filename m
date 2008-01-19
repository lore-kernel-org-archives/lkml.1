Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYASLRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYASLRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 06:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYASLRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 06:17:16 -0500
Received: from as3.cineca.com ([130.186.84.211]:47432 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbYASLRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 06:17:14 -0500
Message-ID: <4791DC2C.9090405@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Naveen Gupta <ngupta@google.com>
Cc: Paul Menage <menage@google.com>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com>
In-Reply-To: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Jan 2008 12:17:01 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen Gupta wrote:
>> Paul Menage wrote:
>>> On Jan 18,  2008 7:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com>  wrote:
>>>> On Fri, Jan 18, 2008 at 12:41:03PM +0100, Andrea Righi  wrote:
>>>>> Allow to limit the  block I/O bandwidth for  specific process containers
>>>>> (cgroups) imposing additional delays  on I/O requests for those processes
>>>>> that exceed the  limits defined in the control group filesystem.
>>>>>
>>>>>  Example:
>>>>>   # mkdir /dev/cgroup
>>>>>   # mount -t cgroup -oio-throttle io-throttle /dev/cgroup
>>>> Just a minor nit, can't we name it as io,  keeping in mind that other
>>>> controllers are known as cpu and  memory?
>>> Or maybe "blockio"?
>> Agree, blockio seems better. Not all I/O is performed on  block devices
>> and in this case we're  considering block devices only.
> 
> Here we want to rate limit in block layer, I would think I/O scheduler
> is the place where we are in much better position to do this kind of
> limiting.
> 
> Also we are changing the behavior of application by adding sleeps to
> it during request submission. Moreover, we will prevent requests from
> being merged since we won't allow them to be submitted in this case.
> 
> Since bulk of submission for writes is done in background kernel
> threads and we throttle based on limits on current, we will end up
> throttling these threads and not the actual processes submitting i/o.

Yep, that's true! This works for read operations only... at the very
least, if I've understood well, we could throttle I/O reads in the
submit_bio() path and write operations in __set_page_dirty(). But this
would change the applications behavior, so probably the best approcah
could be to just get I/O statistics from TASK_IO_ACCOUNTING stuff and
implement task delays at the I/O scheduler layer...

Thanks,
-Andrea
