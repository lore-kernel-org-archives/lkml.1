Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbXLSPDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbXLSPDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXLSPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:03:32 -0500
Received: from il.qumranet.com ([82.166.9.18]:34322 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015AbXLSPDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:03:31 -0500
Message-ID: <476932C1.8040703@qumranet.com>
Date: Wed, 19 Dec 2007 17:03:29 +0200
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
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <4762AA68.9030507@qumranet.com> <4763385E.9040106@reed.com>
In-Reply-To: <4763385E.9040106@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> Avi Kivity wrote:
>> kvm will forward a virtual machine's writes to port 0x80 to the real 
>> port.  The reason is that the write is much faster than exiting and 
>> emulating it; the difference is measurable when compiling kernels.
>>
>> Now if the cause is simply writing to port 0x80, then we must stop 
>> doing that.  But if the reason is the back-to-back writes, when we 
>> can keep it, since the other writes will be trapped by kvm and 
>> emulated.  Do you which is the case?
>>
> As for kvm, I don't have enough info to know anything about that.  Is 
> there a test you'd like me to try?
>

I have a test, but I see that it is broken for mainline.  I'll update it 
eventually, but...

> I think you are also asking if the crash on these laptops is caused 
> only by back-to-back writes.  Actually, it doesn't seem to matter if 
> they are back to back.  I can cause the crash if the writes to 80 are 
> very much spread out in time - it seems only to matter how many of 
> them get executed - almost as if there is a buffer overflow.  (And of 
> course if you do back to back writes to other ports that are 
> apparently fully unused, such as 0xED on my machine, no crash occurs).
>
> I believe (though no one seems to have confirming documentation from 
> the chipset or motherboard vendor) that port 80 is actually functional 
> for some unknown function on these machines.   (They do respond to 
> "in" instructions faster than a bus cycle abort does - more evidence).

That seems to be sufficient evidence for me to remove port 0x80 
pass-through from kvm and emulate it instead.  Given that port 80 writes 
take 1 microsecond, and that an in-kernel exit handler takes a similar 
amount of time, there won't be any significant performance loss.

-- 
error compiling committee.c: too many arguments to function

