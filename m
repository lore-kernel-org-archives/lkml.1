Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbXEUH2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbXEUH2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXEUH22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:28:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33419 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbXEUH22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:28:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46514A01.5090803@s5r6.in-berlin.de>
Date: Mon, 21 May 2007 09:28:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: dan@dennedy.org
CC: Arnd Bergmann <arnd@arndb.de>, Petr Vandrovec <petr@vandrovec.name>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705200155.26825.arnd@arndb.de> <464F900A.10900@s5r6.in-berlin.de> <200705201703.37561.arnd@arndb.de> <46506912.9020904@s5r6.in-berlin.de>
In-Reply-To: <46506912.9020904@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Arnd Bergmann wrote:
>>>> Note that this data structure only needs conversion on x86_64 and ia64, but
>>>> not on powerpc and other 64 bit architectures that align __u64 also in
>>>> 32 bit mode.
...
> maybe we should change
> 
> /* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> struct raw1394_cycle_timer {
...
> 	__u32 cycle_timer;
...
> 	__u64 local_time;
> };
> 
> to
> 
> /* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> struct raw1394_cycle_timer {
...
> 	__u64 cycle_timer;
...
> 	__u64 local_time;
> };
> 
> before a libraw1394 with get-cycle-timer support is released.

On the other hand, we could handle it in the compat code alone and leave
the rest as-is.

/* PPC32 aligns this at 64bit, IA32 packs it */
struct raw1394_cycle_timer32 {
	__u32 cycle_timer;
	__u64 local_time;
}
#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
__attribute__((packed))
#endif
;

Eventually, Arnd's suggestion

> I would suggest you introduce a new __compat_u64 type as
> 
> typedef __u64 __compat_u64 __attribute__((aligned(4)));
> 
> in include/asm-{x86_64,ia64}/compat.h and as
> 
> typdef __u64 __compat_u64;
> 
> in the other architectures. Other people have hit the same problem
> before and found varying workarounds, but I think we should just
> do it correctly now.

should be put into practice though.
-- 
Stefan Richter
-=====-=-=== -=-= =-=-=
http://arcgraph.de/sr/
