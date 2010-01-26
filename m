Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964Ab0AZTlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0AZTlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857Ab0AZTlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:41:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42746 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0AZTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:41:23 -0500
Date: Tue, 26 Jan 2010 19:41:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Open Intents, lookup_instantiate_filp() And All That Shit(tm)
Message-ID: <20100126194120.GK19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com> <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com> <20100123230735.GW19799@ZenIV.linux.org.uk> <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com> <20100126130349.GH19799@ZenIV.linux.org.uk> <1264520125.3789.32.camel@dyn9002018117.watson.ibm.com> <20100126163143.GJ19799@ZenIV.linux.org.uk> <1264528747.3062.11.camel@dyn9002018117.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264528747.3062.11.camel@dyn9002018117.watson.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[fsdevel Cc'd; see the horror story/semi-rant below]

On Tue, Jan 26, 2010 at 12:59:07PM -0500, Mimi Zohar wrote:

> I still don't see that the
> calls to do_filp_open() in the lookup_instantiate_filp(), but will take
> a closer look once these patches are out.  Also not sure if there is
> anything in the alloc_file() path.

OK...  lookup_instantiate_filp() is a god-awful mess, so it's OK to be
confused by it - its authors definitely had been ;-)

The thing is, currently lookup_instantiate_filp() is called *only* from
call chains starting in do_filp_open().  And place right after
nameidata_to_filp() is downstream from both those call chains and
from the call chain leading from do_filp_open() to dentry_open().

Gory and revolting details follow.

What's happening is easier to understand with code massage done in
vfs-2.6.git#untested; basically, the logics of do_filp_open() (in
_very_ obfuscated form in the mainline kernel) is this:
	* find parent directory + last component of pathname
	* do "open or create file with this name in that directory" actions
	* we can
		+ get opened struct file.  We are done.
		+ get ERR_PTR(-error).  Fail.
		+ be told that it's a symlink
	* try to follow it
		+ if it fails, fail.
		+ if it's a "direct" symlink a-la procfs, we just get to
open the file it points to.  It *will* exist, so O_CREAT|O_EXCL => fail,
and O_CREAT alone gets ignored.
		+ if it's a normal symlink, we'd just followed it up to
the last component.  Now we have new directory and new filename; repeat
the steps above.

That's the high-level overview.  The reason for that kind of loop lies in
the messy semantics of O_CREAT on dangling symlinks; nevermind that part
of the horror show for now.

The really interesting part is opening a file in known directory.
Normal filesystems do d_lookup + either ->lookup() or ->d_revalidate()
+ dentry_open() which will call ->open().  For file creation it may become
d_lookup + either ->lookup() or ->d_revalidate() + ->create() + dentry_open().

*However*, NFS really wants to issue a single request to server that would
do lookup + maybe create + open in one step.  Atomically.  Fair enough,
but they have a nasty problem - which of existing fs methods would do that?
Neither ->d_revalidate() nor ->lookup() are going to get struct file from
their caller, after all...

Now, the sane solution would be to introduce a new method that would do
lookup-or-d_revalidate+maybe-create+open.  With normal filesystems defaulting
to the usual sequence.  And have its caller pass all we need to it (struct
file, flags, mode, etc.).  That, BTW, is where #untested leads to - a large
part of things done in fs/namei.c:do_last() there will eventually bud off
into default instance of that new method.

However, that's *NOT* what had been done.  Instead of that the arguments
(struct file *, etc.) are hidden in struct nameidata and a pointer
to nameidata is added to argument lists of ->d_revalidate(), ->lookup(), etc.
And NFS has added "let's talk to server and try atomic open" into those
methods.  If that attempt succeeds, they call a helper
(lookup_instantiate_filp()) that fills the struct file indirectly passed
to the damn thing via pointer in nameidata.

Eventually, we emerge from all that mess back into do_filp_open().  There
we look at the struct file that had been refered to from nameidata and
check if it had already been filled.  _THEN_ we do dentry_open() in case
file hadn't been already filled by call of lookup_instantiate_filp() issued
by one of fs methods.   That's nameidata_to_filp().

So any call of lookup_instantiate_filp() will be followed by nameidata_to_filp()
and that's where we'll pick the results of the former.  If there'd been no
such call (we are on a normal fs, or NFS doesn't feel like doing atomic open
for that one), nameidata_to_filp() will be the place that calls dentry_open().

IOW, the point directly after nameidata_to_filp() is where all those paths
converge.  And yes, it's a horrible mess.  One I'd been slowly massaging into
saner shape for a year already ;-/

Eventually nameidata_to_filp() and lookup_instantiate_filp() will go to hell
and we'll get one or two methods getting unopened struct file, dentry (unhashed
new one or found in dcache) and the rest of open() arguments.  Default will
be to do ->lookup() or ->d_revalidate() + possibly ->create() + dentry_open();
NFS will be able to do its atomic open stuff ending with dentry_open().
In either case we'll get success, error or "it's a symlink, deal with it
yourself" and caller will act accordingly.  And that'll be the place to
do any immediately-after-open things, including ima_path_check().  With
only do_filp_open() ever calling that method.
