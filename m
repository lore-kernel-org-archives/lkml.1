Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXFSOmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXFSOmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXFSOmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:42:33 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:32786 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbXFSOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:42:33 -0400
Date: Tue, 19 Jun 2007 16:42:31 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Behdad Esfahbod <behdad@behdad.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070619144230.GA14609@uhulinux.hu>
References: <8aT6Q-3iM-17@gated-at.bofh.it> <8xLa7-25v-5@gated-at.bofh.it> <E1I0eAW-0000nC-5a@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1I0eAW-0000nC-5a@be1.lrz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:54:52PM +0200, Bodo Eggert wrote:

> Does the FLUSH DTRT by design, or does it just shrink and hide the original
> race?

I haven't deeply studied this aspect of the source, don't know what
_exactly_ this FLUSH does, but of course I have an inner feeling about this.
Kind of this macro does the _real_ print on the screen. It actually calls
vc->vc_sw->con_putcs, whereas I guess vc_sw refers to the particular
implementation (vga, fb) and con_putcs might be doing the real job.

Without these two new FLUSHes the behavior was very funny: applications
(e.g. text editors) highlighed incorrect cells, but either switching between
VTs, or gpming over these cells corrected the display. So the logical
content behind the scenes (reflected by /dev/vcsa*) was maintained
correctly, the bug is somewhere when the content is first displayed.

I saw that this FLUSH was already used 3 times inside do_con_write(), I
placed it here 2 more times (when changing color attr to inverse and when
reverting to normal). I think it cannot hurt, and apparently it fixes the
problem.

But you may be right: yes, it might be a bug (or misfeature) in the FB code,
too. Could you please look after it? I don't think I'd be able to do it and
have time for this.

> And why wasn't VGA affected, too?

I guess tt must be some difference between the actual VGA and FB code that
is called from here. I don't know whether it's a bug in FB or just some
difference.

Perhaps it's that the FB driver's con_putcs() call uses vc->vc_attr (the
current attr for the console) for each char cell to be printed, instead of
the own attr values of the cells themselves. Just an idea...



-- 
Egmont
