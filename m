Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXFZVBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXFZVBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXFZVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:01:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56474 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbXFZVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:01:34 -0400
Message-ID: <46817E9B.40608@novell.com>
Date: Tue, 26 Jun 2007 14:01:15 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Chris Mason <chris.mason@oracle.com>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <20070622140240.GM6222@think.oraclecorp.com> <Line.LNX.4.64.0706221012340.6190@localhost.localdomain> <20070622173056.GA873@think.oraclecorp.com> <20070623001149.GI3457@sequoia.sous-sol.org>
In-Reply-To: <20070623001149.GI3457@sequoia.sous-sol.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Chris Mason (chris.mason@oracle.com) wrote:  
>> I'm sure people there will have a different versions of events.  The
>> one part that was discussed was if pathname based security was
>> useful, and a number of the people in the room (outside of 
>> novell) said it was.  Now, it could be that nobody wanted to argue
>> anymore, since most opinions had come out on one list or another by
>> then.  
>>     
> Indeed.  The trouble is that's too high level compared with the actual
> implementation details.  AA is stalled because it has failed to get
> VFS support for it's model.  I don't see a nice way out unless it
> changes it's notion of policy language (globbing is the tough one)
> or gets traction to pass dentry/vfsmount all the way down.  Paths are
> completely relevant for security, esp. when considering the parent dir
> and the leaf (as in forward lookup case).
To do pathname-based access control in any way, the LSM must be able to
obtain the pathname of an accessed object. The discussion should be
about the best way for an LSM to obtain the pathname of an object being
accessed.

To find the pathname of the object, LSM needs the VFS mount point data.
The VFS owns this information, so the question is the best way to convey
it from VFS to relevant LSM hooks. We are agnostic about how to get that
mount point data, but AFAICT saying that LSM can't see the mount point
data at all is equivalent to rejecting pathname based access control
entirely.

>   Retroactively creating the
> full path is at the minimum ugly, and in the worst case can be insecure
> (yes AA has taken many measures to mitigate that insecurity).
>   
The reverse path construction has been criticized for being both broken
and counter-intuitive. Our secure d_path patch fixes the "broken" part,
it now securely reconstructs the path. The counter-intuitive is because
forward construction of the pathname has unexpected costs, making the
retroactive construction more attractive.

> AA folks: deal with the VFS issues that your patchset have in a palatable
> way (which does not include passing NULL when it's inconvenient to
> do otherwise).
John Johansen posted a patch (written by Andreas Gruenbacher) that
introduced a nameidata2 data structure to try to solve the conditional
null passing problem, but it received no comment. A proper fix to this
problem is clearly desirable, but it also is clearly a defect in NFS and
fixing it is a lot of work; why does AA have to stay outside the kernel
until NFS is fixed, when it can easily adapt to the problem until it is
fixed properly?

>   You've already missed an opportunity with Christoph's
> suggestions for changes in NFS.  I know you've considered many alternative
> approaches and consistently hit dead ends.  But please note, if you
> have coded yourself into a corner because of your policy language,
> that's your issue to solve, not ours.  
I think it is a little more fundamental than that. If you are going to
do pathname based access control at all, you need access to sufficient
information to compute the path name. Can we have a discussion about the
best way to do that?

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

