Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbXJ1JeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbXJ1JeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 05:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXJ1JeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 05:34:08 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:39128 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXJ1JeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 05:34:07 -0400
Message-ID: <47245784.10209@cosmosbay.com>
Date: Sun, 28 Oct 2007 10:33:56 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: epoll design problems with common fork/exec patterns
References: <MDEHLPKNGKAHNMBLJOLKIEEDHNAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEEDHNAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 28 Oct 2007 10:34:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz a écrit :
>> 6) Epoll removes the file from the set, when the *kernel* object gets
>>    closed (internal use-count goes to zero)
>>
>> With that in mind, how can the code snippet above trigger a removal from
>> the epoll set?
> 
> 	I don't see how that can be. Suppose I add fd 8 to an epoll set. Suppose fd
> 5 is a dup of fd 8. Now, I close fd 8. How can fd 8 remain in my epoll set,
> since there no longer is an fd 8? Events on files registered for epoll
> notification are reported by descriptor, so the set membership has to be
> associated (as reflected into userspace) with the descriptor, not the file.

Events are not necessarly reported "by descriptors". epoll uses an opaque 
field provided by the user.

It's up to the user to properly chose a tag that will makes sense if the user 
app is playing dup()/close() games for example.

typedef union epoll_data
{
   void *ptr;
   int fd;
   uint32_t u32;
   uint64_t u64;
} epoll_data_t;


It's true some applications are using 'fd' field from epoll_data_t, but in 
this case they should not play dup()/close() games that could change the 
meaning of their 'epoll tags'. They would better use 'ptr/u64' for example to 
map the event to an application object. In this object they might find the 
correct handle (fd) to communicate with the kernel for a given 'file'. This 
handle could then be remapped to another handle using dup()/fcntl()/close()...


> 
> 	For example, consider:
> 
> 	1) Process creates an epoll set, the set gets fd 4.
> 
> 	2) Process creates a socket, it gets fd 5.
> 
> 	3) The process adds fd 5 to set 4.
> 
> 	4) The process forks.
> 
> 	5) The child inherits the epoll set but not the socket.
> 
> 	Here the kernel cannot quite do the right thing. Ideally, the parent would
> still have fd 5 in its version of the epoll set. After all, it has not
> closed fd 5. However, the child *cannot* see fd 5 in its version of the
> epoll set since it has no fd 5. An event reported for fd 5 would be
> nonsense.

Yes, it would be nonsense that the child still tries to get events from the 
epoll set while he cannot possibly use the socket. If you use 'ptr' field to 
retrieve an object, this object probably would have no meaning in the child 
anyway, especially after an exec() syscall.

That kind of user error can also happens with select()/poll(), if you do for 
example :

FD_ZERO(&fdset);
FD_SET(fd, &fdset);
select(fd+1,&fdset, NULL, NULL, NULL);
newfd = dup(fd);
close(fd);
for (i = 0 ; i < maxfd ; i++)
if (FD_ISSET(i, &fdset))
     read(i, ...)


