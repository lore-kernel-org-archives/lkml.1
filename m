Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbYANN4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbYANN4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYANN4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:56:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35014 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYANN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:56:19 -0500
Date: Mon, 14 Jan 2008 13:56:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
Message-ID: <20080114135618.GQ27894@ZenIV.linux.org.uk>
References: <20080114123726.19968.patches@notabene> <1080114014531.20354@suse.de> <20080114020459.GN27894@ZenIV.linux.org.uk> <18314.54601.196877.828373@notabene.brown> <20080114034322.GO27894@ZenIV.linux.org.uk> <18314.59832.14451.334084@notabene.brown> <18315.284.774998.348672@notabene.brown> <20080114125939.GP27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114125939.GP27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 12:59:39PM +0000, Al Viro wrote:

> I really don't like the entire scheme, to be honest.  BTW, what happens
> if you try to add the same device to the same array after having it kicked
> out?  If that comes before your delayed kobject_del(), the things will
> get nasty since sysfs will (rightfully) refuse to add another entry with
> the same name and parent while the old one is still there and for all
> sysfs knows is going to stay there...

More fun questions: what are the locking requirements for ->resize()?
You are calling it with no exclusion whatsoever...  What about
bind_rdev_to_array()?  At the very least, you want to protect
mddev->disks, and AFAICS new_dev_store() has no exclusion at all.
And I suspect that you have other things in there in need of protection
(finding free desc_nr, for one); can all of those be handled by simple
spinlocks?
