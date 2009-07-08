Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbZGHJwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbZGHJwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZGHJwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:52:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39095 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZGHJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:52:30 -0400
Date: Wed, 8 Jul 2009 18:52:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fb: move mutex_init to framebuffer_alloc()
Message-ID: <20090708095212.GA14844@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Wu Zhangjin <wuzhangjin@gmail.com>, Daniel Mack <daniel@caiaq.de>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, stable@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1246465606-29346-1-git-send-email-daniel@caiaq.de> <1247046145.22324.12.camel@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247046145.22324.12.camel@falcon>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 05:42:25PM +0800, Wu Zhangjin wrote:
> On Wed, 2009-07-01 at 18:26 +0200, Daniel Mack wrote:
> > In 537a1bf05, a per-fbinfo mutex was added and framebuffer drivers were
> > adopted accordingly. This new lock is currently initialized in
> > register_framebuffer().
> > 
> > The mx3fb driver takes this lock in mx3fb_map_video_memory() _before_
> > register_framebuffer() is called and hence crashes the system very
> > early.
> > 
> > Moving this mutex_init() to framebuffer_alloc() solves this and also
> > seems a lot more straight forward.
> > 
> 
> but this may introduce deadlock to some _old_ drivers which have not
> used framebuffer_alloc to allocate fb_info structure.
> 
> to avoid deadlock, these drivers need to change kmalloc to
> framebuffer_alloc, otherwise, they need to add their own mutexes
> initialization source code:
> 		mutex_init(&info->lock);	mutex_init(&info->mm_lock);
> 
> here is only a record for the _old_ drivers' maintainers. hope they can
> get this info from google or find this commit: 
> 
Yes, I'm going through and gradually converting all of the outstanding
drivers (both old and new) over to framebuffer_alloc(). The old ones are
a bit more tedious given all of the casting games they play. I should
have the outstanding ones finished tomorrow.
