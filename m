Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZGAFnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZGAFnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZGAFnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:43:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZGAFnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:43:39 -0400
Date: Wed, 1 Jul 2009 07:40:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [rfc] do not place sub-threads on task_struct->children list
Message-ID: <20090701054016.GA26877@redhat.com>
References: <20090624152143.GB23848@redhat.com> <20090624185701.AA74C4059B@magilla.sf.frob.com> <20090624161111.GA27890@redhat.com> <20090624194239.A29174059B@magilla.sf.frob.com> <20090624171357.GA30435@redhat.com> <20090624205112.3EA944059B@magilla.sf.frob.com> <93ad5f3f0906252111n48742b9ax8dc2ad35b30f4292@mail.gmail.com> <20090629033852.GA14404@redhat.com> <20090629230841.GA13024@redhat.com> <20090630193037.6CCE01C4@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630193037.6CCE01C4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Roland McGrath wrote:
>
> > Currently we add sub-threads to ->real_parent->children list. This
> > buys nothing but slows down do_wait().
> >
> > With this patch ->children contains only main threads (group leaders).
> > The only complication is that forget_original_parent() should iterate
> > over sub-threads by hand.
>
> This seems right to me, though I'll admit I haven't really walked through
> all the exit/reparent paths afresh with this in mind.
>
> Note that this naturally suggests moving ->sibling to signal_struct.  (Of
> course that can come later.)  The abuse of sibling in reparent_leader adds
> a wrinkle to that, but off hand it looks like it could do the same with it
> living in signal_struct with a bit of contortion.

Yes, this change was suggested a long ago.

But in that case forget_original_parent() still has to iterate over all childs
to send ->pdeath_signal and change ->real_parent when we reparent to sub-thread.

> Oh, and what about the de_thread() leader-replacement case?

Ah, good point!

de_thread() should do list_replace_init().

Oleg.

