Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbYELByU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbYELByU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 21:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbYELByH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 21:54:07 -0400
Received: from ns1.suse.de ([195.135.220.2]:37783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbYELByF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 21:54:05 -0400
From: Neil Brown <neilb@suse.de>
To: Jesper Krogh <jesper@krogh.cc>
Date: Mon, 12 May 2008 11:53:57 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18471.41781.164396.385159@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
In-Reply-To: message from Jesper Krogh on Friday May 9
References: <4819E316.7000607@krogh.cc>
	<4823DFA6.9010504@krogh.cc>
	<20080508223635.523b8fa7.akpm@linux-foundation.org>
	<4823EA9E.6050703@krogh.cc>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday May 9, jesper@krogh.cc wrote:
> 
> When I disabled the NFS-server and rand my "real-world" program on a
> single processor (make -j 1). It ran through fine. It basically
> gets around 20 million chunks out of differnet file and assemble the
> chuncks in a few other files. This processes more or less 5 individual
> sections, so make can run effectively with a concurrency of 5.

(For linux-nfs readers: the problem is that repeatedly opening a given
 file sometimes returns a ENOENT - http://lkml.org/lkml/2008/5/9/15).

The mention of an NFS-server made my ears prick up...

Do I understand correctly that the problem only occurs when you have
48 clients hammering away at the filesystem in question?

Could the clients be accessing the same file that you are experiencing
problems with?  Or one of the directories in the path (if so, how
deep).

How many different files to these 20 million chunks come from?  And
how does that number compare with the first number from
   grep dentry /proc/slabinfo
??

The NFS server does some slighty strange things with the dcache if the
object being access is not in the cache.

Also, can get a few instances of 
   grep '^fh' /proc/nfs/rpc/nfsd

while things are going strange.  The numbers are:
 *	fh <stale> <total-lookups> <anonlookups> <dir-not-in-dcache> <nondir-not-in-dcache>

That will show us if it is looking for things that aren't in the
dcache.

Finally, if the filesystem export with "subtree_check" or
"nosubtree_check"?
Does it make a difference if you switch the setting of this flag and
re-export?

NeilBrown
