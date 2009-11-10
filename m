Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZKJWXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZKJWXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZKJWXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:23:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZKJWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:23:05 -0500
Message-ID: <4AF9E61B.5090407@zytor.com>
Date: Tue, 10 Nov 2009 14:15:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu>
In-Reply-To: <20091110220652.GE26633@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 02:06 PM, Willy Tarreau wrote:
> On Tue, Nov 10, 2009 at 01:19:30PM -0800, H. Peter Anvin wrote:
>> Willy, perhaps you can come up with a list of features you think should
>> be emulated, together with an explanation of why you opted for that list
>> of features and *did not* opt for others.
> 
> Well, the instructions I had to emulate were the result of failures
> to run standard distros on older machines. When I ran a 486 distro
> on my old 386, I found that almost everything worked except a few
> programs making use of BSWAP for htonl(), and a small group of other
> ones making occasional use of CMPXCHG for mutex handling. So I checked
> the differences between 386 and 486 and found that the last remaining
> one was XADD which I did not find in my binaries but which was really
> obvious to implement, so it made sense to complete the emulator. That
> said, a feature was missing with CMPXCHG. It was generally used with
> a LOCK prefix which could not be emulated. In practice, that wasn't
> an issue since I did not have any SMP i386 and I think we might only
> find them on some very specific industrial boards if any.
> 

Linux doesn't support 386 SMP anyway, and we really don't support 486
SMP either since noone relevant seems to have a board we can test on.

> But what I can say is that after emulating those instructions, I
> never got any illegal instruction anymore on my systems. Here
> Matteo reports an issue with NOPL, which might have been introduced
> with newer compilers. So if we get NOPL+CMOV, I think that every
> CPU starting from 486 will be able to execute all the applications
> I have been running on those machines. We can add the 486 ones if
> we think it's worth it.

NOPL was introduced with a recent binutils(!) change.  They might have
backed that one out.

> Once again, I have no argument against emulating more instructions.
> It's just that I never needed them, and I fear that doing so might
> render the code a lot more complex and slower. Maybe time will prove
> me wrong and I will have no problem with that. We can re-open this
> thread after the first report of a SIGILL with the patch applied.
> 
> So in my opinion, we should have :
>   - CMOV (for 486, Pentium, C3, K6, ...)
>   - NOPL (newcomer)
> 
> And if we want to extend down to i386 :
>   - BSWAP (=htonl)
>   - CMPXCHG (mutex)
>   - XADD (never encoutered but cheap)
> 
> I still have the 2.4 patch for BSWAP, CMPXCHG, CMOV and XADD lying
> around. I'm appending it to the end of this mail in case it can fuel
> the discussion. I've not ported it to 2.6 yet simply because my old
> systems are still on 2.4, but volunteers are welcome :-)
> 
>> Note: emulated FPU is a special subcase.  The FPU operations are
>> heavyweight enough that the overhead of trapping versus library calls is
>> relatively insignificant.
> 
> Agreed for most of them, though some cheap ones such as FADD can
> see a huge difference. In fact it's mostly that it's been common
> for a long time to see slow software FPU (till 386 & 486-SX), so
> it's been avoided for a long time.
> 
> Regards,
> Willy

I immediately note that you have absolutely no check on the code
segment, either in terms of code segment limits or even that we're in
the right mode.  Furthermore, you read user space -- code in user space
is still user space -- without get_user().  We also need NX protection
to be honoured, and the various special subtleties of the x86
instruction format (15-byte limit, for example) to be preserved: they
aren't just there randomly, but are there to protect against specific
failures.

*THIS* is the kind of complexity that makes me think that having a
single source for all interpretation done in the kernel is the preferred
option.

	-hpa
