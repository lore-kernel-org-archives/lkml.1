Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbXLNQNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbXLNQNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXLNQMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:12:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:55224 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbXLNQMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:12:54 -0500
Message-ID: <4762AA68.9030507@qumranet.com>
Date: Fri, 14 Dec 2007 18:08:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com>
In-Reply-To: <4761F193.7090400@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> Replace use of outb to "unused" diagnostic port 0x80 for time delay
> with udelay based time delay on x86_64 architecture machines.  Fix for
> bugs 9511 and 6307 in bugzilla, plus bugs reported in
> bugzilla.redhat.com.
>
> Derived from suggestion (that didn't compile) by Pavel Machek, and
> tested, also based on measurements of typical timings of out's
> collated by Rene Herman from many in the community.
>
> This patch fixes a number of bugs known to cause problems on HP
> Pavilion dv9000z and dv6000z laptops - in the form of solid freezes
> when hwclock is used to show or set the time.  Also, it potentially
> improves bus utilization on SMP machines, by using a waiting process
> that doesn't tie up the ISA/LPC bus for 1 or 2 microseconds.
>

kvm will forward a virtual machine's writes to port 0x80 to the real 
port.  The reason is that the write is much faster than exiting and 
emulating it; the difference is measurable when compiling kernels.

Now if the cause is simply writing to port 0x80, then we must stop doing 
that.  But if the reason is the back-to-back writes, when we can keep 
it, since the other writes will be trapped by kvm and emulated.  Do you 
which is the case?

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

