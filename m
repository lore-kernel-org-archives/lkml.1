Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZBCMH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZBCMH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZBCMHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:07:36 -0500
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:40178 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754209AbZBCMHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:07:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cch+07tgY47JTH55CuU31XezdH011+htv2P3PYOBYqMtzMwTQJsPjxSmmC+1jrTTdo7RXY5hjwK/fkjPaBE/mgNlHS3A4E4Lz6DnvmQXwKXfmGJJuYS7HTSp6kfK/LuKXCIJZ8j/IBmYQZiUL7fJirSJSGticNLoJXZwjU7DqZQ=  ;
X-YMail-OSG: CczI4WwVM1klYzhW0i1WqGX_80r30xBDSnYA5kJeYhn_zWy1Gie34pxmfY7w.oGr1mVaQMI5IN6YNr9boKWXvSzpTpCPrJUwPiASubp3ZzZST1GYtVCA1X4I8u3GuVAEKB_5Hkd52GbCUZh_E03BfGA4il3ea9ab7m9fhl98uaA.jGLtkHxSwVZgC3Q_LQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch] SLQB slab allocator (try 2)
Date: Tue, 3 Feb 2009 23:07:07 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20090123154653.GA14517@wotan.suse.de> <200902032250.55968.nickpiggin@yahoo.com.au> <20090203120139.GM9840@csn.ul.ie>
In-Reply-To: <20090203120139.GM9840@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032307.09025.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 23:01:39 Mel Gorman wrote:
> On Tue, Feb 03, 2009 at 10:50:54PM +1100, Nick Piggin wrote:
> > On Tuesday 03 February 2009 22:28:52 Mel Gorman wrote:
> > > On Tue, Feb 03, 2009 at 09:36:24PM +1100, Nick Piggin wrote:
> > > > I'd be interested to see how slub performs if booted with
> > > > slub_min_objects=1 (which should give similar order pages to SLAB and
> > > > SLQB).
> > >
> > > Just to clarify on this last point, do you mean slub_max_order=0 to
> > > force order-0 allocations in SLUB?
> >
> > Hmm... I think slub_min_objects=1 should also do basically the same.
> > Actually slub_min_object=1 and slub_max_order=1 should get closest I
> > think.
>
> I'm going with slub_min_objects=1 and slub_max_order=0. A quick glance
> of the source shows the calculation as
>
>         for (order = max(min_order,
>                                 fls(min_objects * size - 1) - PAGE_SHIFT);
>                         order <= max_order; order++) {
>
> so the max_order is inclusive not exclusive. This will force the order-0
> allocations I think you are looking for.

Well, but in the case of really bad internal fragmentation in the page,
SLAB will do order-1 allocations even if it doesn't strictly need to.
Probably this isn't a huge deal, but I think if we do slub_min_objects=1,
then SLUB won't care about number of objects per page, and slub_max_order=1
will mean it stops caring about fragmentation after order-1. I think. Which
would be pretty close to SLAB (depending on exactly how much fragmentation
it cares about).

