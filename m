Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbYAVBau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbYAVBau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYAVBal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:30:41 -0500
Received: from waste.org ([66.93.16.53]:48728 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbYAVBak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:30:40 -0500
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
From: Matt Mackall <mpm@selenic.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <47954047.90609@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
	 <1200681668.25782.9.camel@cinder.waste.org>  <47912F02.6070801@gmail.com>
	 <1200951757.3860.24.camel@cinder.waste.org>  <47954047.90609@gmail.com>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 19:28:11 -0600
Message-Id: <1200965291.3860.38.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 10:00 +0900, Tejun Heo wrote:
> Matt Mackall wrote:
> > I suppose. I still find this approach less than ideal, especially
> > putting something potentially large on the stack. The dangers are
> > perhaps worse than a malloc, really. 
> 
> I pondered on this a bit but the thing is we already use several
> hundreds bytes in a function which builds complex messages.

Well there are lots of current and potential future users of this
function, many of them down at the end of long call chains. So I'm more
worried about the new cases that embrace this approach and suddenly add
300 bytes of stack. In fact, if this is at all popular, we can expect to
have more than one of these frames on the stack in various paths. 

Given that it only exists to make output prettier, it doesn't -really-
justify increased stack usage.

> > I also don't like your interface much. Consider this alternative:
> > 
> > struct mprintk *mp = mprintk_begin(KERN_INFO "ata%u.%2u: ", 1, 0);
> > mprintk(mp, "ATA %d", 7);
> > mprintk(mp, ", %u sectors\n", 1024);
> > mprintk(mp, "everything seems dandy\n");
> > mprintk_end(mp);
> > 
> > That keeps all the "normal" printks short and makes the flush more
> > explict.
> 
> I like that the more used function is shorter.  Hmmm... The reason why I
> first used mprintk_push() is to make it clear that the function
> accumulates messages unlike mprintk() which flushes what's accumulated
> and prints its own message.
> 
> > Now we make mprintk_begin attempt to do a kmalloc of a moderate size
> > (512 bytes?) and failing that, return null. Then mprintk can fall
> > through to printk in the NULL case.
> 
> If you wanna do that implicitly, you need GFP_ flag in mprintk_begin()
> and atomic allocation should be used from interrupt handlers and friends
> and they fail easily under the right (or wrong) conditions.  Forcing
> kmalloc isn't a good idea.  Having multiple initializers is one way to
> do it.  Any suggestions?

Adding a gfp_flags arg isn't too painful. And we've generally avoided
having separate function calls for atomic vs non-atomic allocation.

Btw, we can also easily hide Willy or Rusty's stringbuf implementation
under the covers here and still have a scheme that automatically falls
back to direct printk..

-- 
Mathematics is the supreme nostalgia of our time.

