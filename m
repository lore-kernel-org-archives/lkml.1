Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZIJU6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZIJU6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZIJU6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:58:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZIJU6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:58:22 -0400
Date: Thu, 10 Sep 2009 16:57:57 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090910165757.43b77874@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909101541460.28418@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
	<20090905071052.50501826@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
	<20090909125352.1c7b57d2@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
	<20090909132039.1ca47cd4@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1>
	<20090909140257.35ede0cc@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1>
	<20090909205548.4858b524@zanovar.poochiereds.net>
	<alpine.DEB.1.10.0909101419310.29762@V090114053VZO-1>
	<20090910153347.2f2616e8@barsoom.rdu.redhat.com>
	<alpine.DEB.1.10.0909101541460.28418@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 15:42:28 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 10 Sep 2009, Jeff Layton wrote:
> 
> > I assume that the 32 and 64 bit clients you have are calling "ls" in
> > the same dir. If so, maybe a similar capture from a 64-bit client might
> > help us see the difference?
> 
> 64 bit trace attached.

A couple of differences. First, the "ls's" were done in different
directories since they had different search patterns:

32 == \*
64 == \clameter\*

...did they also mount different shares from the server?

The 64-bit capture was done in a directory with only 50 files,
whereas the other one had at least 600-700 files (capture ends before
it finished listing the files). That may make quite a bit of difference
on the server (not sure how windows works internally in this case).

The only other substantive difference I see is that the Level of
Interest that the client is requesting is different:

32 == SMB_FIND_FILE_DIRECTORY_INFO
64 == SMB_FIND_FILE_ID_FULL_DIR_INFO

That probably means that the 32 bit client has disabled
CIFS_MOUNT_SERVER_INUM for some reason. That means that it's not asking
the server for the windows equivalent of inode numbers. We typically
disable that flag automatically if a query for the inode number of a
path fails.

Since these are the same server, that may be an indicator that the
server is serving out info from two different filesystem types (maybe
FAT vs. NTFS, or maybe even a CDROM or something). If so, then that may
help explain some of the performance delta there. I'd be more
interested to see how the 64 bit client behaves when it mounts the
exact same share and does an ls in the same directory as the 32 bit
client.

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>
