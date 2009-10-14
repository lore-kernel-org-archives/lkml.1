Return-Path: <linux-kernel-owner+w=401wt.eu-S934961AbZJNQvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbZJNQvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934952AbZJNQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:51:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934548AbZJNQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:51:27 -0400
Date: Wed, 14 Oct 2009 09:49:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
cc: linux-mtd <linux-mtd@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6 4/5]: core: Add kernel message dumper to call on oopses
 and panics
In-Reply-To: <20091014154118.5c8cc998@marrow.netinsight.se>
Message-ID: <alpine.LFD.2.01.0910140943040.6146@localhost.localdomain>
References: <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se>
 <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se> <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> <20091012110954.67d7d8d8.akpm@linux-foundation.org> <20091012182346.GH17138@elte.hu> <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
 <20091014153458.05e31db6@marrow.netinsight.se> <20091014154118.5c8cc998@marrow.netinsight.se>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Simon Kagstrom wrote:
>
> ChangeLog:
> Review comments from Linus Torvalds and Anders Grafström:
>        * Rename structures and file names
>        * Remove setup callback and unify panic/oops callbacks and
>          instead add a reason parameter
>        * Use a regular spinlock and try it when dumping (fail
>          if held)
>        * Check if the dumper is already registered
>        * Various style fixes/cleanup

Ok, looks fine to me now. 

I do end up having one minor nit: let's change the calling convention of 
the dump function to either be:

	void (*dump)(void *priv, enum kmsg_dump_reason reason,
		const char *s1, unsigned long l1,
		const char *s2, unsigned long l2);

or let's just remove the 'priv' data from the dump entirely. 

Right now, you pass in the whole 'kmsg_dumper' data structure, and then 
you seem to expect that users look up their private context by looking 
into that data structure with 'dumper->priv'. That's just ugly. 

So if you want to have a callback value, just pass that in for the 
callback.

And if you want to pass in the whole 'kmsg_dumper' data structure, then 
use that pointer _itself_ as the context (ie you would embed the 
'kmsg_dumper' in some data structure, and then you do

	struct my_data *my_data = container_of(dumper, struct my_data, dumper);

or something like that.

But your current implementation mixes _both_ of the above approaches. 
Which one are people going to use? Both work, and no, "there are multiple 
ways to do the same thing" is not an advantage, it just leads to 
confusion. And confusion isn't good, whatever the perl people say.

		Linus
