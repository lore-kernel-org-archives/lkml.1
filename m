Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXJHXe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXJHXe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXJHXeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:34:17 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:25914 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750875AbXJHXeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:34:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=F45cMbt0Uh9Vl1hfh6CbtHUXNz4CIODspgpX+9ZGqjj48MW0+oryxLhLpR922bghMlvLVWNC3MdpU5yHfJyTP1BiF9j8PSD9DHeDVrpKC4AYRwwSFzrSoceYtR5CX3XNzpgUIO5tcwZA1z+VcdSoH1pIXQGlvP/2tWCP+15fOp0=  ;
X-YMail-OSG: qgiRBA0VM1nKbt0Bs3A.1fEgJYYvDZpDYaWLSIG37Q9HXjsrvi_UD_x.j4FM0Ull7zWUeVftNg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
Date: Mon, 8 Oct 2007 17:02:28 +1000
User-Agent: KMail/1.9.5
Cc: "Yan Zheng" <yanzheng@21cn.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com> <20071008100456.dbe826d0.akpm@linux-foundation.org>
In-Reply-To: <20071008100456.dbe826d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081702.28516.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 03:04, Andrew Morton wrote:
> On Mon, 8 Oct 2007 19:45:08 +0800 "Yan Zheng" <yanzheng@21cn.com> wrote:
> > Hi all
> >
> > The test for VM_CAN_NONLINEAR always fails
> >
> > Signed-off-by: Yan Zheng<yanzheng@21cn.com>
> > ----
> > diff -ur linux-2.6.23-rc9/mm/fremap.c linux/mm/fremap.c
> > --- linux-2.6.23-rc9/mm/fremap.c	2007-10-07 15:03:33.000000000 +0800
> > +++ linux/mm/fremap.c	2007-10-08 19:33:44.000000000 +0800
> > @@ -160,7 +160,7 @@
> >  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
> >  		goto out;
> >
> > -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> > +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
> >  		goto out;
> >
> >  	if (end <= start || start < vma->vm_start || end > vma->vm_end)
>
> Lovely.  From this we can deduce that nobody has run remap_file_pages()
> since 2.6.23-rc1 and that nobody (including the developer who made that
> change) ran it while that change was in -mm.

But you'd be wrong. remap_file_pages was tested both with my own tester
and Ingo's test program.

vm_flags != 0, !vm_flags = 0, 0 & x = 0, so the test always falls
through. Of course, what I _should_ have done is also test a driver which
does not have VM_CAN_NONLINEAR... but even I wouldn't rewrite half
the nonlinear mapping code without once testing it ;)

FWIW, Oracle (maybe the sole real user of this) has been testing it, which
I'm very happy about (rather than testing after 2.6.23 is released).
