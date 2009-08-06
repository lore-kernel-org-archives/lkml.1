Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZHFU3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZHFU3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZHFU3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:29:54 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:49721 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbZHFU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:29:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGPaekqrR7PE/2dsb2JhbAC5IIgqkB4FhBg
X-IronPort-AV: E=Sophos;i="4.43,336,1246838400"; 
   d="scan'208";a="193315546"
From: Roland Dreier <rdreier@cisco.com>
To: Greg KH <gregkh@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [BUG] git 2.6.31-rc3'ish: "<kobject> does not have a release() function, it is broken and must be fixed."
References: <20090716181256.GA11157@rhlx01.hs-esslingen.de>
	<20090716225525.GC1548@suse.de>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 06 Aug 2009 13:28:01 -0700
In-Reply-To: <20090716225525.GC1548@suse.de> (Greg KH's message of "Thu, 16
	Jul 2009 15:55:25 -0700")
Message-ID: <adabpmsg01a.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Aug 2009 20:28:02.0289 (UTC) FILETIME=[655C0E10:01CA16D4]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > The error happening _before_ module _init() and _after_ module _exit()
 > > clearly points to something outside of an individual driver's control,
 > > i.e. a module core code bug, as hinted by Greg.
 > > 
 > > x86_32 UP, Debian testing, module-init-tools 3.9-2, git as of yesterday.
 > 
 > I can't duplicate this here at all.  I wonder what the difference is.
 > No one has touched this code path in a while, any chance you could run
 > 'git bisect' to track this down?

I don't understand how you can't duplicate it.  I see it here too
(missing release warning on module unload with kobject debugging turned
on) and it's obvious why it's happening from looking at the code;
lib/kobject.c has:

	struct kobj_type *t = get_ktype(kobj);
	//...
	if (t && !t->release)
		pr_debug("kobject: '%s' (%p): does not have a release() "
			 "function, it is broken and must be fixed.\n",
			 kobject_name(kobj), kobj);

and kernel/params.c has:

struct kobj_type module_ktype = {
	.sysfs_ops =	&module_sysfs_ops,
};

ie a ktype with no release method.  And indeed, the release method was
removed in:

commit 7a6a41615bfb2f03ce797bc24104c50b42c935e5
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Sat Dec 22 21:18:25 2007 -0800

    Modules: remove unneeded release function

ie you did it yourself!

What's the deal?

 - R.
