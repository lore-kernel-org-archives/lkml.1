Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYCND6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYCND6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 23:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYCND6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 23:58:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbYCND6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 23:58:23 -0400
Message-ID: <47D9F6CC.6010009@redhat.com>
Date: Thu, 13 Mar 2008 20:53:48 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080303)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] Union mount readdir support in glibc
References: <20080311055527.GA7256@in.ibm.com>
In-Reply-To: <20080311055527.GA7256@in.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Bharata B Rao wrote:
> readdir in glibc
> ----------------
> glibc readdir would maintain a cache of dirents returned by readdir/getdents
> system call to perform duplicate elimination and whiteout supression.

As an optimization I have no problem with adding the code to glibc if it
does not impact non-union directories.  But requiring lockstep update of
kernel and glibc to use a feature like this which is not under control
of the application is a huge problem.  I don't think we ever had to
resort to this.  I consider this absolutely only the last resort.

Current readdir requires:


  opendir:   open
             fstat  (this can probably even be removed)
             malloc small buffer

  readdir:   if buffer is empty
                  getdents call (read multiple entries)
             return next entry


There is very little overhead.  Since we copy using getdents multiple
records it is more efficient than implementing readdir in the kernel.
This is how efficient normal directory operations must remain.  The only
slight inefficiency is that we have to copy the entries after getdents()
because the d_type field is not in the place we expect it at userlevel.
 For this a new interface could help.


To handle union FS at userlevel somewhere in that code sequence (perhaps
in the fstat call) we'd have to recognize such mounts.  Before any
agreement on userlevel sorting can be made you'll have to answer a
question Roland already asked:

- - How does this work with NFS?


Regarding questions you have: if a directory currently is read and file
are added or removed, all bets are off.

re seeking: you have to support seeking.  There is no way around it.
Once again, if any file has been added/removed, all bets are off.  So,
why not provide a cookie similar to what is done today?  I think it is
not acceptable to require caching the entire directory content at
userlevel.  It's bad enough if we have to store the file names for
duplicate elimination.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkfZ9GgACgkQ2ijCOnn/RHS/nACgx/NQqWB0kIbXBkwuSZIr1alX
78EAn2PECJ/9Ax3RzyayatE61ZM9I42W
=vFJP
-----END PGP SIGNATURE-----
