Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbYEUSir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbYEUSir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYEUSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:38:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbYEUSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:38:39 -0400
Date: Wed, 21 May 2008 11:38:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA over Ethernet: Convert emsgs_sema in a completion
Message-Id: <20080521113830.8eaa4ce1.akpm@linux-foundation.org>
In-Reply-To: <20080521144924.GD22566@coraid.com>
References: <20080516191133.GI24569@traven>
	<20080519165122.9d94cc1c.akpm@linux-foundation.org>
	<20080521144924.GD22566@coraid.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 10:49:24 -0400 "Ed L. Cashin" <ecashin@coraid.com> wrote:

> On Mon, May 19, 2008 at 04:51:22PM -0700, Andrew Morton wrote:
> > On Fri, 16 May 2008 21:11:33 +0200
> > Matthias Kaehlcke <matthias@kaehlcke.net> wrote:
> > 
> > > @@ -216,7 +217,7 @@ aoechr_read(struct file *filp, char __user *buf, size_t cnt, loff_t *off)
> > >  
> > >  		spin_unlock_irqrestore(&emsgs_lock, flags);
> > >  
> > > -		n = down_interruptible(&emsgs_sema);
> > > +		n = wait_for_completion_interruptible(&emsgs_comp);
> > 
> > Patch looks OK, but I worry about this code.  Suppose a signal is sent
> > and we return to userspace with the complete() still outstanding.  Then
> > someone removes the module.  
> > 
> > Perhaps there is synchronisation code which prevents that crash?
> 
> I plan to answer this question soon.  Right now I am quite busy.
> 
> This emsgs_sema part of the aoe driver has never caused any problems
> for users but has caused many problems for me, because it is tricky to
> think about, to talk about, and for others to patch.
> 
> I hope that there is a more straightforward way to get the current
> read-from-the-file-forever behavior using an existing kernel
> facility.  A user currently can do,
> 
>   cat /dev/etherd/err
> 
> ... and have it block, waiting until there is an error to report,
> printing it, and then blocking again, like reading from a pipe.

That's fine - the normal way of handling that is for the user's fd to
hold a reference against the module itself.
