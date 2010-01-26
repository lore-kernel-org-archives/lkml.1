Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040Ab0AZHwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0AZHwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777Ab0AZHwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:52:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:49684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0AZHwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:52:44 -0500
Subject: Re: futex() on vdso makes process unkillable
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Mark Seaborn <mrs@mythic-beasts.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20100126113312.5AA3.A69D9226@jp.fujitsu.com>
References: <1264411574.4283.1632.camel@laptop>
	 <4B5DD6DF.4090102@us.ibm.com> <20100126113312.5AA3.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 08:52:25 +0100
Message-ID: <1264492345.4283.1945.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 11:41 +0900, KOSAKI Motohiro wrote:
> > Peter Zijlstra wrote:
> > > On Mon, 2010-01-25 at 16:27 +0900, KOSAKI Motohiro wrote:
> > <snip>
> > >> Futex should work both file anon anon. however I personally think 
> > >> vdso is not file nor anon. it is special mappings. nobody defined
> > >> futex spec on special mappings. (yes, undefined).
> > >>
> > >> Personally, I think EINVAL or EFAULT are best result of vdso futexing, like as
> > >> futexing againt kernel address. but I guess another person have another thinking.
> > >>
> > >> I'd like to hear futex folks's opinion.
> > > 
> > > Well, my opinion is we should remove the vdso, its ugly as hell :-)
> > > 
> > > But I think it would make most sense to extend its definition in the
> > > direction of it being a file (for all intents and purposes its a special
> > > DSO -- which unfortunately isn't present in any filesystem).
> > > 
> > > [ For all intents and purposes processes can already communicate through
> > > futexes on the libc space, so being able to do so through the vsdo
> > > really doesn't add anything ]
> > > 
> > > So the problem is that the VDSO pages do not have a page->mapping
> > > because they lack the actual filesystem part of files, so even if (with
> > > the recent zero-page patch from Kosaki-san) you make private COWs of the
> > > VDSO, you'll get stuck in that loop.
> > > 
> > > So the prettiest solution is to simply place the vdso in an actual
> > > filesystem and slowly migrate towards letting userspace map it as a
> > > regular DSO -- /sys/lib{32,64}/libkernel.so like.
> > > 
> > > [ that has the bonus of getting rid of install_special_mapping() ]
> > > 
> > > The ugly solution is special casing the vdso in get_futex_key().
> > 
> > I like the creating-a-real-file solution. However, for now (and for 
> > stable), I think Kosaki's suggestion of EINVAL or EFAULT is a good 
> > stop-gap. EINVAL might play the best with existing glibc implementations.
> 
> May I confirm your mention?
> 
> If we can accept EFAULT, we don't need any change. my previous futex patch
> already did. because 1) VDSO is alwasys read-only mapped 2) write mode
> get_user_pages_fast() against read-only pte/vma return EFAULT.
> 
> Current linus and stable tree don't cause Mark's original problem. instead, just
> return EFAULT. (Well, I'm sorry. my previous mail was unclear. I wrote v2.6.31 test
> result)
> 
> If you can't accept EFAULT, we need to add vdso specific logic into get_futex_key().
> Is this your intention?

Oh, right you are, I mixed up the force and write arguments. Yes I tihnk
we're good.


