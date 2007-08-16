Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbXHPXbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbXHPXbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbXHPXbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:31:42 -0400
Received: from smtpout.mac.com ([17.250.248.174]:59325 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbXHPXbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:31:41 -0400
In-Reply-To: <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org>
References: <29015.1187178055@redhat.com> <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <08F0A127-BBEE-4B80-8AE7-1EB7CB815C16@mac.com>
Cc: David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Adding a security parameter to VFS functions
Date: Thu, 16 Aug 2007 19:30:42 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 16, 2007, at 18:57:24, Linus Torvalds wrote:
> On Wed, 15 Aug 2007, David Howells wrote:
>> Would you object greatly to functions like vfs_mkdir() gaining a  
>> security parameter?  What I'm thinking of is this:
>> int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,  
>> struct security *security)
>
> I personally consider this an affront to everythign that is decent.
>
> Why the *hell* would mkdir() be so magical as to need something  
> like that?

Not speaking directly for David, but I believe the reason is for  
background kernel code which needs to do filesystem access during a  
thread's execution with *completely* different security context from  
that of the thread.  Examples should be reasonably obvious; kNFSd is  
one, but it also includes anything where the kernel would poke  
directly into the filesystem, such as network filesystem cachefiles.

> Make it something sane, like a "struct nameidata" instead, and make  
> it at least try to look like the path creation that is done by "open 
> ()".  Or create a "struct file *" or something.
>
> I can imagine having "mkdir()" being passed similar data as "open 
> ()" (ie "lookup()"), but I cannot _possibly_ imagine it ever being  
> valid to pass in something totally made-up to just mkdir(), and  
> nothing else. There's something fundamentally wrong there.

I would offer the suggestion of using the described "struct security"  
in-place in the task struct, in place of using all those fields  
individually.  That would be, in effect the "default" security  
context for any given task, if "NULL" is passed to the appropriate  
vfs function.  For CacheFiles and kNFSd, they could each allocate  
their own during initialization or new-connection and pass that to  
any "mkdir()", etc that they do on behalf of a given client.


> What makes mkdir() so magical?
>
> Also, what about all the other ops? Why is mkdir() special, but not  
> "mknod()"? Why is "mkdir()" special, but not "rmdir()"? Really,  
> none of this seems to make any sense unless you describe what is so  
> magical about mkdir().

I think mkdir() was just an example he was using, probably because it  
was the first VFS call he needed to set a security context on.   Next  
would come anything which CacheFiles or NFSd call on the underlying  
filesystem.

Cheers,
Kyle Moffett

