Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXCTOPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXCTOPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXCTOPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:15:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:44147 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933235AbXCTOPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:15:00 -0400
Date: Tue, 20 Mar 2007 15:21:13 +0100
From: Jan Kara <jack@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: dquot.c: possible circular locking Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070320142113.GD14319@duck.suse.cz>
References: <20070315191749.GS31960@vanheusden.com> <20070320111701.GB1751@ff.dom.local> <20070320112253.GC1751@ff.dom.local> <20070320113151.GA12462@ff.dom.local> <20070320121909.GB14319@duck.suse.cz> <1174397710.1158.75.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174397710.1158.75.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-03-07 14:35:10, Arjan van de Ven wrote:
> 
> 
> >   Yes, I was looking at it. Hmm, we can possibly get rid of tty_mutex being
> > acquired under dqptr_sem in quota code. But looking at the path from
> > con_close() there's another inversion with i_mutex which is also acquired
> > along the path for sysfs. And we can hardly get rid of it in the quota code.
> >   Now none of these is a real deadlock as quota should never call
> > print_warning() for sysfs (it doesn't use quota) but still it's nasty. I
> > suppose tty_mutex is above i_mutex because of those sysfs calls and it
> > seems sysfs must be called under tty_mutex because of races with
> > init_dev(). So it's not easy to get rid of that dependency either.
> 
> maybe a far more serious option: Why on EARTH is the quota code going to
> TTY's directly? That's just WRONG. Maybe it wasn't 10 years ago, but
> nowadays most people use graphical user interfaces and the like...
  We've been discussing this sometimes back in August ;)
(http://lkml.org/lkml/2006/8/8/237) and we've decided to leave the code in.
The only reason why I think it should stay in is the existence of quota
softlimits. There it's nice to warn the user and there's no other way to
propagate this information into userspace (as the write succeeds).
  One solution would be to leave the warning to some userspace process
(like warnquota) run from cron but still I'm not sure we should change the
behavior.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
