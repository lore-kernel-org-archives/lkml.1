Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYBEAJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYBEAJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbYBEAI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:08:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36309 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413AbYBEAIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:08:53 -0500
Message-ID: <47A7A903.1060000@garzik.org>
Date: Mon, 04 Feb 2008 19:08:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain> <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204210121.GF18682@fieldses.org> <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org> <47A7986B.1070206@garzik.org> <alpine.LFD.1.00.0802041530150.3034@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802041530150.3034@hp.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 4 Feb 2008, Jeff Garzik wrote:
>> Well, speaking as a complete nutter who just finished the bare bones of an
>> NFSv4 userland server[1]...  it depends on your approach.
> 
> You definitely are a complete nutter ;)
> 
>> If the userland server is the _only_ one accessing the data[2] -- i.e. the
>> database server model where ls(1) shows a couple multi-gigabyte files or a raw
>> partition -- then it's easy to get all the semantics right, including file
>> handles.  You're not racing with local kernel fileserving.
> 
> It's not really simple in general even then. The problems come with file 
> handles, and two big issues in particular:
> 
>  - handling a reboot (of the server) without impacting the client really 
>    does need a "look up by file handle" operation (which you can do by 
>    logging the pathname to filehandle translation, but it certainly gets 
>    problematic).
> 
>  - non-Unix-like filesystems don't necessarily have a stable "st_ino" 
>    field (ie it may change over a rename or have no meaning what-so-ever, 
>    things like that), and that makes trying to generate a filehandle 
>    really interesting for them.

Both of these are easily handled if the server is 100% in charge of 
managing the filesystem _metadata_ and data.  That's what I meant by 
complete control.

i.e. it not ext3 or reiserfs or vfat, its a block device or 1000GB file 
managed by a userland process.

Doing it that way gives one a bit more freedom to tune the filesystem 
format directly.  Stable inode numbers and filehandles are just easy as 
they are with ext3.  I'm the filesystem format designer, after all. (run 
for your lives...)

You do wind up having to roll your own dcache in userspace, though.

A matter of taste in implementation, but it is not difficult...  I've 
certainly never been accused of having good taste :)


> I do agree that it's possible - we obviously _did_ have a user-level NFSD 
> for a long while, after all - but it's quite painful if you want to handle 
> things well. Only allowing access through the NFSD certainly helps a lot, 
> but still doesn't make it quite as trivial as you claim ;)

Nah, you're thinking about something different:  a userland NFSD 
competing with other userland processes for access to the same files, 
while the kernel ultimately manages the filesystem metadata.  Recipe for 
races and inequities, and it's good we moved away from that.

I'm talking about where a userland process manages the filesystem 
metadata too.  In a filesystem with a million files, ls(1) on the server 
will only show a single file:

[jgarzik@core ~]$ ls -l /spare/fileserver-data/
total 70657116
-rw-r--r-- 1 jgarzik jgarzik 1818064825 2007-12-29 06:40 fsimage.1



> Of course, I think you can make NFSv4 to use volatile filehandles instead 
> of the traditional long-lived ones, and that really should avoid almost 
> all of the problems with doing a NFSv4 server in user space. However, I'd 
> expect there to be clients that don't do the whole volatile thing, or 
> support the file handle becoming stale only at certain well-defined points 
> (ie after renames, not at random reboot times).

Don't get me started on "volatile" versus "persistent" filehandles in 
NFSv4...  groan.

	Jeff


