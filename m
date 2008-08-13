Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYHMRj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYHMRj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYHMRjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:39:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:50984 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYHMRjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:39:47 -0400
Date: Wed, 13 Aug 2008 10:39:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813103951.1e3e5827@infradead.org>
In-Reply-To: <1218645375.3540.71.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 12:36:15 -0400
Eric Paris <eparis@redhat.com> wrote:

[finally good description snipped]

> 
> 1) Kernel or userspace.

this is kind of the last question to ask, not the first ;)

> Not to mention there cannot be any checks for files
> opened by suid apps in userspace.  

setuid apps do not use glibc? news to me.

> And while no specific claims are
> being made about intentionally malicious code, putting this in kernel
> makes programs which call syscalls directly much more difficult to be
> used to circumvent the scanning.

[so lets ignore this one]

 
> 2) I think the "best" time to do scanning is at read and write.  Any
> disagreements there?

I agree about the "read" case.
"write" is tricky... because there's many vectors to write, from
write() system call to mmap() system call to truncate() system call.
(yes you can write a stream of bytes that passes virus scan, and then
truncate to be suddenly a live virus)

I would propose to use the word "dirty" instead, we all know what we
mean by that (it's all of them) and doesn't tie our thinking to the
write() system call.

I would like to introduce a concept in your discussion you did not
mention yet in this email: the difference between synchronous scanning
and asynchronous scanning.

It's clear from the protection model that you described that on 'read'
you want to wait until the scan is done before you give the data to the
process asking for it... and that's totally reasonable: "Do not give
out bad data" is a very clear line in terms of security.

for the "dirty" case it gets muddy. You clearly want to scan "some
time" after the write, from the principle of getting rid of malware
that's on the disk, but it's unclear if this HAS to be synchronous.
(obviously, synchronous behavior hurts performance bigtime so lets do
as little as we can of that without hurting the protection).
One advantage of doing the dirty case async (and a little time delayed)
is that repeated writes will get lumped up into one scan in practice,
saving a ton of performance.
(scan-on-close is just another way of implementing "delay the dirty
scan").
Based on Alans comments, to me this sounds like we should have an
efficient mechanism to notify userspace of "dirty events"; this is not
virus scan specific in any way or form. And this mechanism likely will
need to allow multiple subscribers.

for the open() case, I would argue that you don't need synchronous
behavior as long as the read() case is synchronous. I can imagine that
open() kicks off an async scan, and if it's done by the time the first
read() happens, no blocking at all happens.


For efficiency the kernel ought to keep track of which files have been
declared clean, and it needs to track of a 'generation' of the scan
with which it has been found clean (so that if you update your virus
definitions, you can invalidate all previous scanning just by bumping
the 'generation' number in whatever format we use). 
Clearly the kernel needs to wipe this clean generation number on any
modification to the file (inode) of any kind. And clearly this needs to
be done inside the kernel because tracking dirty operations in any
other way is just insane.


Now this to me we have a few basic building blocks:
1) We need an efficient mechanism to notify userspace of files that get
dirtied. Virus scanners will subscribe to this for the async dirty
scanning; indexing agents also will subscribe to this.
2) We very likely should have a mechanism for a userspace app to
request a scan on a file, both sync or async (O_SYNC flag?). This is
useful regardless because it allows the source of many things to do the
right thing.
3) we need a mechanism in the kernel to track "scanned with generation
X of signatures" that invalidates on any dirty operation. The syscall
from 2) will use this as a cache to be quick.

I think few people will disagree about this.

Open questions now are
4) do we have the kernel kick off an async scan in open() or do we have
glibc do this
5) do we have the kernel do the sync scan on read/mmap/.. or do we have
glibc do this

I think this is where the whole debate is about now.


And a few hard ones
6) how do we deal with multiple scanning agents in parallel
7) how do we prevent malware from pretending to be a virus scanner



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
