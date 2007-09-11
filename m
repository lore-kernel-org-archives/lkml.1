Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXIKSAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXIKSAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXIKSAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:00:41 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52016 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbXIKSAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:00:40 -0400
Date: Tue, 11 Sep 2007 14:00:36 -0400
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: trivial comment fix
Message-ID: <20070911180036.GK13948@fieldses.org>
References: <20070910184632.GF2947@fieldses.org> <20070910185400.GG2947@fieldses.org> <18150.53623.525080.865402@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18150.53623.525080.865402@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 07:33:43PM +0200, Neil Brown wrote:
> On Monday September 10, bfields@fieldses.org wrote:
> > On Mon, Sep 10, 2007 at 02:46:32PM -0400, J. Bruce Fields wrote:
> > >   * This forceful removal will result in ugly /proc output if
> > >   * somebody holds a file open that got deleted due to a rename.
> > >   * We could be nicer about the deleted file, and let it show
> > > - * up under the name it got deleted rather than the name that
> > > - * deleted it.
> > > + * up under the name it had before it was deleted rather than
> > > + * under the original name of the file that was moved on top of it.
> > 
> > By the way, on further examination of the code it doesn't actually do
> > what's described in the case where the target name is large and the
> > moved-from name is small.  Instead, it reports random garbage (usually
> > part of a name left over from some other dentry?) as far as I can tell:
> > 
> > from switch_names():
> > 
> > 
> > 	if (dname_external(target)) {
> >                 if (dname_external(dentry)) {
> > 			...
> >                 } else {
> >                         /*
> >                          * dentry:internal, target:external.  Steal target's
> >                          * storage and make target internal.
> >                          */
> >                         dentry->d_name.name = target->d_name.name;
> >                         target->d_name.name = target->d_iname;
> > 
> > ... but target->d_iname could have anything in it, right?
> 
> Right, but not relevant.

The effect of it is that the name reported in /proc/<pid>/fd/<fd> is
random garbage if you're holding the target file open.  In quick tests,
I found that

	touch abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
	tail -f abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
	touch foo
	mv foo abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
	readlink /proc/<pid>/fd/<fd>

prints the initial portion of some other random name (often, not always,
"foo").

In theory I think that could disclose a little uninitialized kernel
memory, couldn't it?  I don't know if there's any practical way that
could be exploited.

> The name "switch_names" is somewhat misleading.  It is really
> "copyname" or similar.  From the comment at the top:
> 
>  * When switching names, the actual string doesn't strictly have to
>  * be preserved in the target - because we're dropping the target
>  * anyway. As such, we can just do a simple memcpy() to copy over
>  * the new name before we switch.
> 
> so the apparent name of 'target' after the 'swap' is not important.
> 
> The purpose of the assignment
>                          target->d_name.name = target->d_iname;
> is to make "dname_external(target)" false, that making "target
> internal" as the comment says.

Right.  But it looks like the contents of the buffer target->d_iname
also need to be initialized in this case--I suppose somebody just didn't
want to perform a memcpy they thought was pointless--so the name
reported in /proc is undefined.

--b.
