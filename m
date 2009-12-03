Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZLCLpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZLCLpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZLCLpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:45:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42496 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbZLCLpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:45:45 -0500
Date: Thu, 3 Dec 2009 11:46:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] pps: serial clients support.
Message-ID: <20091203114641.391e4014@lxorguk.ukuu.org.uk>
In-Reply-To: <20091203105347.GB12943@gundam.enneenne.com>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
	<1259774329-29663-2-git-send-email-giometti@linux.it>
	<1259774329-29663-3-git-send-email-giometti@linux.it>
	<1259774329-29663-4-git-send-email-giometti@linux.it>
	<1259774329-29663-5-git-send-email-giometti@linux.it>
	<1259774329-29663-6-git-send-email-giometti@linux.it>
	<1259774329-29663-7-git-send-email-giometti@linux.it>
	<20091202185903.66e6709e@lxorguk.ukuu.org.uk>
	<20091203105347.GB12943@gundam.enneenne.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think putting the pps ldisc (which is basically n_tty and a bit) into
> > n_tty is probably the right choice given how small and clean it is - what
> > do you think ?
> 
> I think it could be ok, but in this case where should I register
> pps-ldisc? Into tty_ldisc_begin just after tty_ldisc_N_TTY?

Yes.

> Again, should I remove the possibility to compile pps-ldisc as module?

It would do that yes. I hadn't considered that aspect of it - and that in
turn would force you to compile the core PPS support in to get pps-ldisc.

How about this then (I'm trying to see a way to avoid all thsoe exports
of functions)

/**
 *	n_tty_inherit_ops		-	initialise ldisc ops
 *	@ops: ops to initialise
 *
 *	Allow a line discipline to inherit the basic operations
 *	from the n_tty line discipline. The caller must set up
 *	its own ldisc number, flags and name. It must use the
 *	inherited value of magic.
 */

void n_tty_init_ops(struct tty_ldisc_ops *ops)
{
	*ops = tty_ldisc_N_TTY;
	ops->owner = NULL:
	ops->refcount = ops->flags = 0;
}
EXPORT_SYMBOL_GPL(n_tty_inherit_ops);

