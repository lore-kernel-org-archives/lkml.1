Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbZJLTRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbZJLTRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbZJLTRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:17:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:47865 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757491AbZJLTRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:17:45 -0400
Message-ID: <4AD380A2.2030101@vmware.com>
Date: Mon, 12 Oct 2009 21:16:50 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Thomas Schlichter <thomas.schlichter@web.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jan Beulich <jbeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@jbarnes-g45>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
References: <200910122032.52168.thomas.schlichter@web.de>
In-Reply-To: <200910122032.52168.thomas.schlichter@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

One problem with this patch is that it conflicts with the way graphics 
drivers traditionally handles
the situation, namely

1) Set up mtrr
2) Map. If fallback to uncached minus we will still have write-combined 
access.

I think mtrr-add used in this fashion will typically fail due to the 
alignment constraints. In particular,
for set_memory_wc() the typical usage pattern is a large number of pages 
in a fragmented physical address space.

So if we were to fix the problem with libpciaccess in the kernel, I 
think the best option would be to fail the user-space mapping when we 
can't make it write-combined.

Thanks,
Thomas

Thomas Schlichter wrote:
> Hi,
>
> when I first sent this E-Mail on Saturday, I unfortunately forgot to CC many 
> people. Now I used get_maintainer.pl to get the list of people that may want 
> to contribute to this topic.
>
> Because of this topic, there is already a patch from Arjan in the -tip tree to 
> make PAT and MTRR options only configurable if EMBEDDED and enabled by 
> default. I think this is a step in the right direction, but at least Henrique, 
> Robert and I seem to think something like the attached patch is still 
> required. What do you think?
>
> Kind regards,
>   Thomas
>
> -----------------------------------------------------------------------------
>
> Hi,
>
> I've found a problem with X.org not setting up MTRR for the framebuffer 
> memory. After I investigated I think this is not a X.org problem, but a kernel 
> issue.
>
> X.org uses libpciaccess to map the framebuffer memory. This library opens 
> /sys/bus/pci/devices/*/resource0_wc and mmaps the memory. Unfortunately, the 
> kernel only enables write combining if PAT is enabled, if it is not, the 
> memory is mmapped uncached. But Xorg (respectively libpciaccess) thinks it was 
> successfully mapped with write combining enabled and thus does not 
> additionally set up MTRR entries.
>
> The corresponding libpciaccess code can be found here:
>   http://cgit.freedesktop.org/xorg/lib/libpciaccess/tree/src/linux_sysfs.c#n501
>
> If the kernel behavior is intentional and X.org should always set up MTRR 
> entries, why should it use /sys/.../resource0_wc at all? I think there are 2 
> possibilities to make the kernel behavior consistent:
>
>  1. The mmap_wc should fail if PAT is not enabled.
>     (libpciaccess will then map the framebuffer uncached and set up
>      MTRR entries)
>  2. Use MTRR to enable write combining if PAT is not available.
>
> In an earlier thread about ioremap_wc, Arjan van de Ven wrote that option 2 is 
> preferred over option 1:
>
>     http://lkml.indiana.edu/hypermail/linux/kernel/0805.3/2925.html
>
> So, I've created the attached patch implementing option 2. For me this solves 
> the problem with the slow Video playback due to not correctly set up MTRR 
> entries.
>
> Kind regards,
> Thomas Schlichter
>   

