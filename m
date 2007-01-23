Return-Path: <linux-kernel-owner+w=401wt.eu-S932630AbXAWCHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbXAWCHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXAWCHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:07:16 -0500
Received: from mail.suse.de ([195.135.220.2]:40435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbXAWCHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:07:14 -0500
From: Neil Brown <neilb@suse.de>
To: "Dan Williams" <dan.j.williams@gmail.com>
Date: Tue, 23 Jan 2007 13:06:40 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17845.28080.887134.987438@notabene.brown>
Cc: "Chuck Ebbert" <cebbert@redhat.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: message from Dan Williams on Monday January 22
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	<45B5261B.1050104@redhat.com>
	<17845.13256.284461.992275@notabene.brown>
	<e9c3a7c20701221744i7f0de470r4c8183dd3bcd20b5@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday January 22, dan.j.williams@gmail.com wrote:
> On 1/22/07, Neil Brown <neilb@suse.de> wrote:
> > On Monday January 22, cebbert@redhat.com wrote:
> > > Justin Piszcz wrote:
> > > > My .config is attached, please let me know if any other information is
> > > > needed and please CC (lkml) as I am not on the list, thanks!
> > > >
> > > > Running Kernel 2.6.19.2 on a MD RAID5 volume.  Copying files over Samba to
> > > > the RAID5 running XFS.
> > > >
> > > > Any idea what happened here?
> > ....
> > > >
> > > Without digging too deeply, I'd say you've hit the same bug Sami Farin
> > > and others
> > > have reported starting with 2.6.19: pages mapped with kmap_atomic()
> > > become unmapped
> > > during memcpy() or similar operations.  Try disabling preempt -- that
> > > seems to be the
> > > common factor.
> >
> > That is exactly the conclusion I had just come to (a kmap_atomic page
> > must be being unmapped during memcpy).  I wasn't aware that others had
> > reported it - thanks for that.
> >
> > Turning off CONFIG_PREEMPT certainly seems like a good idea.
> >
> Coming from an ARM background I am not yet versed in the inner
> workings of kmap_atomic, but if you have time for a question I am
> curious as to why spin_lock(&sh->lock)  is not sufficient pre-emption
> protection for copy_data() in this case?
> 

Presumably there is a bug somewhere.
kmap_atomic itself calls inc_preempt_count so that preemption should
be disabled at least until the kunmap_atomic is called.

But apparently not.  The symptoms point exactly to the page getting
unmapped when it shouldn't.  Until that bug is found and fixed, the
work around of turning of CONFIG_PREEMPT seems to make sense.

Of course it would be great if someone who can easily reproduce this
bug could do the 'git bisect' thing to find out where the bug crept
in.....

NeilBrown
