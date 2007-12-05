Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbXLET4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbXLET4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXLET4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:56:14 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:60073 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbXLET4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:56:12 -0500
In-Reply-To: <6306.1196874660@redhat.com>
References: <6306.1196874660@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A0BB0F8C-9628-4B6C-A2F7-F3870B487D4E@oracle.com>
Cc: Peter Staubach <staubach@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: How to manage shared persistent local caching (FS-Cache) with NFS?
Date: Wed, 5 Dec 2007 14:54:25 -0500
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 5, 2007, at 12:11 PM, David Howells wrote:
> Okay...  I'm getting to the point where I want to release my local  
> caching
> patches again and have NFS work with them.  This means making NFS  
> mounts share
> or not share appropriately - something that's engendered a fair bit of
> argument.
>
> So I'd like to solicit advice on how best to deal with this problem.
>
> Let me explain the problem in more detail.
>
>
> ================
> CURRENT PRACTICE
> ================
>
> As the kernel currently stands, coherency is ignored for mounts  
> that have
> slightly different combinations of parameters, even if these  
> parameters just
> affect the properties of network "connection" used or just mark a  
> superblock
> as being read-only.
>
> Consider the case of a file remotely available by NFS.  Imagine the  
> client sees
> three different views of this file (they could be by three  
> overlapping mounts,
> or by three hardlinks or some combination thereof).
>
> This is how NFS currently operates without any superblock sharing:
>
> 				+---------+
>     Object on server --->	|	  |
> 				|  inode  |
> 				|	  |
> 				+---------+
> 				    /|\
> 				   / | \
> 				  /  |	\
> 				 /   |	 \
> 				/    |	  \
> 			       /     |	   \
> 			      /	     |	    \
> 			     /	     |	     \
> 			    /	     |	      \
> 			   /	     |	       \
> 			  /	     |		\
> 			 |	     |		 |
> 			 |	     |		 |
>  :::::::::::::NFS::::::::|:::::::::::|:::::::::::|:::::::::::::::::::: 
> :::::::::
> 			 |	     |		 |
> 			 |	     |		 |
> 			 |	     |		 |
>    +---------+	    +---------+	     |		 |
>    |	     |	    |	      |	     |		 |
>    | mount 1 |----->| super 1 |	     |		 |
>    |	     |	    |	      |	     |		 |
>    +---------+	    +---------+	     |		 |
> 				     |		 |
> 				     |		 |
>    +---------+			+---------+	 |
>    |	     |			|	  |	 |
>    | mount 2 |----------------->| super 2 |	 |
>    |	     |			|	  |	 |
>    +---------+			+---------+	 |
> 						 |
> 						 |
>    +---------+				    +---------+
>    |	     |				    |	      |
>    | mount 3 |----------------------------->| super 3 |
>    |	     |				    |	      |
>    +---------+				    +---------+
>
> Each view of the file on the client winds up with a separate inode  
> in a
> separate superblock and with a separate pagecache.  As far as the  
> client kernel
> is concerned, they *are* three different files.  Any incoherency  
> effects are
> ignored by the kernel and if they cause a userspace application a  
> problem,
> that's just too bad.
>
> Generally, however, this is not a problem because:
>
>   (a) an application is unlikely to be attempting to manipulate  
> multiple views
>       of a file simultaneously and
>
>   (b) cross-view hard links haven't been and aren't used that much.
>
>
> =============================
> POSSIBLE FS-CACHE SCENARIO #1
> =============================
>
> However, now we're introducing persistent local caching into the  
> mix.  That means we can no longer ignore such remote possibilities  
> - they are possible, therefore we have to deal with them, whether  
> we like it or not.


I don't see how persistent local caching means we can no longer  
ignore (a) and (b) above.  Can you amplify this a bit?  Nothing you  
say in the rest of your proposal convinces me that having multiple  
caches for the same export is really more than a theoretical issue.

Frankly, the reason why admins mount exports multiple times is  
precisely because they want different applications to access the  
files in different ways.  Admins *want* one mount point to be  
available ro, and another rw.  They *want* one mount point to use  
'noac' and another not to.  They *want* multiple sockets, more RPC  
slots, and unique caches for different applications.  No one would go  
to the trouble of mounting an export again, using different options,  
unless that's precisely the behavior that they wanted.

This is actually a feature of NFS.  It's used as a standard part of  
production environments, for example, when running Oracle databases  
on NFS.  One mount point is rw and is used by the database engine.   
Another mount point is ro and is used for back-up utilities, like RMAN.

Another example is local software distribution.  One mount point is  
ro, and is accessed by normal users.  Another mount point accesses  
the same export rw, and is used by administrators who provide updates  
for the software.

As useful as the feature is, one can also argue that mounting the  
same export multiple times is infrequent in most normal use cases.   
Practically speaking, why do we really need to worry about it?

The real problem here is that the NFS protocol itself does not  
support strong cache coherence.  I don't see why the Linux kernel  
must fix that problem.

The only real problem with the first scenario is that you may have  
more than one copy of a file in the persistent cache.  How often will  
that be the case?  Since the local persistence cache is probably disk- 
based and thus large relative to memory, what's the problem with  
using a little extra space?

The problems you ascribe to your second and third caching scenarios  
(deadlocking and reconnection) are, however, real and substantial.   
You don't have these issues when caching each mount point separately,  
right?

It seems to me that implementing the first scenario is (a)  
straightforward, (b) has fewer runtime risks (ie deadlocks), (c)  
doesn't take away features that some people still use, and (d) solves  
more than 80% of the issues here (80/20 rule of thumb).

Lastly, there's already a mount option that allows admins to control  
whether the page and attribute caches are shared -- "sharecache".  Is  
this mount option not adequate for persistent caching?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
