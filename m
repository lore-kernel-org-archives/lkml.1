Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYKCWTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYKCWTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYKCWTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:19:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbYKCWTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:19:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] hibernation should work ok with memory hotplug
Date: Mon, 3 Nov 2008 23:24:01 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, linux-pm@lists.osdl.org,
       Matt Tolentino <matthew.e.tolentino@intel.com>,
       Dave Hansen <haveblue@us.ibm.com>, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>, Andy Whitcroft <apw@shadowen.org>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz> <20081103125108.46d0639e.akpm@linux-foundation.org> <1225747308.12673.486.camel@nimitz>
In-Reply-To: <1225747308.12673.486.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811032324.02163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of November 2008, Dave Hansen wrote:
> On Mon, 2008-11-03 at 12:51 -0800, Andrew Morton wrote:
> > On Wed, 29 Oct 2008 13:25:00 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > On Wednesday, 29 of October 2008, Pavel Machek wrote:
> > > > 
> > > > hibernation + memory hotplug was disabled in kconfig because we could
> > > > not handle hibernation + sparse mem at some point. It seems to work
> > > > now, so I guess we can enable it.
> > > 
> > > OK, if "it seems to work now" means that it has been tested and confirmed to
> > > work, no objection from me.
> > 
> > yes, that was not a terribly confidence-inspiring commit message.
> > 
> > 3947be1969a9ce455ec30f60ef51efb10e4323d1 said "For now, disable memory
> > hotplug when swsusp is enabled.  There's a lot of churn there right
> > now.  We'll fix it up properly once it calms down." which is also
> > rather rubbery.  
> > 
> > Cough up, guys: what was the issue with memory hotplug and swsusp, and
> > is it indeed now fixed?
> 
> I suck.  That commit message was horrid and I'm racking my brain now to
> remember what I meant.  Don't end up like me, kids.
> 
> I've attached the message that I sent to the swsusp folks.  I never got
> a reply from that as far as I can tell.
> 
> http://sourceforge.net/mailarchive/forum.php?thread_name=1118682535.22631.22.camel%40localhost&forum_name=lhms-devel
> 
> As I look at it now, it hasn't improved much since 2005.  Take a look at
> kernel/power/snapshot.c::copy_data_pages().  It still assumes that the
> list of zones that a system has is static.  Memory hotplug needs to be
> excluded while that operation is going on.

This operation is carried out on one CPU with interrupts disabled.  Is that
not enough?

> page_is_saveable() checks for pfn_valid().  But, with memory hotplug,
> things can become invalid at any time since no references are held or
> taken on the page.  Or, a page that *was* invalid may become valid and
> get missed.

Can that really happen given the conditions above?

> The "missing a page" thing is probably correctable via the
> zone_span_seqbegin() locks.  The "page becoming invalid" thing is
> probably mostly fixable by acquiring a reference to the page itself.
> I'd need to look how the locking on the hot remove side is working these
> days to be much more constructive than that.

Well, I don't think any locking is necessary for the image creation.

Thanks,
Rafael
