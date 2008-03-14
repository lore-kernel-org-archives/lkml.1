Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYCNCAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYCNCAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYCNCAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:00:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:31509 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYCNCAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=por8TkEnVcwb0QirjbkK6mZp1rgZ6CEZnG5PGKmd9tS6I8/Gh8RKbbZI7njIVmI2rDhjbxHxoW6t8JBG1eS8QfEsthgQJhrCxVY493e02YAbsbZAZiOSD4MH96az1QCi4oa0k9JQU2KHmLvB3hpbONxeMIFCEr00OfI6XO/pNCQ=
Message-ID: <86802c440803131900j30ef490bk1923fdd219433535@mail.gmail.com>
Date: Thu, 13 Mar 2008 19:00:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, "Yasunori Goto" <y-goto@jp.fujitsu.com>
In-Reply-To: <20080314105529.79921546.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	 <20080314103431.ff07070c.kamezawa.hiroyu@jp.fujitsu.com>
	 <86802c440803131835u4e506d69l4f116eb49d9ee9b2@mail.gmail.com>
	 <20080314105529.79921546.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 6:55 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 13 Mar 2008 18:35:51 -0700
>
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Thu, Mar 13, 2008 at 6:34 PM, KAMEZAWA Hiroyuki
>  > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  > > On Thu, 13 Mar 2008 16:45:42 -0700
>  > >  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>  > >  > int __init reserve_bootmem(unsigned long addr, unsigned long size,
>  > >  >                           int flags)
>  > >  >  {
>  > >  > -     return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
>  > >  > +     int ret;
>  > >  > +     bootmem_data_t *bdata;
>  > >  > +     list_for_each_entry(bdata, &bdata_list, list) {
>  > >  > +             ret = can_reserve_bootmem_core(bdata, addr, size, flags);
>  > >  > +             if (ret < 0)
>  > >  > +                     return ret;
>  > >  > +     }
>  > >  > +     list_for_each_entry(bdata, &bdata_list, list)
>  > >  > +             reserve_bootmem_core(bdata, addr, size, flags);
>  > >  > +     return 0;
>  > >  >  }
>  > >
>  > >  why list_for_each twice ?
>  >
>  > first_for_each only check if we can reserve that.
>  > second will do the reserve job.
>  >
>  Hmm, can a call to reserve_bootmem() return a memory region which spread across
>  prural nodes ?

Yes. there is one reserve_bootmem in reserve_crashkernel. and position
is passed via commandline...
there is some chance for ramdisk too. it is called via reserve_bootmem_generic.

YH
