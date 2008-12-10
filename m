Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYLJBOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYLJBOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYLJBOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:14:42 -0500
Received: from mx02.qsc.de ([213.148.130.14]:60793 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbYLJBOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:14:41 -0500
X-Greylist: delayed 1589 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 20:14:41 EST
Date: Wed, 10 Dec 2008 01:48:10 +0100
From: Andreas Bombe <aeb@debian.org>
To: Joerg Dorchain <joerg@dorchain.net>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiflop: get rid of sleep_on calls
Message-ID: <20081210004810.GA5073@infernal.debian.net>
Mail-Followup-To: Joerg Dorchain <joerg@dorchain.net>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1228755578-26069-1-git-send-email-aeb@debian.org> <20081209082608.GA10651@Redstar.dorchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209082608.GA10651@Redstar.dorchain.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 09:26:08AM +0100, Joerg Dorchain wrote:
> On Mon, Dec 08, 2008 at 04:59:38PM +0000, Andreas Bombe wrote:
> > The replacement for the unconditional sleep_on() in fd_motor_on() is a
> > complete_all() together with a INIT_COMPLETION() before the mod_timer()
> > call.  It appears to me that fd_motor_on() might be called concurrently
> > and fd_select() does not guarantee mutual exclusivity in the case the
> > same drive gets selected again.
> 
> Selecting the same drive repeatly does not matter. The selected
> drive is the one the next command or transfer applies to.

I think we're not talking about the same problem.  If I were to use
complete() together with wait_for_completion() there would be a problem
if fd_motor_on() can get as far as wait_for_completion() while a
previous completion is yet uncompleted.  This can not happen for
different drives, as the fd_select() would block.  If it could happen
for the same drive, the complete() would allow only one task to
continue.  The complete_all() takes care of that.

If requests are serialized for a drive so that there won't ever be two
running at the same time for certain (thinking about it, it's probable),
I could make it a simple complete().  It's hardly worth the risk,
however.
