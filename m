Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXK0H6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXK0H6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXK0H62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:58:28 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:41035 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXK0H62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:58:28 -0500
Message-ID: <474BCE0E.4090900@cosmosbay.com>
Date: Tue, 27 Nov 2007 08:58:06 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] get rid of NR_OPEN and introduce a sysctl_nr_open
References: <200711200023.lAK0NtEe004292@imap1.linux-foundation.org> <20071120004832.393cc5a8@the-village.bc.nu> <474291E7.5060700@cosmosbay.com> <20071120001411.4db1eb04.akpm@linux-foundation.org> <474420EE.4060603@cosmosbay.com> <20071126201717.450e44eb.akpm@linux-foundation.org>            <474BC29F.4060706@cosmosbay.com> <4651.1196148356@turing-police.cc.vt.edu>
In-Reply-To: <4651.1196148356@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 27 Nov 2007 08:58:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu a écrit :
> On Tue, 27 Nov 2007 08:09:19 +0100, Eric Dumazet said:
> 
>> Changing NR_OPEN is not considered safe because of vmalloc space potential 
>> exhaust.
> 
> Verbiage about this point...
> 
> 
>> +nr_open
>> +-------
>> +
>> +Denotes the maximum number of file-handles a process can
>> +allocate. Default value is 1024*1024 (1048576) which should be
>> +enough for most machines. Actual limit depends on RLIMIT_NOFILE
>> +resource limit.
>> +
> 
> should probably be in here - can you add something of the form "Setting this
> too high can cause vmalloc failures, especially on smaller-RAM machines",
> and/or *say* how much RAM the default takes?  Sure, it's 1M entries, but
> my tuning on a 2G-RAM machine will differ if these are byte-sized, or 128-byte
> sized - one is off in a corner, the other is 1/16th of my entire memory.

vmalloc failures can already happen if you start 32 processes on i386 kernels, 
each of them wanting to open file handle number 600.000 (if their 
RLIMIT_NOFILE >= 600000)

fcntl(0, F_DUPFD, 600000);

We are not going to add warnings about vmalloc on every sysctl around there 
that could allow a root user to exhaust vmalloc space. This is a vmalloc issue 
on 32bit kernel, and quite frankly I never hit this limit.

If you take a look at vmalloc() implementation, fact that it uses a 'struct 
vm_struct *vmlist;' to track all active zones show that vmalloc() is not used 
that much.

> 
> Also, would it be useful to *lower* the value drastically, if you know a priori
> that no process should get up to 1K file handles, much less 1M? Does that
> buy me anything different than setting RLIMIT_NOFILE=1024?

NR_OPEN is the max value that RLIMIT_NOFILE can reach, nothing more.

You can set it to 256*1024*1024 or 4*1024 it wont change memory needs on your 
machine, unless you raise RLIMIT_NOFILE and one of your program leaks file 
handles, or really want to open simultaneously many of them.

Most programs wont open more than 500 files, so their file table is allocated 
via kmalloc()

