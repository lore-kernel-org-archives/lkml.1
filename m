Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0CHSJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:09:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab0CHSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:09:37 -0500
Date: Mon, 8 Mar 2010 10:08:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Alan Cox wrote:
> 
> Ingo - just about all the serious security work disagrees with you.
> Pathnames are references to objects and keep changing. What matters is
> the object itself. This is also how Unix has always worked

The thing is, that's simply not the whole truth. It's _part_ of the truth, 
but there very much are pathname-based security in Unix too, including 
very much traditionally.

Things like "/etc/passwd" really are about the _pathname_, not the inode. 
It really is the _path_ that is special, because that is fundamentally the 
thing you trust.

You can try to turn that into a content-based security issue by claiming 
that it's about the "content of the '/etc' directory", and that is (along 
with other tricks) obviously how a a content-based security model has to 
work.

But it's not actually _true_ in any deeper sense. You're really just 
trying to enforce a pathname-based model using a inode/content based 
security hammer.

So that's an example of "if all you have is a hammer, everything looks 
like a nail" issue. If all you have is a content/inode-based security, you 
have to turn path-names into "directory inode" issues, and it's doable, 
but it's really like trying to convince everybody that screws do not exist 
because all you have is a hammer.

And when you base your security on inodes, you _do_ have problems with 
things like /etc. Exactly because there are many different paths in that 
directory, and they actually have _different_ security issues. A program 
that is supposed to be able to edit/replace /etc/hosts is _not_ supposed 
to be able to edit/replace /etc/passwd.

Notice how it's really fundamentally about the pathname? When you create a 
new file and overwrite /etc/passwd with that file, the security rules 
really do _not_ come from your newly created inode, they come from the 
fact that you made the path "/etc/passwd" point to that inode.

And again - you can emulate this with the inode-based thing. Your hammer 
does work, but it doesn't really invalidate the fact that the path really 
is what is most fundamental in that case, because the pathname is 
fundamentally the shared piece of information that different processes 
work with.

You end up making up new ideas to handle this: it's why traditional BSD 
UNIX security has the setgid and sticky bit on directories, and it's also 
obviously why selinux ends up having special rules for "link" and "rename" 
etc - exactly so that you can emulate security that is really 
fundamentally about the pathname.

In other words: it really _does_ make more sense to say "this process has 
rights to overwrite the path '/etc/passwd'" than it does to try to label 
the file. The _fundamental_ rule is about the pathname. The labeling comes 
about BECAUSE YOU USED A HAMMER FOR A SCREW.

I really don't understand why some people are unable to admit this fact. 

				Linus
