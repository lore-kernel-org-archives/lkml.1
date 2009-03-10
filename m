Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZCJLWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZCJLWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbZCJLWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:22:16 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:41660 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbZCJLWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:22:15 -0400
Date: Tue, 10 Mar 2009 12:24:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Absolute symbols in vmlinux_64.lds.S
Message-ID: <20090310112410.GA27997@uranus.ravnborg.org>
References: <49B5AD6A.2020101@goop.org> <49B5C12B.1020108@kernel.org> <20090310053721.GA25977@uranus.ravnborg.org> <86802c440903092257i4b95b13evaabf50409b770113@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440903092257i4b95b13evaabf50409b770113@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 10:57:19PM -0700, Yinghai Lu wrote:
> On Mon, Mar 9, 2009 at 10:37 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Mon, Mar 09, 2009 at 06:23:55PM -0700, Yinghai Lu wrote:
> >> Jeremy Fitzhardinge wrote:
> >> > Why does vmlinux_64.lds.S use absolute symbols for things like
> >> > __bss_start/stop:
> >> >
> >> >  __bss_start = .;        /* BSS */
> >> >  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
> >> >     *(.bss.page_aligned)
> >> >     *(.bss)
> >> >     }
> >> >  __bss_stop = .;
> >> >
> >> >
> >> > vmlinux_32.lds.S puts __bss_start/stop into the .bss section itself.  Is
> >> > there some particular reason they need to be absolute symbols
> >> > (relocation?).
> >> >
> >>
> >> they are the same.
> >
> > Thats depends on the value of '.' where you assign __bss_start.
> > We have had several bugs where the symbol assinged outside the
> > section was less than expected because the linker aling the
> > start of the section equal to the lrgest alignment requirement
> > of a member in the section.
> >
> > So in this case if '.' equals to 0xabcd and the lagest
> > alignment requirement inside the block is 0x1000 and we have
> > __bss_start1 = .;
> > .bss : {
> >        __bss_start2 = .;
> >        *(.bss.page_aligned)
> > }
> >
> > Then you would see that:
> > __bss_start1 equals 0xabcd
> > __bss_start2 equals 0xb000
> 
> good to know...
> 
> anyway, more lines
> 
>   . = ALIGN(PAGE_SIZE);
>   __nosave_begin = .;
>   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
>       *(.data.nosave)
>   } :data.init2 /* use another section data.init2, see PERCPU_VADDR() above */
>   . = ALIGN(PAGE_SIZE);
>   __nosave_end = .;
> 
>   __bss_start = .;              /* BSS */
>   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
>         *(.bss.page_aligned)
>         *(.bss)
>         }
>   __bss_stop = .;
> 
>   _end = . ;
> 
> 
> there are extra ALIGN(PAGE_SIZE) between them....

So you say that we do hit this issue here - right.
But the better way to do it is to include the assignment inside the {} block,
thus we are not dependent on an ALIGN() that logically belongs to .data_nosave.

	Sam
