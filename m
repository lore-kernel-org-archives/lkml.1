Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYA2WUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYA2WUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYA2WUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:20:31 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23569 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYA2WUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:20:30 -0500
Date: Tue, 29 Jan 2008 14:18:59 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Mark Fasheh <mark.fasheh@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [git pull] Fix recent Ocfs2 breakage
Message-ID: <20080129221858.GA27902@mail.oracle.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Mark Fasheh <mark.fasheh@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080129033307.GE23506@ca-server1.us.oracle.com> <20080129050804.GA2285@suse.de> <20080129074402.GA27097@ca-server1.us.oracle.com> <20080129185448.GA358@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129185448.GA358@suse.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 10:54:48AM -0800, Greg KH wrote:
> > 	ocfs2 kobject usage, or other folks'?  If there's anything in
> > the ocfs2 usage that you are unsure of, feel free to ask!
> 
> Ok, great.  Here's a few questions:
> 
>   - ocfs2/cluster/sys.c creates a single kset, o2cb, that is in
>     /sys/o2cb (and I had moved it to /sys/fs/o2cb/)  In that directory
>     it seems there is only 1 file, O2NM_API_VERSION.  Is that really all
>     that goes into that directory?  If so, this can be cleaned up even
>     further and only a single kobject is needed, a kset is overkill.

	The kset exists so we can put the logmask directory underneath
it, as you notice in the next item.

>   - that kset is then passed to the mlog_sys_init() file to chain
>     another subdirectory off of this.  Here's where the meat of the
>     sysfs files are.  You use a custom kset and show/store operations to
>     describe some bit fields?  You never use the kobject here, but only
>     go off of the name of the attribute file, which is fine.  But again,
>     using a ktype/kset is way overkill for this.  It can be all
>     simplified to only have 1 kobject for the directory, and then the
>     individual attributes can be a kobj_attribute.

	Well, what's a kobj_attribute do differently?  I mean, logmask
is one object, distinct from the o2cb toplevel, and it has multiple
attributes.  That's pretty standard sysfs, no?
	Oh, I see, kobj_attribute wraps struct attribute the way we do
with "mlog_attribute".  Pretty much everyone did it themselves back in
the day, with a set of hand-built "turn struct attribute into struct
foo_attribute" version of show() and store().  But then you have ot wrap
that in our own attribute anyway...well, not for the mlog one, I don't
think, as it keys off the name.  So perhaps we could remove "struct
mlog_attribute" and replace it with "struct kobj_attribute" for a
zero-sum change.  Not pressing, but certainly not a problem.
	But I'm still not understanding what you mean by "1 kobject for
the directory".  We have one kobject for the "logmask" directory, and
then attributes for each log type.  I don't see how that would change.
Are you suggesting that we move the log attributes up one level,
eliminating the "logmask" subdir?  That is, "/sys/fs/o2cb/logmask/DLM"
becomes "/sys/fs/o2cb/DLM"?  That won't work, because then "ls
/sys/fs/o2cb/logmask" is no longer a valid way to discover all the log
masks - "interface_revision" isn't a log mask :-)
	Or do you mean something else?

Joel

-- 

"To announce that there must be no criticism of them president, or
 that we are to stand by the president, right or wrong, is not only
 unpatriotic and servile, but is morally treasonable to the American
 public."
	- Theodore Roosevelt

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
