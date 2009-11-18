Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZKRKs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZKRKs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZKRKs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:48:26 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2118 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZKRKsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:48:25 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTAWOH-02-0AP-02
X-M-MSG: 
Date: Wed, 18 Nov 2009 11:48:55 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
Message-ID: <20091118104855.GA593@aftab>
References: <20091117191752.164451000@alcatraz.americas.sgi.com>
 <20091117191757.651569000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091117191757.651569000@alcatraz.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Nov 2009 10:48:17.0340 (UTC) FILETIME=[A2E00FC0:01CA683C]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 17, 2009 at 01:17:53PM -0600, Mike Travis wrote:
> When there are a large number of processors in a system, there
> is an excessive amount of messages sent to the system console.
> It's estimated that with 4096 processors in a system, and the
> console baudrate set to 56K, the startup messages will take
> about 84 minutes to clear the serial port.
> 
> This set of patches limits the number of repetitious messages
> which contain no additional information.  Much of this information
> is obtainable from the /proc and /sysfs.   Some of the messages
> are also sent to the kernel log buffer as KERN_DEBUG messages so
> dmesg can be used to examine more closely any details specific to
> a problem.
> 
> The list of message transformations....
> 
> For system_state == SYSTEM_BOOTING:
> 
> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.

Aren't we missing core 0 here?

> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
> ..
> Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
> Brought up 64 CPUs

Also, I'm getting

Booting Node   0, Processors  #1
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
 #2
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
 #3
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
 #4
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
 #5
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
 Ok.
Booting Node   1, Processors  #6
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
 #7

...

and clearly CPU cache info is too verbose. We might want to
kill it since we have it replicated in /sysfs. In that case,
arch/x86/kernel/cpu/common.c:display_cacheinfo() could become obsolete
and we could remove it... Or is there some reason for dumping that
particular information during boot?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

