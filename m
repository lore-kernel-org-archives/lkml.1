Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZGQVfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZGQVfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbZGQVfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:35:18 -0400
Received: from cobra.newdream.net ([66.33.216.30]:51013 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868AbZGQVfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:35:17 -0400
Date: Fri, 17 Jul 2009 14:35:16 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
In-Reply-To: <20090717200114.GA6173@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.0907171433060.23194@cobra.newdream.net>
References: <1247693090-27796-15-git-send-email-sage@newdream.net>
 <1247693090-27796-16-git-send-email-sage@newdream.net>
 <1247693090-27796-17-git-send-email-sage@newdream.net>
 <1247693090-27796-18-git-send-email-sage@newdream.net>
 <1247693090-27796-19-git-send-email-sage@newdream.net> <87d480x16p.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net>
 <Pine.LNX.4.64.0907171010470.23194@cobra.newdream.net>
 <20090717185641.GH8046@one.firstfloor.org> <Pine.LNX.4.64.0907171247570.23194@cobra.newdream.net>
 <20090717200114.GA6173@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Andi Kleen wrote:
> On Fri, Jul 17, 2009 at 12:52:33PM -0700, Sage Weil wrote:
> > > > 		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
> > > > 		 __LINE__, args);
> > > 
> > > That seems like a wasteful way to do this -- i bet you could
> > > shrink binary size with debugging on considerably if you move
> > > the file_part into a function.
> > 
> > If you mean ceph_file_part shouldn't be inline, definitely.  Beyond that 
> > I'm not sure what more to change... it's just a few extra chars on the 
> > format string and 2 calls instead of 1?
> 
> Yes, but you have hundreds/thousands of these calls don't you?
> 
> If you have two calls here instead of one and that costs let's say
> 20 bytes of code and 1000 calls it's already 20K of binary size.
> 
> Perhaps code size is not your highest priority now, but 
> obvious inefficiencies like this are not good.

Is that really a concern when compiling with DEBUG or 
CONFIG_DYNAMIC_DEBUG?  Since pr_debug is a no-op without those anyway, how 
about:

---

#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
extern const char *ceph_file_part(const char *s, int len);
# define dout(fmt, ...)							\
	pr_debug(" %12.12s:%-4d : " fmt,				\
		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
		 __LINE__, ##__VA_ARGS__);
#else
/*
 * this is a no-op, but keep the faux printk call just so we see any
 * compiler warnings.
 */
# define dout(fmt, ...)	do {						\
		if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
	} while (0)
#endif
