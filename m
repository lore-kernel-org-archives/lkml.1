Return-Path: <linux-kernel-owner+w=401wt.eu-S1751394Ab0AVFuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab0AVFuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 00:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273Ab0AVFuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 00:50:06 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40509 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0AVFuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 00:50:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QEzSEhKeS2UGFGjk1Hvv0GNGSEHl/vXuYamBkE89MTzcH6TWqnrLLKjH2sJNHEjXMO
         Sghznu57Zb9cXGw02seE3us/1POsUuxjr2PfLMZdWD1YnkpXotpzy7oQvZz5H+/Na+NL
         6c3nhraei7N54wxYro5QJp7hUhwLANXJdjslI=
MIME-Version: 1.0
In-Reply-To: <20100122053711.GB3761@localhost>
References: <20100122032102.137106635@intel.com>
	 <20100122033004.193166010@intel.com>
	 <7b6bb4a51001212115j741e91c4p61f3f1d6e2ec1de4@mail.gmail.com>
	 <20100122053711.GB3761@localhost>
Date: Fri, 22 Jan 2010 13:50:01 +0800
Message-ID: <7b6bb4a51001212150h32f62e53ga230b381ce5da126@mail.gmail.com>
Subject: Re: [PATCH 1/3] resources: introduce generic page_is_ram()
From: Xiaotian Feng <xtfeng@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 1:37 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Thu, Jan 21, 2010 at 10:15:50PM -0700, Xiaotian Feng wrote:
>> On Fri, Jan 22, 2010 at 11:21 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > It's based on walk_system_ram_range(), for archs that don't have
>> > their own page_is_ram().
>> >
>> > The static verions in MIPS and SCORE are also made global.
>> >
>> > CC: Chen Liqin <liqin.chen@sunplusct.com>
>> > CC: Lennox Wu <lennox.wu@gmail.com>
>> > CC: Ralf Baechle <ralf@linux-mips.org>
>> > CC: Américo Wang <xiyou.wangcong@gmail.com>
>> > CC: linux-mips@linux-mips.org
>> > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > CC: Yinghai Lu <yinghai@kernel.org>
>> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>> > ---
>> >  arch/mips/mm/init.c    |    2 +-
>> >  arch/score/mm/init.c   |    2 +-
>> >  include/linux/ioport.h |    2 ++
>> >  kernel/resource.c      |   11 +++++++++++
>> >  4 files changed, 15 insertions(+), 2 deletions(-)
>> >
>> > --- linux-mm.orig/kernel/resource.c     2010-01-22 11:20:34.000000000 +0800
>> > +++ linux-mm/kernel/resource.c  2010-01-22 11:20:35.000000000 +0800
>> > @@ -327,6 +327,17 @@ int walk_system_ram_range(unsigned long
>> >
>> >  #endif
>> >
>> > +#define PAGE_IS_RAM    24
>> > +static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
>> > +{
>> > +       return PAGE_IS_RAM;
>> > +}
>> > +int __attribute__((weak)) page_is_ram(unsigned long pfn)
>> > +{
>> > +       return PAGE_IS_RAM == walk_system_ram_range(pfn, 1, NULL, __is_ram);
>> > +}
>> > +#undef PAGE_IS_RAM
>> > +
>>
>> I'm not sure, but any build test for powerpc/mips/score?
>
> Sorry, no build tests yet:
>
>        /bin/sh: score-linux-gcc: command not found
>
> I just make the mips/score page_is_ram() non-static and assume that
> will make it compile.
>
>> walk_system_ram_range is defined when CONFIG_ARCH_HAS_WALK_MEMORY is not set.
>> Is it safe when CONFIG_ARCH_HAS_WALK_MEMORY is set for some powerpc archs?
>
> Good question. Grep shows that CONFIG_ARCH_HAS_WALK_MEMORY is only
> defined for powerpc, and it has its own page_is_ram() as well as
> walk_system_ram_range().
>
> walk_system_ram_range() must be defined somewhere because it is
> expected to be generic routine: exported and called from both
> in-kernel and out-of-tree code.
>

Yes, powerpc has its own walk_system_ram_range() and page_is_ram() ;-)

Would it be better if moving the weak attribute page_is_ram() into #if
!defined(CONFIG_ARCH_HAS_WALK_MEMORY) ?

> Thanks,
> Fengguang
>
