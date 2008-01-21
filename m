Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYAUVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYAUVoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYAUVoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:44:04 -0500
Received: from waste.org ([66.93.16.53]:47660 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYAUVoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:44:02 -0500
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
From: Matt Mackall <mpm@selenic.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <47912F02.6070801@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
	 <1200681668.25782.9.camel@cinder.waste.org>  <47912F02.6070801@gmail.com>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 15:42:37 -0600
Message-Id: <1200951757.3860.24.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 07:58 +0900, Tejun Heo wrote:
> Matt Mackall wrote:
> > On Wed, 2008-01-16 at 10:00 +0900, Tejun Heo wrote:
> >> And mprintk the following.
> >>
> >>  code:
> >>   DEFINE_MPRINTK(mp, 2 * 80);
> >>
> >>   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
> >>   mprintk_push(&mp, "ATA %d", 7);
> >>   mprintk_push(&mp, ", %u sectors\n", 1024);
> >>   mprintk(&mp, "everything seems dandy\n");
> > 
> > I prefer Matthew Wilcox's stringbuf approach which does proper memory
> > management and isn't specific to printk:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0710.3/0517.html
> 
> Yeap, that's generic and nice but I think both 'generic' and 'proper
> memory management' are weakness if what you're trying to do is to
> support collecting messages in pieces and putting it out via printk.
> Please consider the following scenario.
> 
> You're in an interrupt handler and detected a severe error condition
> which should be notified to the user but the information is rather
> complex and best built in pieces, so you create a stringbuf and does
> sb_printf() to it w/ GFP_ATOMIC but alas memory allocation failed and
> you end up printing "out of memory" unless you detect the failure and go
> back and printk messages piece-by-piece manually.  I would rather
> assemble the message manually from the get-go into an on-stack buffer.

I suppose. I still find this approach less than ideal, especially
putting something potentially large on the stack. The dangers are
perhaps worse than a malloc, really. 

I also don't like your interface much. Consider this alternative:

struct mprintk *mp = mprintk_begin(KERN_INFO "ata%u.%2u: ", 1, 0);
mprintk(mp, "ATA %d", 7);
mprintk(mp, ", %u sectors\n", 1024);
mprintk(mp, "everything seems dandy\n");
mprintk_end(mp);

That keeps all the "normal" printks short and makes the flush more
explict.

Now we make mprintk_begin attempt to do a kmalloc of a moderate size
(512 bytes?) and failing that, return null. Then mprintk can fall
through to printk in the NULL case.

-- 
Mathematics is the supreme nostalgia of our time.

