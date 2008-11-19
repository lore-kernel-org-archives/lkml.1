Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYKSTHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYKSTHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYKSTGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:06:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39382 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYKSTGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:06:39 -0500
Date: Wed, 19 Nov 2008 19:06:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: fix undeclared variables
Message-ID: <20081119190636.GW28946@ZenIV.linux.org.uk>
References: <20081118174250.GE3185@hack.voiplan.pt> <20081118192626.GU28946@ZenIV.linux.org.uk> <20081119184014.GD22898@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119184014.GD22898@hack.voiplan.pt>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 06:40:14PM +0000, Am??rico Wang wrote:
> On Tue, Nov 18, 2008 at 07:26:26PM +0000, Al Viro wrote:
> >On Tue, Nov 18, 2008 at 05:42:51PM +0000, Am??rico Wang wrote:
> >> 
> >> Fix three compile errors about undeclared variables in
> >> arch/um/kernel/mem.c.
> >
> >And what, pray tell, would initialize it?
> 
> Sorry, I can't fully understand you. I got the following error:
> 
> arch/um/kernel/mem.c: In function ???init_highmem???:
> arch/um/kernel/mem.c:177: error: ???pkmap_page_table??? undeclared (first
> use in this function)
> arch/um/kernel/mem.c:177: error: (Each undeclared identifier is
> reported only once
> arch/um/kernel/mem.c:177: error: for each function it appears in.)

The error is there, all right.  However, proposed patch only hides the
real problem.  Building uml/i386 with CONFIG_HIGHMEM will result in
a badly broken kernel with that patch, with no visible hints at the
cause of problems.

You've got it to link, but that's not enough.  The problems you are seeing
come from arch/x86/mm/highmem_32.c.  It uses several variables from
arch/x86/mm/init_32.c and you have copied them to arch/um.  However, getting
these variable defined is not going to make it work - the code that used
to set it had been in init_32.c too and you've just left your copy initialized
to NULL.  Which will *not* work.

IOW, it's still broken, but now you have lost all indications regarding the
source of problem.

Folks, "it doesn't build in that config" is _better_ than "it builds with
no complaints, but resulting binary is FUBAR".  As a short-term solution -
make HIGHMEM in arch/um/Kconfig.um depend on BROKEN.  The proper fix, of
course, is to try and make it _work_, not just compile, but that's going
to take a fair amount of digging in uml and x86 low-level VM guts.
