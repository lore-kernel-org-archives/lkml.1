Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbXEJQZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbXEJQZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXEJQZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:25:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54455 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbXEJQZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:25:26 -0400
Date: Thu, 10 May 2007 17:28:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@muc.de>, systemtap@sources.redhat.com, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070510172843.7aa72237@the-village.bc.nu>
In-Reply-To: <20070510155501.GI22424@Krystal>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020916.508519573@polymtl.ca>
	<20070510090656.GA57297@muc.de>
	<20070510155501.GI22424@Krystal>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> * First issue : Impact on the system. If we try to make this system
>   scale, we will create very long irq disable sections. The expected
>   duration is the worse case IPI latency plus the time it takes to CPU A
>   to change the variable. We therefore directly grow the worse case
>   system's interrupt latency.

Not a huge problem. It doesn't scale in really horrible ways and the IPI
latency on a PIV or later is actually very good. Also the impact is less
than you might think as on huge huge boxes you want multiple copies of
the kernel text pages to reduce NUMA traffic, so you only have to sync
the group of processors involved 

> * Second issue : irq disabling does not protect us from NMI and traps.
>   We cannot use this algorithm to mark these code segments.

If you synchronize all the other processors and disable local interrupts
then the only traps you have to worry about are those you cause, and the
only person taking the trap will be you so you're ok.

NMI is hard but NMI is a special case not worth solving IMHO.

> * Third issue : Scalability. Changing code will stop every CPU on the
>   system for a while. Compared to this, the int3-based approach will run
>   through the breakpoint handler "if" one of the CPU happens to execute
>   this code at the wrong time. The standard case is just an IPI (to

If I read the errata right then patching in an int3 will itself trigger
the errata so anything could happen.

I believe there are other safe sequences for doing code patching - perhaps
one of the Intel folk can advise ?

Alan
