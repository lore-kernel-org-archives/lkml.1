Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZILDhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZILDhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZILDhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:37:53 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48691 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZILDhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ncI9mQVPWkaaN3Fggi7ABqMP7u4oajsw9YmZF007jrox17Crf+GWfCrmCpRRW7lNq6
         1DYtoQfSlLTdOdVEx/m5bMVuhH5kaNj+kwEN5Q7qB2KF94g2qunod7lfiHA7jB4Cbhmy
         M1LDiw26RYdSBXKLJJfdvLEGewWPtM07IY3sw=
MIME-Version: 1.0
In-Reply-To: <25410990.post@talk.nabble.com>
References: <25410990.post@talk.nabble.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 11 Sep 2009 23:37:35 -0400
Message-ID: <3e8340490909112037p3b4d4f32p2dc6dda01cfcb8ea@mail.gmail.com>
Subject: Re: Controlling memory allocation
To: sidc7 <siddhartha.chhabra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 10:23 PM, sidc7 <siddhartha.chhabra@gmail.com> wrote:
>
> I had a question regarding memory allocation. On a contemporary system, the
> kernel will allocate physical frames on the DRAM based on availability. Is
> it possible for the kernel to somehow restrict frame allocation for a
> particular process to a particular address range. For e.g. Lets assume the
> DRAM ranges from 00-FF, on a contemporary system, the entire range is
> available for the kernel to allocate to the processes. Is it possible for
> the kernel to say PID 1: the frames will be allocated only in 00-A0, PID2:
> the frames will be allocated from A1 - D0 and PID3: will get frames from D1
> - FF.

The kernel has a concept of 'zones' that can be used to restrict
allocations as you say - however, user processes are the _least_
restricted. These zones are used to deal with old devices that can't
do DMAs above 16mb (so memory for their DMA buffers is allocated from
the 'DMA' zone), as well as to keep the kernel's internal
datastructures within the first 700mb or so of RAM (zone 'normal').
Memory used directly by userspace processes, including cache, can come
from any zone, including zone 'highmem'.

There's also some work on NUMA memory allocation policies - I'm not
too familiar with the details, but it does involve setting a
preference that pages for certain user processes get allocated from
certain memory banks near the CPU(s) that are executing the process.

Note that in both cases the assignments are somewhat static - zones
are set at compile time and are used solely as a workaround for
hardware limitations; exactly which are used depend on your
architecture (although the _types_ of zones available are fixed). See
include/linux/mmzones.h NUMA is determined by your hardware
configuration. And processes are never assigned just a contiguous,
exclusive range of pages to use, as there's no benefit in doing so -
what happens if something else took some of those first and it runs
out, after all?

For more information about zones, see
http://lxr.linux.no/linux+v2.6.31/include/linux/mmzone.h#L190 and the
x86 arch init code starting at
http://lxr.linux.no/linux+v2.6.31/arch/x86/mm/init_32.c#L737 etc.
For more info on NUMA, see the userspace API at
http://linux.die.net/man/3/numa and the paper at
http://www.kernel.org/pub/linux/kernel/people/christoph/pmig/numamemory.pdf
