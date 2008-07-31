Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYGaIsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYGaIsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYGaIsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:48:24 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:27606 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751157AbYGaIsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:48:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o+pZ8H9sKS63hTJNbOwAN3IfaeseO7CuOSrnm9mo9aVusPBc+qZe0HDf40LIcFz6YVXPwg3TSIqzUnEKH9DNwh1/MDdoChH70pczZfZydzBnu/+/6fiu88B7WvBsWgZCZU8s1vjnCgj15SyvwxiICwg+MMVZ0m35MJRZslCQI4o=  ;
X-YMail-OSG: phT4Qe4VM1m.4D9yw60dLrEkKOXyXdlV0Tt9KimIGH5icRuQYvokr1v29sOdb5hWOGoHbI9XPnw64pU5pvM9wFzuHeYWULWOxoUe5BiUwLvghVbSOaIHqi4WpDF7LcLbico-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Date: Thu, 31 Jul 2008 18:48:12 +1000
User-Agent: KMail/1.9.5
Cc: Avi Kivity <avi@qumranet.com>, Adrian Bunk <bunk@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200807301438.55941.rusty@rustcorp.com.au> <200807311810.57821.nickpiggin@yahoo.com.au> <20080731012151.41733ef6.akpm@linux-foundation.org>
In-Reply-To: <20080731012151.41733ef6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311848.13142.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 18:21, Andrew Morton wrote:
> On Thu, 31 Jul 2008 18:10:57 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Thursday 31 July 2008 17:02, Andrew Morton wrote:
> > > On Thu, 31 Jul 2008 09:43:59 +0300 Avi Kivity <avi@qumranet.com> wrote:
> > > > Surprised.  Why not an out-of-line function?  Would eliminate the
> > > > present discussion as well.
> > >
> > > Excellent question!
> >
> > Like this?
>
> Boy, that cleaned out a lot of crud, didn't it?

Yes.


> > +int __attribute__((weak)) get_user_pages_fast(unsigned long start,
> > +				int nr_pages, int write, struct page **pages)
> > +{
> > +	struct mm_struct *mm = current->mm;
> > +	int ret;
> > +
> > +	down_read(&mm->mmap_sem);
> > +	ret = get_user_pages(current, mm, start, nr_pages,
> > +					write, 0, pages, NULL);
> > +	up_read(&mm->mmap_sem);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(get_user_pages_fast);
>
> hm, OK, I guess there's no reason why gcc should muck up the export of
> a weak symbol.

Well it seemed to compile both with and without the arch override, and
I added a get_user_pages_fast call to a module and no warnings of any
kind.


> >  pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
> >  			spinlock_t **ptl)
> >  {
> > Index: linux-2.6/arch/x86/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/Kconfig	2008-07-31 18:08:35.000000000 +1000
> > +++ linux-2.6/arch/x86/Kconfig	2008-07-31 18:08:53.000000000 +1000
> > @@ -22,7 +22,6 @@ config X86
> >  	select HAVE_IDE
> >  	select HAVE_OPROFILE
> >  	select HAVE_IOREMAP_PROT
> > -	select HAVE_GET_USER_PAGES_FAST
> >  	select HAVE_KPROBES
> >  	select ARCH_WANT_OPTIONAL_GPIOLIB
> >  	select HAVE_KRETPROBES
> > Index: linux-2.6/arch/x86/mm/Makefile
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/mm/Makefile	2008-07-31 18:08:58.000000000
> > +1000 +++ linux-2.6/arch/x86/mm/Makefile	2008-07-31 18:09:07.000000000
> > +1000 @@ -1,7 +1,6 @@
> >  obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
> > -	    pat.o pgtable.o
> > +	    pat.o pgtable.o gup.o
> >
> > -obj-$(CONFIG_HAVE_GET_USER_PAGES_FAST) += gup.o
> >  obj-$(CONFIG_X86_32)		+= pgtable_32.o
> >
> >  obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
>
> If we do this then corresponding changes should be made to the powerpc
> patch upon which Ben presently sits.

Powerpc will still use the CONFIG symbol for the moment because 32-bit TLB
flushing has not been verified to work, so we don't want to pull in the
64-bit gup. There is some discussion going on, but they probably need at
least to implement pte_special, and then also do RCU freeing of page tables.
