Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZIPJJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZIPJJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbZIPJJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:09:32 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:57877 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbZIPJJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YVp2/XU/2AhvWDO+TA+kOcQGsgRCYRp+yEQdfeQtDoFDmh7BOvp3tyZ0u9mbj25jc3
         8zZ+UbT26yKY8Kqdr9nXiHu8g5BQN7hRH718C1MnPmKIVpefAluxKwmqrRoz1dTtsWZp
         ibmq9n7EcaG8axp0SYMhTSxlwD/ATAkRZ/QLM=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909151057020.26095@sister.anvils>
References: <20090915021851.168285585@intel.com>
	 <20090915120939.bcc571e1.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090915082200.GA2588@localhost>
	 <Pine.LNX.4.64.0909151057020.26095@sister.anvils>
Date: Wed, 16 Sep 2009 11:01:17 +0200
X-Google-Sender-Auth: b47acf45ad9ca1cb
Message-ID: <10f740e80909160201l4834369s75e63fe8df0991aa@mail.gmail.com>
Subject: Re: [PATCH 0/3] /proc/kmem cleanups and hwpoison bits
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 12:16, Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> On Tue, 15 Sep 2009, Wu Fengguang wrote:
>> On Tue, Sep 15, 2009 at 11:09:39AM +0800, KAMEZAWA Hiroyuki wrote:
>> > On Tue, 15 Sep 2009 10:18:51 +0800
>> > Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >
>> > > Hi Kame,
>> > >
>> > > Here are 3 more kmem patches in my queue. Comments are welcome.
>> > > If you feel good about them, I can send all recent kmem cleanup
>> > > patches for you.
>> > >
>> >
>> > This is my quick hack. But I don't want to be an obstacle for you.
>> > So, I'll wait for your updates.
>>
>> Thanks. This is also a bug fix: vmalloc_to_page() will otherwise BUG()
>> on !is_vmalloc_or_module_addr() pages.
>>
>> > ==
>> > Now, /dev/kmem's read/write vmalloc area doesn't do
>> > range-check. Because vread/vwrite traverse vmalloc area list
>> > under system-wide spinlock, it's better to avoid unnecessary
>> > to do unnecessary calls to vread/vwrite.
>>
>> is_vmalloc_or_module_addr() could be put to either read_kmem()
>> or aligned_vread(), and I'm fine with both.
>>
>> It looks like vread can be shared by kmem and kcore :)
>>
>> > And, vread/vwrite returns 0 if we accessed memory holes.
>> > We can avoid copy-to-user in read side, we just ignore at write.
>> >
>> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > ---
>> >  drivers/char/mem.c |   27 +++++++++++++++++++--------
>> >  1 file changed, 19 insertions(+), 8 deletions(-)
>
> Sorry guys, I'm picking this mail pretty much at random
> as something to reply to.
>
> I'm interested to notice such work going on in drivers/char/mem.c,
> and don't have time to join in - you interact a lot faster than I
> manage, and I've other priorities to attend to; but thought I should
> at least send over the patch I've been including in my private debug
> kernels for the last couple of years (rebased to 2.6.31), which lets
> me peek and poke into /dev/kmem as I occasionally wish.
>
> Warning: it may be rubbish, it may just be a hack which appeared to
> work for me the last time I tried, on a particular address range of a
> particular set of configurations of a particular set of architectures
> (x86_32, x86_64, powerpc64).  I've never thought it through enough to
> consider submitting, but it _might_ contain something useful for you
> to factor into your own efforts.
>
> Sorry for chucking it over the wall to you in this way, but I guess
> that's better than just sitting quietly on it for a few more years.
>
> Certainly-Not-Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>  drivers/char/mem.c |  265 +++++++++++++++----------------------------
>  fs/read_write.c    |    9 +
>  2 files changed, 105 insertions(+), 169 deletions(-)
>
> but if completed would also remove vread() and vwrite() from
>
>  include/linux/vmalloc.h
>  mm/nommu.c
>  mm/vmalloc.c
>
> --- 2.6.31/drivers/char/mem.c   2009-09-09 23:13:59.000000000 +0100
> +++ 2.6.31d/drivers/char/mem.c  2009-09-10 09:38:30.000000000 +0100

> -#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
> -               /* we don't have page 0 mapped on sparc and m68k.. */

Is this `feature' removed?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
