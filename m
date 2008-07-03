Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbYGCMst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbYGCMst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbYGCMs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:48:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbYGCMs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:48:27 -0400
Date: Thu, 3 Jul 2008 13:47:10 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       dm-devel@redhat.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       mtk.manpages@googlemail.com, axboe@kernel.dk
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080703124709.GI22522@agk.fab.redhat.com>
Mail-Followup-To: Takashi Sato <t-sato@yk.jp.nec.com>,
	Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	dm-devel@redhat.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
	mtk.manpages@googlemail.com, axboe@kernel.dk
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080701105251.GC22522@agk.fab.redhat.com> <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 09:11:05PM +0900, Takashi Sato wrote:
> If the freezer accesses the frozen filesystem and causes a deadlock,
> the above ideas can't solve it

But you could also say that if the 'freezer' process accesses the frozen
filesystem and deadlocks then that's just a bug and that userspace code
should be fixed and there's no need to introduce the complexity of a
timeout parameter.

> >Similarly if a device-mapper device is involved, how should the following
> >sequence behave - A, B or C?
> >
> >1. dmsetup suspend (freezes)
> >2. FIFREEZE
> >3. FITHAW
> >4. dmsetup resume (thaws)
> [...]
> >C:
> > 1 succeeds, freezes
> > 2 fails, remains frozen
> > 3 fails (because device-mapper owns the freeze/thaw), remains frozen
> > 4 succeeds, thaws
> 
> I think C is appropriate and the following change makes it possible.
> How do you think?
 
The point I'm trying to make here is:
  Under what real-world circumstances might multiple concurrent freezing
  attempts occur, and which of A, B or C (or other variations) would be
  the most appropriate way of handling such situations?

A common example is people running xfs_freeze followed by an lvm command
which also attempts to freeze the filesystem.

I can see a case for B or C, but personally I prefer A:

> > 1 succeeds, freezes
> > 2 succeeds, remains frozen
> > 3 succeeds, remains frozen
> > 4 succeeds, thaws

Alasdair
-- 
agk@redhat.com
