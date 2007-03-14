Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXCNA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXCNA3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 20:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXCNA3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 20:29:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:44852 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXCNA3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 20:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I1mVcDK/dn+3F5MOxRzpH5EppPFzwxrKFstwj7ccpOhzAGPD7ZaxDk/afjEmm08PR1gcLCi9565vpVoUjhevFz/2LPJl081Xqy6ihWV8F4WQsxRjbg9V+vdljHjP9W0SEhGDpTzk+Az0MepR8x0XJ7y7Rks1uNkkngDFHVmxpBE=
Message-ID: <29495f1d0703131729y56a99d9cj15288e7c18e277a8@mail.gmail.com>
Date: Tue, 13 Mar 2007 17:29:17 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.20.3
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org, stable@kernel.org, sparclinux@vger.kernel.org
In-Reply-To: <29495f1d0703131551k5c06170bma138f8c1f1f9c84e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070313183353.GA7434@kroah.com>
	 <29495f1d0703131457i43883529p5da1502b68ff0948@mail.gmail.com>
	 <29495f1d0703131458j18f9aee1tcd9a2b2ff6ecdf41@mail.gmail.com>
	 <20070313.152054.31641425.davem@davemloft.net>
	 <29495f1d0703131551k5c06170bma138f8c1f1f9c84e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
> On 3/13/07, David Miller <davem@davemloft.net> wrote:
> > From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
> > Date: Tue, 13 Mar 2007 14:58:24 -0700
> >
> > > On 3/13/07, Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
> > > > On 3/13/07, Greg KH <greg@kroah.com> wrote:
> > > > > We (the -stable team) are announcing the release of the 2.6.20.3 kernel.
> > > > > It contains a number of bugfixes and all 2.6.20 users are recommended to
> > > > > upgrade.
> > > > >
> > > > > The diffstat and short summary of the fixes are below.
> > > > >
> > > > > I'll also be replying to this message with a copy of the patch between
> > > > > 2.6.20.2 and 2.6.20.3.
> > > >
> > > > Compared to 2.6.20.1 (will try 2.6.20.2 as well), I now get:
> > >
> > > err, duh -- this is a Sun Ultra 60, debian testing install.
> >
> > Figure out if 2.6.20.2 does it too, then please try to git bisect
> > it down further.
>
> Yep, that's the plan, just wanted to make folks aware.
>
> > I took a quick look and the two sparc64 commits between 2.6.20.1
> > and 2.6.20.2 are benign, a fix for E450 interrupts and a kenvctrld
> > fix which is for a driver for hardware your ultra60 doesn't have. :)
> >
> > There is a decent amount of raid and nfs fixes in here, do you
> > use either?
>
> Neither.
>
> > Another commit that might be relevant is:
> >
> > commit 530b09160744a12450fdacb2b78779c9830a29c8
> > Author: Aristeu Sergio Rozanski Filho <aristeu.sergio@gmail.com>
> > Date:   Thu Mar 1 19:02:55 2007 -0500
> >
> >     tty_io: fix race in master pty close/slave pty close path
> >
> > Hmmm...
> >
> > Please let us know if you can narrow it down further.
>
> Building 2.6.20.2 right now, will let you know.

Ok, truly bizarre, I found that I was not running stock 2.6.20.3, but
had your small hugetlb patch on top.

So I went back and patched 2.6.20.1 with your patch, rebooted, got a
soft lockup. Went back to stock 2.6.20.1 and did not.

I don't see how your patch (C&P below for reference) could make any
difference...Especially because no hugepages were in use at the time.
On patched 2.6.20.1, I was just trying to check if my source tree had
your patch applied (by `patch -p1 < davem.patch`) and got the
soft-lockup I saw in 2.6.20.3 with the patch applied. I am going to
try a clean 2.6.20.3 as well, now.

diff --git a/arch/sparc64/mm/hugetlbpage.c b/arch/sparc64/mm/hugetlbpage.c
index 33fd0b2..00677b5 100644
--- a/arch/sparc64/mm/hugetlbpage.c
+++ b/arch/sparc64/mm/hugetlbpage.c
@@ -248,6 +248,7 @@ void set_huge_pte_at(struct mm_struct *mm,
unsigned long addr,
        if (!pte_present(*ptep) && pte_present(entry))
                mm->context.huge_pte_count++;

+       addr &= HPAGE_MASK;
        for (i = 0; i < (1 << HUGETLB_PAGE_ORDER); i++) {
                set_pte_at(mm, addr, ptep, entry);
                ptep++;
@@ -266,6 +267,8 @@ pte_t huge_ptep_get_and_clear(struct mm_struct
*mm, unsigned long addr,
        if (pte_present(entry))
                mm->context.huge_pte_count--;

+       addr &= HPAGE_MASK;
+
        for (i = 0; i < (1 << HUGETLB_PAGE_ORDER); i++) {
                pte_clear(mm, addr, ptep);
                addr += PAGE_SIZE;
