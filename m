Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbXIUIR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbXIUIR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbXIUIRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:17:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbXIUIRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:17:46 -0400
Date: Fri, 21 Sep 2007 01:17:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 07/25] r/o bind mounts: elevate write count for some
 ioctls
Message-Id: <20070921011706.88e9bcdd.akpm@linux-foundation.org>
In-Reply-To: <20070920195257.0E38EED5@kernel>
References: <20070920195249.852667D5@kernel>
	<20070920195257.0E38EED5@kernel>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 12:52:57 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:

> +		ret = mnt_want_write(filp->f_vfsmnt);

It still creeps me out that we have this sprinkled *all over* the tree and
people will forget to do it and there's no runtime or compile-time checking
that they remembered to do it and when they forget to do it nobody will
notice that it broke until ages and ages later.

IOW: it is a sheer horror for maintainability.


Please have a think about what we can do about this.  For example, if you'd
thought about this up-front, (and I think it's a big problem), we could
have done something grotty like, in mnt_want_write():

	current->vfsmnt_im_allowed_to_write_to = inode;

and then check that current->vfsmnt_im_allowed_to_write_to is the correct
inode in __mark_inode_dirty() and various other strategic places.  That
sort of thing.


We need to do *something*, I think.  This code just doesn't look feasibly
maintainable to me.

