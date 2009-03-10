Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZCJFff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZCJFff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZCJFf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:35:27 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43228 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZCJFf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:35:26 -0400
Date: Tue, 10 Mar 2009 06:37:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Absolute symbols in vmlinux_64.lds.S
Message-ID: <20090310053721.GA25977@uranus.ravnborg.org>
References: <49B5AD6A.2020101@goop.org> <49B5C12B.1020108@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B5C12B.1020108@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 06:23:55PM -0700, Yinghai Lu wrote:
> Jeremy Fitzhardinge wrote:
> > Why does vmlinux_64.lds.S use absolute symbols for things like
> > __bss_start/stop:
> > 
> >  __bss_start = .;        /* BSS */
> >  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
> >     *(.bss.page_aligned)
> >     *(.bss)
> >     }
> >  __bss_stop = .;
> > 
> > 
> > vmlinux_32.lds.S puts __bss_start/stop into the .bss section itself.  Is
> > there some particular reason they need to be absolute symbols
> > (relocation?).
> > 
> 
> they are the same.

Thats depends on the value of '.' where you assign __bss_start.
We have had several bugs where the symbol assinged outside the
section was less than expected because the linker aling the
start of the section equal to the lrgest alignment requirement
of a member in the section.

So in this case if '.' equals to 0xabcd and the lagest
alignment requirement inside the block is 0x1000 and we have
__bss_start1 = .;
.bss : {
	__bss_start2 = .;
	*(.bss.page_aligned)
}

Then you would see that:
__bss_start1 equals 0xabcd
__bss_start2 equals 0xb000

Which may result in unexpected behaviour.

The case I have in mind prevented the kernel from booting!
So unless there are specific reasons (which should be documented)
then always move the assignmnets inside the {} block.

	Sam
