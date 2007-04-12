Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXDLH1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXDLH1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXDLH1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:27:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422689AbXDLH1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:27:38 -0400
From: Neil Brown <neilb@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Date: Thu, 12 Apr 2007 17:27:33 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17949.57189.565653.289035@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: SLUB: kmem_cache_destroy doesn't 
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I tried out SLOB in latest mm.
raid5 uses kmem_cache_create to create a cache, a deletes it with
kmem_cache_destroy.

After I change the name for the slab to not include a '/' the create
worked fine, but the destroy seems incomplete.
If I stop an array and restart it, the second kmem_cache_create fails
because it thinks the name is already in use.

If I look in sysfs, I can see it there.
And 

  # cat /sys/slab/raid5-md1/aliases
  -1

is a bit suspicious.

And

void kmem_cache_destroy(struct kmem_cache *s)
{
	down_write(&slub_lock);
	if (s->refcount)
		s->refcount--;
	else {
		list_del(&s->list);
		WARN_ON(kmem_cache_close(s));
		sysfs_slab_remove(s);
		kfree(s);
	}
	up_write(&slub_lock);
}

looks a bit odd.
I would have thought the test should be:

        if (s->refcount > 1)

??

(2.6.21-rc6-mm1 to be precise)

NeilBrown
