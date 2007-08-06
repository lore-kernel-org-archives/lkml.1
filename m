Return-Path: <linux-kernel-owner+w=401wt.eu-S1763486AbXHFSSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486AbXHFSSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXHFSSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:18:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:41076 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753053AbXHFSSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:18:14 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/Woap3E6LWFSLRYzi07XXSohvbKdj53n+d3MpyqI
	f1ghv7eY/49hl7
Message-ID: <46B773F6.7060603@gmx.net>
Date: Mon, 06 Aug 2007 21:18:14 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net> <46B60FB7.8030301@interia.pl> <200708052142.14630.jimis@gmx.net> <46B748DE.1060108@interia.pl>
In-Reply-To: <46B748DE.1060108@interia.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Bilski wrote:
>> Hello and thanks for your reply. 
> Hello again,
>> The cron job that is running every 10 min on my system is mpop (a 
>> fetchmail-like program) and another running every 5 min is mrtg. Both 
>> normally finish within 1-2 seconds.
>> The fact that these simple cron jobs don't finish ever is certainly 
>> because of the high system CPU load. If you see the two_discs_bad.txt 
>> which I attached on my original message, you'll see that *vmlinux*, 
>> and specifically the *scheduler*, take up most time.
>> And the fact that this happens only when running two i/o processes but 
>> when running only one everything is absolutely snappy (not at all 
>> slow, see one_disc.txt), makes me sure that this is a kernel bug. I'd 
>> be happy to help but I need some guidance to pinpoint the problem. 
> In Your oprofile output I find "acpi_pm_read" particulary interesting. 
> Unlike other VIA chipsets, which I know, Your doesn't use VLink to 
> connect northbridge to southbridge. Instead PCI bus connects these two. 
> As You probably know maximal PCI throughtput is 133MiB/s. In theory. In 
> practice probably less.
> ACPI registers are located on southbridge. This probably means that 
> processor needs access to PCI bus in order to read ACPI timer register.
> Now some math. 20GiB disk probably can send data at 20MiB/s rate. 200GiB 
> disk probably about 40MiB/s. So 20+2*40=100MiB/s. I think that this 
> could explain why simple inl() call takes so much time and why Your 
> system isn't very responsive.
>> Thanks, Dimitris
> Let me know if You find my theory amazing or amusing.

Hello Rafal,

I find your theory very nice, but unfortunately I don't think it applies 
here. As you can see from the vmstat outputs the write throughput is 
about 15MB/s for both disks. When reading I get about 30MB/s again from 
both disks. The other disk, the small one, is mostly idle, except for 
writing little bits and bytes now and then. Since the problem occurs 
when writing, 15MB/s is just too little I think for the PCI bus.

However I find it quite possible to have reached the throughput limit 
because of software (driver) problems. I have done various testing 
(mostly "hdparm -tT" with exactly the same PC and disks since about 
kernel 2.6.8 (maybe even earlier). I remember with certainty that read 
throughput the early days was about 50MB/s for each of the big disks, 
and combined with RAID 0 I got ~75MB/s. Those figures have been dropping 
gradually with each new kernel release and the situation today, with 
2.6.22, is that hdparm gives maximum throughput 20MB/s for each disk, 
and for RAID 0 too!

I have been ignoring these performance regressions because of no 
stability problems until now. So could it be that I'm reaching the 
20MB/s driver limit and some requests take too long to be served?


Dimitris
