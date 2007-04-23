Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXDWGoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXDWGoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXDWGoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:44:46 -0400
Received: from mx1.suse.de ([195.135.220.2]:39095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbXDWGop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:44:45 -0400
From: Neil Brown <neilb@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Date: Mon, 23 Apr 2007 16:44:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17964.21972.961812.744601@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: message from Christoph Lameter on Thursday April 19
References: <17960.16739.870487.497750@notabene.brown>
	<Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
	<17960.20796.761309.771912@notabene.brown>
	<Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 19, clameter@sgi.com wrote:
> 
> Right. Sigh. But there is no user of the symlinks.
> 
> I could drop the symlinks completely. Just do not track what names a cache 
> aliases to?
> 

Suppose I have a kmem_cache which at different times has different
sizes (like, for example, the cache used for 'stripe_head' in
md/raid5.c.  If I 'grow' and array, I resize that kmem_cache).

Suppose that the first time I create it, it has size X, and then
someone else creates a cache with size X.  The second cache will become
an alias for the first.  So when the first is destroyed, the name
says. 

Now I try to create another cache with the same name (it is serving
the same purpose) but with a different size.  It will need to create a
new cache, but the name is still in use.  Bang!

I really think you need to return a different handle to each
kmem_cache_create call so that you know which cache is being deleted
so you can mangle names correctly.

Another option might be to name each cache actually created with a
unique name, and then create a symlink for each cache that was asked
for (whether it was created or whether a pre-existing cache was used).
Then being lazy about deletion shouldn't be a problem.

NeilBrown
