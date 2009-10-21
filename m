Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZJUTQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZJUTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZJUTQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:16:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbZJUTQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:16:57 -0400
Date: Wed, 21 Oct 2009 21:16:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: XFS stack overhead
Message-ID: <20091021191648.GA12259@elte.hu>
References: <20091015183540.GA8098@redhat.com> <20091015190720.GA19467@elte.hu> <4ADF2DAA.9030604@redhat.com> <20091021110053.26ab9982@infradead.org> <4ADF59F8.7010205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADF59F8.7010205@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Sandeen <sandeen@redhat.com> wrote:

> Arjan van de Ven wrote:
> > On Wed, 21 Oct 2009 10:50:02 -0500
> > Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> (Cc:-ed Arjan too.)
> >>>
> >>> * Dave Jones <davej@redhat.com> wrote:
> >>>
> >>>> 113c5413cf9051cc50b88befdc42e3402bb92115 introduced a change that
> >>>> made CC_STACKPROTECTOR_ALL not-selectable if someone enables 
> >>>> CC_STACKPROTECTOR.
> >>>>
> >>>> We've noticed in Fedora that this has introduced noticable
> >>>> overhead on some functions, including those which don't even have
> >>>> any on-stack variables.
> >>>>
> >>>> According to the gcc manpage, -fstack-protector will protect
> >>>> functions with as little as 8 bytes of stack usage. So we're
> >>>> introducing a huge amount of overhead, to close a small amount of
> >>>> vulnerability (the >0 && <8 case).
> >>>>
> >>>> The overhead as it stands right now means this whole option is 
> >>>> unusable for a distro kernel without reverting the above commit.
> >>> Exactly what workload showed overhead, and how much?
> >>>
> >>> 	Ingo
> >> I had xfs blowing up pretty nicely; granted, xfs is not svelte but it
> >> was never this bad before.
> >>
> > 
> > do you have any indication that SP actually increases the stack
> > footprint by that much? it's only a few bytes....
> > 
> > 
> 
> Here's a sample of some of the largest xfs stack users,
> and the effect stack-protector had on them.  This was just
> done with objdump -d xfs.ko | scripts/checkstack.pl; I don't
> know if there's extra runtime stack overhead w/ stackprotector?
> 
> -Eric
> 
> function                  nostack stackprot delta delta %
> xfs_bmapi                      376      408    32  9%
> xfs_bulkstat                   328      344    16  5%
> _xfs_trans_commit              296      312    16  5%
> xfs_iomap_write_delay          264      280    16  6%
> xfs_file_ioctl                 248      312    64 26%
> xfs_symlink                    248      264    16  6%
> xfs_bunmapi                    232      280    48 21%
> xlog_do_recovery_pass          232      248    16  7%
> xfs_trans_unreserve_and_mod_sb 224      240    16  7%
> xfs_bmap_del_extent            216      248    32 15%
> xfs_cluster_write              216      232    16  7%
> xfs_file_compat_ioctl          216      296    80 37%
> xfs_attr_set_int               200      216    16  8%
> xfs_bmap_add_extent_delay_real 200      248    48 24%

Note that those are very large stack frames to begin with.

3496 bytes - that's a _lot_ - can anyone even run XFS with 4K stacks on? 

With stackprotector it's 3928 - a 12% increase - which certainly does 
not help - but the basic problem is the large stack footprint to begin 
with.

Also, the posting apparently mixes 'stack overhead' with 'runtime 
overhead'.

	Ingo
