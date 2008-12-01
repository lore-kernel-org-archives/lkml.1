Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYLATWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYLATWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLATWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:22:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59497 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYLATWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:22:10 -0500
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081128112745.GR28946@ZenIV.linux.org.uk>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>
	 <20081128112745.GR28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 11:22:04 -0800
Message-Id: <1228159324.2971.74.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 11:27 +0000, Al Viro wrote:
> On Wed, Nov 26, 2008 at 08:04:40PM -0500, Oren Laadan wrote:
> > +/**
> > + * cr_attach_get_file - attach (and get) lonely file ptr to a file descriptor
> > + * @file: lonely file pointer
> > + */
> > +static int cr_attach_get_file(struct file *file)
> > +{
> > +	int fd = get_unused_fd_flags(0);
> > +
> > +	if (fd >= 0) {
> > +		fsnotify_open(file->f_path.dentry);
> > +		fd_install(fd, file);
> > +		get_file(file);
> > +	}
> > +	return fd;
> > +}
> 
> What happens if another thread closes the descriptor in question between
> fd_install() and get_file()?

You're just saying to flip the get_file() and fd_install()?

> > +	fd = cr_attach_file(file);	/* no need to cleanup 'file' below */
> > +	if (fd < 0) {
> > +		filp_close(file, NULL);
> > +		ret = fd;
> > +		goto out;
> > +	}
> > +
> > +	/* register new <objref, file> tuple in hash table */
> > +	ret = cr_obj_add_ref(ctx, file, parent, CR_OBJ_FILE, 0);
> > +	if (ret < 0)
> > +		goto out;
> 
> Who said that file still exists at that point?

Ahhh.  We're depending on the 'struct file' reference that comes from
the fd table.  That's why there is supposedly "no need to cleanup 'file'
below".  But, some other thread can come along and close() the fd, which
will __fput() our poor 'struct file' and will make it go away.  Next
time we go and pull it out of the hash table, we go boom.

As a quick fix, I think we can just take another get_file() here.  But,
as Al notes, there are some much larger issues that we face with the
fd_table and multi-thread access.  They haven't "mattered" to us so far
because we assume everything is either single-threaded or frozen.
Sounds like Al isn't comfortable with this being integrated until a much
more detailed look has been taken.

> BTW, there are shitloads of races here - references to fd and struct file *
> are mixed in a way that breaks *badly* if descriptor table is played with
> by another thread.

One of the things about this that bothers me is that it shares too
little with existing VFS code.  It calls into a ton of existing stuff
but doesn't refactor anything that is currently there.  Surely there are
some common bits somewhere in the VFS that could be consolidated here.  

-- Dave

