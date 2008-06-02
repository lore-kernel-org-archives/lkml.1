Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYFBPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYFBPHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYFBPHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:07:41 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43117 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYFBPHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:07:40 -0400
Date: Mon, 2 Jun 2008 18:54:05 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Arnd Bergmann <arnd@arndb.de>
Cc: hooanon05@yahoo.co.jp, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Message-ID: <20080602145404.GA22400@2ka.mipt.ru>
References: <200805311737.58991.arnd@arndb.de> <200806020912.49721.arnd@arndb.de> <9159.1212402992@jrobl> <200806021315.41211.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806021315.41211.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd.

On Mon, Jun 02, 2008 at 01:15:40PM +0200, Arnd Bergmann (arnd@arndb.de) wrote:
> This is a very complicated approach, and I'm not sure if it even addresses
> the case where you have a shared mmap on both files. With VFS based union
> mounts, they share one inode, so you don't need to use idiotify in the first
> place, and it automatically works on shared mmaps.

Inotify has nothing common with that - it notifies about inode update,
which is only thing needed for unionfs. VM and aufs vmops will take care of
reads and writes, since there is no duplication of the data here.

> I mean having your own dentry and inode object is duplication. The
> underlying file system already has them, so if you have your own,
> you need to keep them synchronized. I guess that in order to do
> a lookup on a file, you need the steps of
> 
> 1. lookup in aufs dentry cache -> fail
> 2. lookup in underlying dentry cache -> fail
> 3. try to read dentry from disk -> fail
> 4. repeat 2-3 until found, or arrive at lowest level 
> 5. create an inode in memory for the lower file system
> 6. create dentry in memory on lower file system, pointing
>    to that
> 7. create an aufs specific inode pointing to the underlying
>    inode
> 8. create an aufs specific dentry object to point to that
> 9. create a struct inode representing the aufs inode
> 10. create another VFS dentry to point to that
> 
> when you really should just return the dentry found by the
> lower file system.

Or it is a feature, and you should not return dentry for lower file
system, when you can have different objects pointing to the
same object.

> It's not so much a practical limitation as an exploitable feature.
> E.g. an unpriviledged user may use this to get an application into
> an error condition by asking for an invalid file name.

Hmm... I believe if exploit wants to do bad things and system prevents
it, it is actually a right decision? But since you asked, I'm not sure
anymore...

> Posix reserves a well-defined set of invalid file names, and
> deviation from this means that you are not compliant, and that
> in a potentially unexpected way.

Everything has own limitation. 256 bytes per name is much stronger
problem, but everyone works with that.
It is a limitation, buts rather nonsignificant IMO.

> I personally think that a policy other than writing to the top is crazy
> enough, but randomly writing to multiple places is much worse, as it
> becomes unpredictable what the file system does, not just unexpected.

Is this a double rot13 encoded "people will never use computers with
more than 640 kb of ram" phrase? :)

While working VFS union mounting does not exist, AUFS does work.
It is just another filesystem, which works and has big userbase. Any VFS
approach (when implemented) will work on its own and its implementation
does not depend on this particular fs.

-- 
	Evgeniy Polyakov
