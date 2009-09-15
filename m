Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZIOW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZIOW3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZIOW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:29:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZIOW3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:29:14 -0400
Date: Tue, 15 Sep 2009 15:25:11 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hans de Goede <hdegoede@redhat.com>
Subject: Re: 2.6.31rc5 RAID10 lockdep report - sysfs_nofity_dirent locking
 issue
Message-ID: <20090915222511.GA13600@suse.de>
References: <20090804141425.GA2831@redhat.com>
 <58e2e493d0855face4e7d3fbf7ee65b9.squirrel@neil.brown.name>
 <20090804212404.GA26390@suse.de>
 <19066.28054.65288.171564@notabene.brown>
 <e9c3a7c20909151512y48d066a9m71d4bb92e34b5294@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9c3a7c20909151512y48d066a9m71d4bb92e34b5294@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 03:12:07PM -0700, Dan Williams wrote:
> On Wed, Aug 5, 2009 at 10:43 PM, Neil Brown <neilb@suse.de> wrote:
> > On Tuesday August 4, gregkh@suse.de wrote:
> >> >
> >> > Greg: does that look right?  If so I'll add a changelog entry and
> >> > submit it properly (after at least a compile test...)
> >>
> >> Yes, it looks correct, if it passes your tests :)
> >
> > Thanks.
> > I've tested it and documented it now and so am happy to submit it.
> > Thanks,
> > NeilBrown
> >
> >
> > From: NeilBrown <neilb@suse.de>
> > Date: Thu, 6 Aug 2009 15:42:08 +1000
> > Subject: [PATCH] Allow sysfs_notify_dirent to be called from interrupt context.
> >
> > sysfs_notify_dirent is a simple atomic operation that can be used to
> > alert user-space that new data can be read from a sysfs attribute.
> >
> > Unfortunately is cannot currently be called from non-process context
> > because of it's use of spin_lock which is sometimes taken with
> > interrupt enabled.
> >
> > So change all lockers of sysfs_open_dirent_lock to disable interrupts,
> > thus making sysfs_notify_dirent safe to be called from non-process
> > context (as drivers/md does in md_safemode_timeout).
> >
> > sysfs_get_open_dirent is (documented as being) only called from
> > process context, so it uses spin_lock_irq.  Other places
> > use spin_lock_irqsave.
> >
> > The usage for sysfs_notify_dirent in md_safemode_timeout was
> > introduced in 2.6.28, so this patch is suitable for that and more
> > recent kernels.
> >
> > Cc: stable@kernel.org
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> 
> Greg?
> 
> Looks like this never made it upstream, and now Hans is hitting this
> in his tests.

Ok, I don't have this in my queue, so someone needs to resubmit it and
tell me what kernel trees it should be applicable for.

thanks,

greg k-h
