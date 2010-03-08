Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0CHTJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:09:38 -0500
Received: from ppp173-197.broadband.gorge.net ([209.216.173.197]:42764 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753798Ab0CHTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:09:32 -0500
Date: Mon, 8 Mar 2010 19:08:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100308190857.400bde09@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
	<20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Things like "/etc/passwd" really are about the _pathname_, not the inode. 
> It really is the _path_ that is special, because that is fundamentally the 
> thing you trust.

Why can I trust the path ?

> But it's not actually _true_ in any deeper sense. You're really just 
> trying to enforce a pathname-based model using a inode/content based 
> security hammer.

Quite untrue. I've actually *used* path based security systems (DEC10
ACLs) and for almost every case its brain-dead.

Imagine a world where this happened

	echo "hello" > fred
	chmod 666 fred
	ls -l fred
	fred rw-rw-rw-
	mv fred bill
	ls -l bill
	bill rw-------

week later
	vi fred
	ls -l fred
	fred rw-rw-rw-

Your password file is a special case

> And when you base your security on inodes, you _do_ have problems with 
> things like /etc. Exactly because there are many different paths in that 
> directory, and they actually have _different_ security issues. A program 
> that is supposed to be able to edit/replace /etc/hosts is _not_ supposed 
> to be able to edit/replace /etc/passwd.

In a secure system I don't just care if its called /etc/passwd. I care
that whoever made changes to it was trusted to do so and furthermore that
the suid binary, the libraries it relies upon and the other points of
trust that matter. Real security is *not* a file permissions system its a
trust model including things like integrity validation.

Another reason this is true is how passwd is updated - the tool creates
a new file of some name like passwd.tmp and does processing into that,
then renames it over the top. If I break passwd.tmp then you'll trust the
result "because it's called passwd", while a system that keeps
permissions and labels attached to the object will not because someone
tampered with the object that became passwd.

> Notice how it's really fundamentally about the pathname? When you create a 
> new file and overwrite /etc/passwd with that file, the security rules 
> really do _not_ come from your newly created inode, they come from the 
> fact that you made the path "/etc/passwd" point to that inode.

No - they come from whatever created or modified the file. It doesn't
matter what an object is called if I need to know whether the data in it
is honest.

> You end up making up new ideas to handle this: it's why traditional BSD 
> UNIX security has the setgid and sticky bit on directories, and it's also 
> obviously why selinux ends up having special rules for "link" and "rename" 
> etc - exactly so that you can emulate security that is really 
> fundamentally about the pathname.

The directory bits move with the directory - they are object
permissions to retrofit delete permission (a gap in the original
Unix design) and a very crude inheritance hack.

They are not about paths. If you mv a file into a directory with these
properties they don't magically inherit the properties.

> the file. The _fundamental_ rule is about the pathname. The labeling comes 
> about BECAUSE YOU USED A HAMMER FOR A SCREW.
> 
> I really don't understand why some people are unable to admit this fact. 

Perhaps because
- They understand what they are talking about and have studied the
  research
- They've got a grasp of the mathematical/logical models that this is all
  based upon
- They know the difference between access control lists and security
  models
- They aren't so arrogant as to assume that using the capslock key
  overrides fifty years of research

??

Alan
