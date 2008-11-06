Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYKFFV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYKFFV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbYKFFVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:21:47 -0500
Received: from [74.13.241.36] ([74.13.241.36]:56263 "EHLO slyph.dragoninc.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYKFFVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:21:46 -0500
From: "Doug Nazar" <nazard@dragoninc.ca>
To: "'J. Bruce Fields'" <bfields@fieldses.org>
Cc: "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, <linux-kernel@vger.kernel.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca> <20081104223000.GG10974@fieldses.org> <004a01c93f37$f2a09090$d7e1b1b0$@ca> <20081105214655.GK1455@fieldses.org>
In-Reply-To: <20081105214655.GK1455@fieldses.org>
Subject: RE: 2.6.28-rc3 truncates nfsd results
Date: Thu, 6 Nov 2008 00:21:26 -0500
Message-ID: <000001c93fcf$8431dbd0$8c959370$@ca>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ack/kBSWuE8v/eM3QPm6o1tWDtjhdQAOPoYw
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: J. Bruce Fields [mailto:bfields@fieldses.org]
> Anyone know where to find the best documentation of the vfs_readdir
> semantics?  I obviously didn't understand it as well as I should.

Hmm.... I seem to remember a conversation about readdir from Al awhile back. Looking....

Here it is:
http://kerneltrap.org/mailarchive/linux-fsdevel/2008/8/12/2903744

Maybe that will help. 

> > The computers showing the issue are not using dir_index. This causes
> > ext3 to read a block at a time, which then means we can end up with
> > buf.full==0 but not finished reading the directory. Before 8d7c4203,
> > we'd always get called again because we never set nfserr_eof which
> > papered over it.
> 
> OK, so if I'm understanding you correctly: there was also (as of
> c002a6c797 "Optimise NFS readdir hack slightly"?) a performance
> regression which could force the client to do more round trips to the
> server to read the whole directory?

>From what I could see yes. On an empty directory there would actually be two readdir 
requests both with eof not set. On a full directory when the sending buffer was full,
func() would return NFS4ERR_TOOSMALL and nfsd_buffered_read would return success. After 
c002a6c797 "Optimise NFS readdir hack slightly", I ended up with buf.used=912, 
buf.full=0 & offset=4096 so we would finish the while loop with a small output buffer, 
eof not set. The client then makes another request and continues so long as forward 
progress was made. After 8d7c4203c6 "nfsd: fix failure to set eof in readdir in some situations"
it would force eof for any small buffer causing the client to terminate the request.

Commit look fine and sure add my signed-off-by. Not sure if we got *all* the bugs but the way 
I see it, every bug is a chance to learn <g>


