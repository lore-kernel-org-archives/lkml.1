Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXFSI3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXFSI3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXFSI3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:29:40 -0400
Received: from paragon.brong.net ([66.232.154.163]:34577 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbXFSI3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:29:39 -0400
Date: Tue, 19 Jun 2007 17:58:57 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan <alan@clueserver.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>, git@vger.kernel.org
Subject: Re: Versioning file system
Message-ID: <20070619075857.GA2944@brong.net>
References: <OF7FA807A1.64C0D5AF-ON882572FE.0061B34C-882572FE.00628322@us.ibm.com> <6E9A6F9E-8948-40F2-9129-1F1491D49D83@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E9A6F9E-8948-40F2-9129-1F1491D49D83@mac.com>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:10:42PM -0400, Kyle Moffett wrote:
> On Jun 18, 2007, at 13:56:05, Bryan Henderson wrote:
>>> The question remains is where to implement versioning: directly in 
>>> individual filesystems or in the vfs code so all filesystems can use it?
>>
>> Or not in the kernel at all.  I've been doing versioning of the types I 
>> described for years with user space code and I don't remember feeling that 
>> I compromised in order not to involve the kernel.
>
> What I think would be particularly interesting in this domain is something 
> similar in concept to GIT, except in a file-system:

I've written a couple of user-space things very much like this - one
being a purely database (blobs in database, yeah I know) system for
managing medical data, where signatures and auditability were the most
important part of the system.  Performance really wasn't a
consideration.

The other one is my current job, FastMail - we have a virtual filesystem
which uses files stored by sha1 on ordainary filesystems for data
storage and a database for metadata (filename to sha1 mappings, mtime,
mimetype, directory structure, etc).

Multiple machine distribution is handled by a daemon on each machine
which can be asked to make sure the file gets sent out to every machine
that matches the prefix and will only return success once it's written
to at least one other machine.  Database replication is a different
beast.


It can work, but there's one big pain at the file level: no mmap.

If you don't want to support mmap it can work reasonably happily, though
you may want to keep your sha1 (or other digest) state as well as the
final digest so you can cheaply calculate the digest for a small append
without walking the entire file.  You may also want to keep state
checkpoints every so often along a big file so that truncates don't cost
too much to recalculate.

Luckily in a userspace VFS that's only accessed via FTP and DAV we can
support a limited set of operations (basically create, append, read,
delete)  You don't get that luxury for a general purpose filesystem, and
that's the problem.  There will always be particular usage patterns
(especially something that mmaps or seeks and touches all over the place
like a loopback mounted filesystem or a database file) that just dodn't
work for file-level sha1s.


It does have some lovely properties though.  I'd enjoy working in an
envionment that didn't look much like POSIX but had the strong
guarantees and auditability that addressing by sha1 buys you.

Bron.


