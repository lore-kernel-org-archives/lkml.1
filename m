Return-Path: <linux-kernel-owner+w=401wt.eu-S932270AbZJBBkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbZJBBkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbZJBBkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:40:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45897 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbZJBBkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:40:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Oct 2009 10:37:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20091002103755.ba0fbb10.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091002094238.6e1a1e5a.kamezawa.hiroyu@jp.fujitsu.com>
References: <4AB9A0D6.1090004@crca.org.au>
	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABC80B0.5010100@crca.org.au>
	<20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC0234F.2080808@crca.org.au>
	<20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090928033624.GA11191@localhost>
	<20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0909281637160.25798@sister.anvils>
	<a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com>
	<Pine.LNX.4.64.0909282134100.11529@sister.anvils>
	<20090929105735.06eea1ee.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910011238190.10994@sister.anvils>
	<20091002094238.6e1a1e5a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009 09:42:38 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > > 
> > > (2) All vm macros should be defined with ULL suffix. for supporing ~ 
> > > ==
> > > vm_flags           30 arch/x86/mm/hugetlbpage.c 	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
> > > 
> > > (3) vma_merge()'s vm_flags should be ULL.
> > 
> > At first I thought you'd saved me a lot of embarrassment by mentioning
> > those ULL suffixes, I hadn't put them in.  But after a quick test of
> > what I thought was going to show a problem without them, no problem.
> > Please would you send me a test program which demonstrates the need
> > for all those ULLs?
> > 
> Ah, I'm sorry if I misunderstand C's rule. 
> 
> There are some places which use ~.
> like
> 	vm_flags = vma->vm_flags & ~(VM_LOCKED);
> 
> ~VM_LOCKED is 
> 	0xffffdfff or 0xffffffffffffdffff ?
> 
> Is my concern.
> 
> I tried following function on my old x86 box
> ==
> #define FLAG    (0x20)
> 
> int foo(unsigned long long x)
> {
>         return x & ~FLAG;
> }
> ==
> (returning "int" as "bool")
> 
> compile this with gcc -S -O2 (gcc's version is 4.0)
> ==
> foo:
>         pushl   %ebp
>         movl    %esp, %ebp
>         movl    8(%ebp), %eax
>         andl    $-33, %eax
>         leave
>         ret
> ==
> Them, it seems higher bits are ignored for returning bool.
> 
Sigh, I seems I don't undestand C language yet..

This one
==
#define FLAG    (0x20ULL)

int foo(unsigned long long x)
{
        return (x & ~FLAG);
}
==
is compiled as
==
foo:
        pushl   %ebp
        movl    %esp, %ebp
        movl    8(%ebp), %eax
        andl    $-33, %eax
        leave
        ret
==
ULL suffix makes no difference ;)

This one
==
#define FLAG    (0x20)

int foo(unsigned long long x)
{
        if (x & ~FLAG)
                return 1;
        return 0;
}

==
foo:
        pushl   %ebp
        movl    %esp, %ebp
        movl    8(%ebp), %eax
        movl    12(%ebp), %edx
        andl    $-33, %eax
        orl     %edx, %eax
        setne   %al
        movzbl  %al, %eax
        leave
        ret

seems good.


Hmm. sorry for noise. Maybe I don't understand C's cast rules.

-Kame









