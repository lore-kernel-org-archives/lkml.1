Return-Path: <linux-kernel-owner+w=401wt.eu-S1764821AbXJTCdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764821AbXJTCdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXJTCdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:33:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53980 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXJTCda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:33:30 -0400
Date: Fri, 19 Oct 2007 22:33:05 -0400
Message-Id: <200710200233.l9K2X5qx015844@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, bfields@fieldses.org,
       nfs@lists.sourceforge.net, neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: nfsv2 ref leak in 2.6.24? 
In-reply-to: Your message of "Fri, 19 Oct 2007 17:52:32 EDT."
             <1192830752.7466.32.camel@heimdal.trondhjem.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond, good news.  I was able to narrow down the problem to purely the
client-side, probably dcache/readdir related, and I have a shell script that
deterministically triggers the problem each time for me (this is a FC6 image
under Vmware 6.0.1).  Here's a short shell script which reliably triggers
the "lost files" problem -- I create a file via nfs2 on the client side, and
sometimes it doesn't show up in readdir, but it is there if you stat it
directly.

BTW, since this is a client-side bug, I also tried your last set of posted
client patches for Linus, but it didn't help.

Happy hunting. :-)

Erez.

##############################################################################
#!/bin/sh

dd if=/dev/zero of=/tmp/fs.$$.0 bs=1024k count=1 seek=100
losetup /dev/loop0 /tmp/fs.$$.0
mkfs -t ext2 -q /dev/loop0
mkdir -p /n/export/b0
mount -t ext2 /dev/loop0 /n/export/b0
exportfs -o no_root_squash,rw localhost:/n/export/b0
mkdir -p /n/client/b0
mount -t nfs -o nfsvers=2 localhost:/n/export/b0 /n/client/b0

count=0
while true; do
    cfile="/n/client/b0/F.$count"

    if touch $cfile ; then
	echo $cfile created
    else
	echo "touch $cfile failed"
	exit 1
    fi

    if `ls -1 /n/client/b0 | egrep -q F.$count'$'` ; then
	:
    else
	echo "$cfile doesn't exist (but it should)"
	ls -l /n/client/b0
	ls -l /n/export/b0
	stat $cfile
	exit 1
    fi

    let count=count+1
done
##############################################################################
