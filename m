Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXEaDbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXEaDbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXEaDbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:31:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:51646 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbXEaDbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:31:22 -0400
From: Neil Brown <neilb@suse.de>
To: Nikita Danilov <nikita@clusterfs.com>
Date: Thu, 31 May 2007 13:31:00 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18014.16756.192137.738569@notabene.brown>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Newsgroups: gmane.linux.kernel.device-mapper.devel,gmane.linux.file-systems,gmane.linux.raid,gmane.linux.kernel
In-Reply-To: message from Nikita Danilov on Monday May 28
References: <18006.38689.818186.221707@notabene.brown>
	<18010.47701.751118.336431@gargle.gargle.HOWL>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday May 28, nikita@clusterfs.com wrote:
> Neil Brown writes:
>  > 
> 
> [...]
> 
>  > Thus the general sequence might be:
>  > 
>  >   a/ issue all "preceding writes".
>  >   b/ issue the commit write with BIO_RW_BARRIER
>  >   c/ wait for the commit to complete.
>  >          If it was successful - done.
>  >          If it failed other than with EOPNOTSUPP, abort
>  >          else continue
>  >   d/ wait for all 'preceding writes' to complete
>  >   e/ call blkdev_issue_flush
>  >   f/ issue commit write without BIO_RW_BARRIER
>  >   g/ wait for commit write to complete
>  >        if it failed, abort
>  >   h/ call blkdev_issue
>  >   DONE
>  > 
>  > steps b and c can be left out if it is known that the device does not
>  > support barriers.  The only way to discover this to try and see if it
>  > fails.
>  > 
>  > I don't think any filesystem follows all these steps.
> 
> It seems that steps b/ -- h/ are quite generic, and can be implemented
> once in a generic code (with some synchronization mechanism like
> wait-queue at d/).

Yes and no.
It depends on what you mean by "preceding write".

If you implement this in the filesystem, the filesystem can wait only
for those writes where it has an ordering dependency.   If you
implement it in common code, then you have to wait for all writes
that were previously issued.

e.g.
  If you have two different filesystems on two different partitions on
  the one device, why should writes in one filesystem wait for a
  barrier issued in the other filesystem.
  If you have a single filesystem with one thread doing lot of
  over-writes (no metadata changes) and the another doing lots of
  metadata changes (requiring journalling and barriers) why should the
  data write be held up by the metadata updates?

So I'm not actually convinced that doing this is common code is the
best approach.  But it is the easiest.  The common code should provide
the barrier and flushing primitives, and the filesystem gets to use
them however it likes.

NeilBrown
