Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbXL1Ap0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbXL1Ap0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbXL1ApK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:45:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbXL1ApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:45:08 -0500
Date: Fri, 28 Dec 2007 00:45:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
Message-ID: <20071228004504.GK27894@ZenIV.linux.org.uk>
References: <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com> <20071226221631.GD27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com> <20071227225947.GH27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271552420.1154@schroedinger.engr.sgi.com> <20071227235804.GJ27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271601200.1294@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712271601200.1294@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 04:02:56PM -0800, Christoph Lameter wrote:
> > Why would you want these symlinks to stick around for longer than that?
> 
> /sys/kernel/slab/cache_name is a real directory but then there are the 
> aliases in /sys/kernel/slab/alias_name pointing to that directory that 
> also have to be removed.
> 
> So I need to scan for symlinks in /sys/kernel/slab/* pointing to 
> /sys/kernel/slab/cache_name.

Oh, lovely.  So we can have module A do kmem_cache_create(), calling
cache "foo".  Then module B does (without any knowlegde about A)
completely unrelated kmem_cache_create(), calling the sucker "bar".
mm/slub decides that they are mergable.  Then we get rmmod A... and
no way to find out if that's foo or bar going away - kmem_cache_destroy()
doesn't have enough information to figure that out.  So we have to keep
both slab/foo and slab/bar around until both are gone or until somebody
kind enough creates a cache called foo.  Better yet, on some systems you
get things like slab/nfsd4_delegations sticking around long after nfsd is
gone just because slub.c decides that it's sharable, but in the next
kernel version the thing it's shared with gets different object size and
behaviour suddenly changes - now it's gone as soon as nfsd is gone.
Brilliant interface, that...
