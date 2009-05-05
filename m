Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZEEW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZEEW1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZEEW0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:26:53 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:55358 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZEEW0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PQ44+0feMIhLGXeyadoG3FA3RZ2tmVFuMSJPgPFbMOCcu1pVzz/PTtYR5Z6BwMlIfl
         MMjQBGnl0R3hGD30oTb53hVFDFdj8xbMq3hFPCMq/6sAo8zpS3m6bUbWlDqnVIZMzoHc
         Y2eRCUA6fWk3uBq3RzyZKGmVyZrLvdfzYFkZE=
MIME-Version: 1.0
In-Reply-To: <20090505221403.GA4714@suse.de>
References: <20090504220454.3F71148FB8@coco.kroah.org>
	 <200905052036.24106.s.L-H@gmx.de> <20090505221403.GA4714@suse.de>
Date: Wed, 6 May 2009 07:26:51 +0900
X-Google-Sender-Auth: da30a4c0cbca988d
Message-ID: <2f11576a0905051526j73dd1570nb440e4b78e3b35a9@mail.gmail.com>
Subject: Re: patch mm-fix-committed_as-underflow-on-large-nr_cpus-environment.patch 
	added to 2.6.29-stable tree
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, mel@csn.ul.ie,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/6 Greg KH <gregkh@suse.de>:
> On Tue, May 05, 2009 at 08:36:19PM +0200, Stefan Lippers-Hollmann wrote:
>> Hi
>>
>> On Dienstag, 5. Mai 2009, gregkh@suse.de wrote:
>> [...]
>> > From 00a62ce91e554198ef28234c91c36f850f5a3bc9 Mon Sep 17 00:00:00 2001
>> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > Date: Thu, 30 Apr 2009 15:08:51 -0700
>> > Subject: mm: fix Committed_AS underflow on large NR_CPUS environment
>> >
>> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> >
>> > commit 00a62ce91e554198ef28234c91c36f850f5a3bc9 upstream.
>> >
>> > The Committed_AS field can underflow in certain situations:
>> >
>> > >         # while true; do cat /proc/meminfo  | grep _AS; sleep 1; done | uniq -c
>> > >               1 Committed_AS: 18446744073709323392 kB
>> > >              11 Committed_AS: 18446744073709455488 kB
>> > >               6 Committed_AS:    35136 kB
>> > >               5 Committed_AS: 18446744073709454400 kB
>> > >               7 Committed_AS:    35904 kB
>> > >               3 Committed_AS: 18446744073709453248 kB
>> > >               2 Committed_AS:    34752 kB
>> > >               9 Committed_AS: 18446744073709453248 kB
>> > >               8 Committed_AS:    34752 kB
>> > >               3 Committed_AS: 18446744073709320960 kB
>> > >               7 Committed_AS: 18446744073709454080 kB
>> > >               3 Committed_AS: 18446744073709320960 kB
>> > >               5 Committed_AS: 18446744073709454080 kB
>> > >               6 Committed_AS: 18446744073709320960 kB
>> >
>> > Because NR_CPUS can be greater than 1000 and meminfo_proc_show() does
>> > not check for underflow.
>> >
>> > But NR_CPUS proportional isn't good calculation.  In general,
>> > possibility of lock contention is proportional to the number of online
>> > cpus, not theorical maximum cpus (NR_CPUS).
>> >
>> > The current kernel has generic percpu-counter stuff.  using it is right
>> > way.  it makes code simplify and percpu_counter_read_positive() don't
>> > make underflow issue.
>>
>> This patch reproducably panics on all systems I could test so far on
>> 2.6.29.2 + the current stable queue:
>> - Acer Aspire One, Intel Atom N270, Intel 945GC chipset (i386)
>> - AMD64 3200+, nVidia nforce3 chipset (amd64)
>> - AMD64 X2 4200+, nVidia nforce4 chipset (amd64)
>>
>> Kernel panic (sorry, this is from a bad webcam and only the last part of
>> the messages scrolling by - I can try to get a serial console tomorrow),
>> taken from an AMD64 3200+, nVidia nforce3 chipset (amd64).
>> http://sidux.com/slh/mm-fix-committed_as-underflow-on-large-nr_cpus-environment/panic.gif [198 KB]
>>
>> Reverting just this patch fixes the problem for me.
>>
>> Kernel configurations:
>> http://sidux.com/slh/mm-fix-committed_as-underflow-on-large-nr_cpus-environment/config-2.6.29-2.slh.5.3-sidux-686   [96 KB]
>> http://sidux.com/slh/mm-fix-committed_as-underflow-on-large-nr_cpus-environment/config-2.6.29-2.slh.5.6-sidux-amd64 [91 KB]
>
> Yes, I just confirmed this on my machines as well, so I'm going to drop
> it from the stable queue.
>
> If anyone thinks it is really necessary for the 2.6.29-stable tree,
> please resubmit it after fixing it and testing that it works :)
>
> thanks,

Could you please post oops log?
current mmotm (include this patch) works fine on my x86_64 box. Then,
I have no hint now ;-)
