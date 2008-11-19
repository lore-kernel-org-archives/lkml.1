Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYKSJmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYKSJmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYKSJmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:42:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57644
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbYKSJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:42:22 -0500
Date: Wed, 19 Nov 2008 01:42:22 -0800 (PST)
Message-Id: <20081119.014222.193698982.davem@davemloft.net>
To: mingo@elte.hu
Cc: jarkao2@gmail.com, jeff@garzik.org, johannes@sipsolutions.net,
       wferi@niif.hu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: Disable softirqs in write_msg()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081119093004.GD22309@elte.hu>
References: <87y6zwwy5c.fsf@tac.ki.iif.hu>
	<20081119084106.GA6699@ff.dom.local>
	<20081119093004.GD22309@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 19 Nov 2008 10:30:04 +0100

> * Jarek Poplawski <jarkao2@gmail.com> wrote:
> 
> > diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> > index d304d38..f6ecad8 100644
> > --- a/drivers/net/netconsole.c
> > +++ b/drivers/net/netconsole.c
> > @@ -702,6 +702,8 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
> >  	if (list_empty(&target_list))
> >  		return;
> >  
> > +	/* Avoid enabling softirqs with hardirqs disabled */
> > +	local_bh_disable();
> >  	spin_lock_irqsave(&target_list_lock, flags);
> >  	list_for_each_entry(nt, &target_list, list) {
> >  		netconsole_target_get(nt);
> > @@ -723,6 +725,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
> >  		netconsole_target_put(nt);
> >  	}
> >  	spin_unlock_irqrestore(&target_list_lock, flags);
> > +	local_bh_enable();
> 
> but netconsole can be triggered from printk - and printk can be called 
> from hardirqs-off sections - so this doesnt really fix the bug. 
> Netconsole should not do BH processing.

Well, it sort of "has to".  It calls the NAPI ->poll() method of the
driver to try and make forward progress with TX reclaim so it can
send new messages.

It is very careful not to recursively invoke into ->poll() and other
nasty situations.

Didn't you write some of this code Ingo a very long time ago? :-)))

Anyways, I'll look more closely at this and the original report,
this never was a problem before.
