Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbYDXUSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbYDXUSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbYDXUSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:18:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47954 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760057AbYDXUSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:18:34 -0400
Date: Thu, 24 Apr 2008 15:16:30 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424201630.GC18686@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080424181332.GB5882@ZenIV.linux.org.uk> <200804241940.m3OJe32l030977@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804241940.m3OJe32l030977@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 03:40:03PM -0400, Erez Zadok wrote:
> Ah, I see.  Yes: ecryptfs_init_persistent_file does have this odd
> "try to open readwrite and if that failed, try readonly" code there.
> I can't really say why it's done that way: Mike?  Maybe it was a
> workaround to not having the right permissions to open that
> persistent file?

The notion was that of "best effort," and it is sloppy.

I think the right way to do it will be to allow up to two persistent
files. If the user with read-only perms opens, then open the
persistent file RO. Then a user with write-only (but not read) perms
opens; open another persistent file WO. Allow subsequent reads or
writes by the various users to go through whichever persistent file
has the right access. Then a user with RW access opens the file; close
both the RO file and the WO file and open a new file RW. All the
while, make sure that ecryptfs_open() performs all the requisite perm
checks.

If this sounds reasonable, I will get working on a patch to do this.

Mike
