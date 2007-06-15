Return-Path: <linux-kernel-owner+w=401wt.eu-S1750997AbXFORDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbXFORDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbXFORDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:03:01 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55442 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbXFORC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:02:58 -0400
Date: Fri, 15 Jun 2007 09:50:54 -0700
From: Greg KH <greg@kroah.com>
To: Crispin Cowan <crispin@novell.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070615165054.GA11345@kroah.com>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466C303E.5010304@novell.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 10:09:18AM -0700, Crispin Cowan wrote:
> Andreas Gruenbacher wrote:
> > On Saturday 09 June 2007 02:17, Greg KH wrote:
> >   
> >> On Sat, Jun 09, 2007 at 12:03:57AM +0200, Andreas Gruenbacher wrote:
> >>     
> >>> AppArmor is meant to be relatively easy to understand, manage, and
> >>>  customize, and introducing a labels layer wouldn't help these goals.
> >>>       
> >> Woah, that describes the userspace side of AA just fine, it means
> >> nothing when it comes to the in-kernel implementation. There is no 
> >> reason that you can't implement the same functionality using some
> >> totally different in-kernel solution if possible.
> >>     
> > I agree that the in-kernel implementation could use different abstractions 
> > than user-space, provided that the underlying implementation details can be 
> > hidden well enough. The key phrase here is "if possible", and in fact "if 
> > possible" is much too strong: very many things in software are possible, 
> > including user-space drives and a stable kernel module ABI. Some things make 
> > sense; others are genuinely bad ideas while still possible.
> >   
> In particular, to layer AppArmor on top of SELinux, the following
> problems must be addressed:
> 
>     * New files: when a file is created, it is labeled according to the
>       type of the creating process and the type of the parent directory.
>       Applications can also use libselinux to use application logic to
>       relabel the file, but that is not 'mandatory' policy, and fails in
>       cases like cp and mv. AppArmor lets you create a policy that e..g
>       says "/home/*/.plan r" to permit fingerd to read everyone's .plan
>       file, should it ever exist, and you cannot emulate that with SELinux.

A daemon using inotify can "instantly"[1] detect this and label the file
properly if it shows up.

>     * Renamed Files: Renaming a file changes the policy with respect to
>       that file in AA. To emulate this in SELinux, you would have to
>       have a way to instantly re-label the file upon rename.

Same daemon can do the re-label.

>     * Renamed Directory trees: The above problem is compounded with
>       directory trees. Changing the name at the top of a large, bushy
>       tree can require instant relabeling of millions of files.

Same daemon can do this.  And yes, it might take a ammount of time, but
the times that this happens in "real-life" on a "production" server is
quite small, if at all.

>     * New Policies: The SEEdit approach of compiling AA profiles into
>       SELinux labels involves computing the partition set of files, so
>       that each element of the partition set is unique, and corresponds
>       to all the policies that treat every file in the element
>       identically. If you create a new profile that touches *some* of
>       the files in such an element, then you have to split that
>       synthetic label, re-compute the partition set, and re-label the
>       file system.

Again, same daemon can handle this logic.

>     * File Systems That Do Not Support Labels: The most important being
>       NFS3 and FAT. Because they do not support labels at all, SELinux
>       has to give you an all-or-nothing access control on the entire
>       remote volume. AA can give you nuanced access control in these
>       file systems.

SELinux already provides support for the whole mounted filesystem,
which, in real-life testing, seems to be quite sufficient.  Also, the
SELinux developers are working on some changes to make this a bit more
fine-grained.

See also Stephan's previous comments about NFSv3 client directories and
multiple views having the potential to cause a lot of havoc.

> You could support all of these features in SELinux, but only by adding
> an in-kernel file matching mechanism similar to AppArmor.

I don't think that is necessary at all, see above for why.

> It would basically load an AppArmor policy into the kernel, label
> files as they are brought from disk into the cache, and then use
> SELinux to do the access controls.

No, do the labeling in userspace with a daemon using inotify to handle
the changing of the files around.

Or has this whole idea of a daemon been disproved already with a
prototype somewhere that failed?  If not, a simple test app would not be
that hard to hack up.  Maybe I'll see if I can do it during the week of
June 24 :)

thanks,

greg k-h
