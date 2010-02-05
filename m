Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab0BEONz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:13:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268Ab0BEONx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:13:53 -0500
Date: Fri, 5 Feb 2010 06:13:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-mmc@vger.kernel.org, Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] MMC: fix hang if card was removed during suspend and
 unsafe resume was enabled
Message-Id: <20100205061335.b664aa20.akpm@linux-foundation.org>
In-Reply-To: <1265358702.3424.8.camel@maxim-laptop>
References: <1265219241.12549.8.camel@maxim-laptop>
	<1265325495-4220-1-git-send-email-maximlevitsky@gmail.com>
	<20100204160957.1c51cc1b.akpm@linux-foundation.org>
	<1265358702.3424.8.camel@maxim-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Feb 2010 10:31:42 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Thu, 2010-02-04 at 16:09 -0800, Andrew Morton wrote: 
> > On Fri,  5 Feb 2010 01:18:15 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > Currently removal of the card leads to del_disk called indirectly by mmc core.
> > > This function expects userspace to be running, which isn't when .resume is called
> > > 
> > > Fix that by removing the code that did that in mmc_resume_host. It is possible
> > > because card detection logic will kick it later and remove the card.
> > 
> > I don't really understand.  The above implies that to trigger this bug,
> > one needs to physically remove the card during a resume operation.  ie:
> > a human-vs-computer race.  Sounds unlikely?
> > 
> > So...  exactly what steps does the user need to take to trigger this
> 
> Sorry for describing this poorly.
> The steps are:
> 
> -> Have a kernel with CONFIG_MMC_UNSAFE_RESUME
> -> Insert MMC/SD card
> -> Suspend/hibernate the system
> -> While system is hibernated/suspended pull the card off
> -> Resume the system
> -> Hang
> 
> 
> if CONFIG_MMC_UNSAFE_RESUME is set, mmc core allows the user to
> suspend/resume the card normally assuming he won't change the card or
> modify it in another system. The former case is actually handled quite
> well.
> 
> if CONFIG_MMC_UNSAFE_RESUME isn't set, it removes the card during
> suspend, and I now think (and will test) that this will still hang the
> system this time on suspend.
> 
> Maybe we can make del_disk behave well if called with userspace frozen?
> After all if user calls it, very likely that hardware is absent thus
> there is no point in syncing (which I think triggers the hang)....
> 

There is no del_disk in the kernel.  Let's be more specific (and
accurate!) about the hang.  I assume it's
mmc_remove_card->device_del->kobject_uevent?

Yes, I'd have thought that it would be a good idea for the
kobject_uevent code (or lower, in call_usermodehelper) to take avoiding
action if userspace is frozen.  However such action would probably
involve doing a WARN_ON() too, so we'd still need MMC changes to avoid
that.


