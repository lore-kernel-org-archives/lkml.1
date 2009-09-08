Return-Path: <linux-kernel-owner+w=401wt.eu-S1751290AbZIHPEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbZIHPEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZIHPEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:04:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbZIHPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:04:03 -0400
Date: Tue, 8 Sep 2009 08:02:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jamie Lokier <jamie@shareable.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/8] Simplify exec_permission_lite() further
In-Reply-To: <20090908144012.GB5579@shareable.org>
Message-ID: <alpine.LFD.2.01.0909080743580.7458@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <20090908144012.GB5579@shareable.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Sep 2009, Jamie Lokier wrote:
>
> Linus Torvalds wrote:
> > This function is only called for path components that are already known
> > to be directories (they have a '->lookup' method).  So don't bother
> > doing that whole S_ISDIR() testing,
> 
> A few years ago you briefly discussed diddling the VFS to accept
> objects which are both files and directories.  That is, have
> ->lookup() and also can be read as regular files.
> 
> I don't know if your thinking has changed, and I don't particularly
> care, only thought I'd remind in case it's something you'd like to
> support at some point.

No, I explicitly thought about that case too, and the thing is, that even 
_if_ we do that some day, the change is actually the RightThing(tm) to do.

In fact, it's even _more_ true in that case. The old code was broken for 
that case.

The thing is, if we ever implement the concept of using a regular file as 
a path component (say, we look up some attributes or we teach the kernel 
to look into tar-files or whatever), then the permission check for using 
it as a path component would be _different_ from the permission check for 
"executing" the file as a file.  When used as a path component, we'd want 
to use CAP_DAC_SEARCH, for example, not some "is it ok to execute this 
file" permission.

So "permission" for a path component really is fundamentally different 
from the same thing as an actual end-result file open/use. They do share 
some logic, of course, like just the whole owner/group/other and ACL 
logic. But at the same time they have conceptual - and actual - 
differences too.

Just think about what "execute" permission means: it's not just the 'x' 
bit, there are things like per-filesystem "NOEXEC" bits. We check that at 
a completely different level already - exactly because the "execute" 
permission for a pathname component is something fundamentally _different_ 
from executing the result of an actual final lookup.

The "exec_permission_lite()" function makes some of that difference more 
explicit - and also makes it explicit what is shared. We do check the 'x' 
bit, and we do honor ACL bits, but the whole Integrity check part was very 
obviously meant to be done at the "actual final lookup result" level 
rather than at the path component level.

In fact, as it was, "ima_path_check()" wouldn't know whether MAY_EXEC 
meant that we were going to actually run a program, or look up a pathname. 
The way it "solved" that was to just ignore non-regular files. And I'm 
convinced that the real solution is to just say that "ima_path_check()" is 
always checking the end result of a path, not the components, and then 
MAY_EXEC actually has a much more unambiguous meaning.

(Admittedly I think the IMA code could also have disambiguated the cases 
by looking at whether MAY_OPEN is set ot not - looking at whether the 
inode in question had S_ISDIR set probably had other reasons too).

Anyway, I do suspect that if we ever do the whole "able to treat regular 
files as a lookup target" we _will_ hit other issues, and it's going to 
require a lot of thought - but I suspect this series is actually going to 
help it by separating out the permission handling more clearly.

			Linus
