Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYIDQtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYIDQtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYIDQto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:49:44 -0400
Received: from gw.goop.org ([64.81.55.164]:34634 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYIDQtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:49:43 -0400
Message-ID: <48C011A6.2000609@goop.org>
Date: Thu, 04 Sep 2008 09:49:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eric Lacombe <tuxiko@free.fr>
CC: linux-kernel@vger.kernel.org, goretux@gmail.com
Subject: Re: [x86] fs, gs purpose & multicore prog
References: <200809031109.45660.goretux@gmail.com>
In-Reply-To: <200809031109.45660.goretux@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> Hello,
>
> I've some questions about IA-32e in Linux.
>
> - What is the FS and GS segments role inside the kernel ?
> (I was thinking about thread local storage)
>   

In a 32-bit kernel %fs is the base of the per-cpu data area.  In a
64-bit kernel %gs points to the pda (processor data area).  The pda is a
single structure, whereas per-cpu data is a section that per-cpu
variables get put into.

> - When I do a "mov %fs ..." instruction (in a module), it seems that %fs is 
> equal to 0 (idem for %gs). Are these registers not always filled ?
>   

On 32-bit they will always have a value, or you'll get a GPF.  On 64-bit
the value of the selector doesn't matter because the MSRs are the real
content.

> - What is the purpose of MSR_FS_BASE and MSR_GS_BASE ? 
> (I thought they were filled with "gdt[fs_entry].base")
>   
On 64-bit, the GDT isn't large enough to hold a 64-bit offset, so it
only stores the low 32-bits.  When you load a segment register with a
selector, it picks up from the gdt.  If you want a full 64-bit offset,
you need to write it to the msr.

> - My last question is about the kernel programation of multi-core (or 
> multiprocessor)
> architecture. I don't see a lot of documentation about that on Internet.
> Do you have some docs/urls about this topic.
> Maybe someone can briefly explain how the execution flow are given to the 
> different cores.
>   

To the kernel they're all just cpus, and it runs tasks on them as
usual.  There are a few tweaks in the scheduler to pay attention to the
shared caches and so on.

    J
