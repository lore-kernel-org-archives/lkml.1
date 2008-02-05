Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYBEMvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYBEMvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYBEMuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:50:54 -0500
Received: from styx.suse.cz ([82.119.242.94]:33518 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752106AbYBEMux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:50:53 -0500
Date: Tue, 5 Feb 2008 13:50:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Re: brk randomization breaks columns
In-Reply-To: <20080205110632.GB3758@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
 <20080205110632.GB3758@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Pavel Machek wrote:

> > Actually, this clearly shows that either prehistoric libc.so.5 or the 
> > program itself are broken.
> I believe it shows clear regression in latest 2.6.25 kernel.

I am still not completely sure. It might be a regression, but it also 
might just trigger the bug in ancient version in libc.so.5 which might be 
fixed in some later version -- are you able to verify that?

> You say it is wrong. Manpages imply otherwise:
> 
>        int brk(void *end_data_segment);
> ...
> DESCRIPTION
>        brk()  sets  the  end  of  the  data  segment  to  the  value specified  by
>        end_data_segment, when that value is reasonable, the system does have enough
>        memory and the process does not exceed its max data size (see setrlimit(2)).
> Note it talks about data segment, not about heap, and that seems to
> imply that BSS and heap are actually one area. 2.6.25 broke that.

Single Unix Specification talks only about manipulating the break section, 
see http://opengroup.org/onlinepubs/007908775/xsh/brk.html

> Now, maybe you are right and heap randomization is useful, but breaking 
> 10year old executables is no-no. 

Even if the bug is in 10year old library which might have been fixed by a 
later update? (I don't know how to verify this, libc.so.5 is so ancient 
that it's difficult to find anything about that).

> 1) not enable heap randomization unless app asks for it by personality 
>    syscall

That (beyond other things) doesn't fit into the whole randomization 
picture, as all other aspect of memory space randomization are dependent 
only on 'randomize_va_space' and nothing else ... adding something special 
just for brk seems to be messy.

> 2) (hacky!) detect that app asks for brk() below its heap start, which
> means it assumes BSS+heap are contiguous, and just map the memory there.

That's really ugly :)

> > Still, it will probably not fix your particular program crashes, just 
> > because it will always assume that brk starts immediately after the end of 
> > the bss, which is plain wrong and has never been assured. Could you please 
> Can you quote docs that tells me it is plain wrong? 

See the Single Unix Specification. It doesn't seem to allow you to assume 
*anything* about start_brk location, seems to me.

Now, I am perfectly fine with reverting that patch for 2.6.25 unless 
someone is able to come up with something clever. It is quite unfortunate 
though, that we possibly give up quite reasonable security measure just 
because 10-year-old libc assumes something that it possibly isn't allowed 
to. Arjan, I know you have been working on brk randomization previously, 
do you have any input here?

Thanks,

-- 
Jiri Kosina
SUSE Labs
