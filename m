Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZEOBQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZEOBQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZEOBQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:16:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:50987 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZEOBQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pg7bEUaYqEjD0bbQhUx9m7Z6qZAZNlzmJl8vLMYlJvMPU66Qy/qF1nmu1xNBs/EPQQ
         DSwj6Y1GH/gFT8ZM5T5++YxI3ZT3vtkhSNf9ssdG97QicKJ09Otwaw/ll6Ij5qTiGw/s
         Ik1XKQ58x7AisgdQfT58BVgGaJcRCQL98cPrs=
MIME-Version: 1.0
In-Reply-To: <20090506200954.GA21484@elte.hu>
References: <m1vdogbows.fsf@fess.ebiederm.org>
	 <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu>
	 <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu>
	 <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu>
	 <20090506162543.GT31071@waste.org>
	 <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
	 <20090506200954.GA21484@elte.hu>
Date: Fri, 15 May 2009 09:16:17 +0800
Message-ID: <2375c9f90905141816s4a9bfb8ck33dfc4395d2d9f00@mail.gmail.com>
Subject: Re: [patch] random: make get_random_int() more random
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 4:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Wed, 6 May 2009, Matt Mackall wrote:
>>
>> > On Wed, May 06, 2009 at 12:30:34PM +0200, Ingo Molnar wrote:
>>
>> > > (Also, obviously "only" covering 95% of the Linux systems has
>> > > its use as well. Most other architectures have their own cycle
>> > > counters as well.)
>> >
>> > X86 might be 95% of desktop. But it's a small fraction of Linux
>> > systems once you count cell phones, video players, TVs, cameras,
>> > GPS devices, cars, routers, etc. almost none of which are
>> > x86-based. In fact, just Linux cell phones (with about an 8%
>> > share of a 1.2billion devices per year market) dwarf Linux
>> > desktops (maybe 5% of a 200m/y market).
>>
>> Matt, are you willing to ack my suggested patch which adds history
>> to the mix? Did somebody test that? I have this memory of there
>> being an "exploit" program to show the non-randomness of the
>> values, but I can't recall details, and would really want to get a
>> second opinion from somebody who cares about PRNG's.
>
> I tested it, and besides booting up fine, i also tested the
> get_random_int() randomness. I did this by adding this quick
> trace_printk() line:
>
>   trace_printk("get_random_int(): %08x\n", get_random_int());
>
> to sys_prctl() and triggered sys_prctl() in a loop, which gave a
> list of get_random_int() numbers:
>
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>           <...>-6288  [000]   618.151323: sys_prctl: get_random_int(): 2e927f66
>           <...>-6290  [000]   618.152924: sys_prctl: get_random_int(): d210df1f
>           <...>-6293  [000]   618.155326: sys_prctl: get_random_int(): 753ad860
>           <...>-6295  [000]   618.156939: sys_prctl: get_random_int(): c74d935f
>           <...>-6298  [000]   618.159334: sys_prctl: get_random_int(): bb4e7597
>           <...>-6300  [000]   618.160936: sys_prctl: get_random_int(): b0119885
>           <...>-6303  [000]   618.163331: sys_prctl: get_random_int(): 093f5c70
>

I used systemtap to test this patch too, the result is too obvious. :-)
Samples of output are the following:

==before this patch==
get_random_int returns: f3f71569
get_random_int returns: f3f71569
get_random_int returns: f3f71569
get_random_int returns: f3f71569
get_random_int returns: f3f71569
get_random_int returns: f3f71569
get_random_int returns: c3e650c8
get_random_int returns: c3e650c8
get_random_int returns: c3e650c8
get_random_int returns: c3e650c8
get_random_int returns: c3e650c8
get_random_int returns: c3e650c8

==after this patch==
get_random_int returns: b7566a5b
get_random_int returns: f4b86171
get_random_int returns: 25dd8fd8
get_random_int returns: 58ab81ce
get_random_int returns: f39dbcb2
get_random_int returns: cbf308f9
get_random_int returns: 32d9c09e
get_random_int returns: 4eedfcad
get_random_int returns: fe87cb99
get_random_int returns: 1bd42857
get_random_int returns: 837cf921
get_random_int returns: d9a39d80


Hope this helps.

Thanks!
