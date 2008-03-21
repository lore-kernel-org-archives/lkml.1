Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbYCUQfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbYCUQfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbYCUQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:35:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48035 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbYCUQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:35:23 -0400
Date: Fri, 21 Mar 2008 16:35:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org
Subject: Re: r-o bind in nfsd
Message-ID: <20080321163520.GV10722@ZenIV.linux.org.uk>
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu> <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 05:24:11PM +0100, Miklos Szeredi wrote:
> > > I know there are a few cases, where filesystems call vfs_foo()
> > > internally, where the vfsmount isn't available, but I think the proper
> > > solution is just to fix those places, and not recurse back into the
> > > VFS (which is AFAICS in all those cases totally unnecessary anyway).
> > > This would make everybody happy, no?
> > 
> > Apparmor can go play with itself.  The proper fix is to lift the LSM nonsense
> > into callers and leave vfs_...() alone;
> 
> Maybe.  I know precious little about this security thing, so I won't
> argue about it's merits or faults.  But:
> 
>  a) I have a hunch that the security guys wouldn't like to see the
>  order between permission() and security_foo() changed.

It's their problem.  Adjusting LSM methods, if needed, is up to LSM
maintainers, whenever moving the hooks or code around those become
convenient for kernel proper.  According to Linus, IIRC.

Especially since in this case they want to change prototypes anyway, so the
churn is not an issue and having the hook called earlier is very unlikely to
cause any problems.

>  b) I fail to see how moving functionality to callers would improve
>  things
> 
> > vfsmounts should *not* be passed there at all, with the exception of
> > vfs_follow_link() which gets the full nameidata.
> 
> Why?

Because filesystem shouldn't _care_ where it is mounted.  Anything
vfsmount-dependent belongs to upper layers.  The same goes for passing
nameidata to fs methods, BTW - again, ->follow_link() is an obvious
legitimate exception.
