Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZGWGYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZGWGYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZGWGYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:24:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46309 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZGWGYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:24:15 -0400
Date: Thu, 23 Jul 2009 08:24:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] ceph: ioctls
Message-ID: <20090723062412.GA19207@basil.fritz.box>
References: <1248292313-31326-11-git-send-email-sage@newdream.net> <1248292313-31326-12-git-send-email-sage@newdream.net> <1248292313-31326-13-git-send-email-sage@newdream.net> <1248292313-31326-14-git-send-email-sage@newdream.net> <1248292313-31326-15-git-send-email-sage@newdream.net> <1248292313-31326-16-git-send-email-sage@newdream.net> <1248292313-31326-17-git-send-email-sage@newdream.net> <1248292313-31326-18-git-send-email-sage@newdream.net> <878wig2vhe.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907221636260.8312@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907221636260.8312@cobra.newdream.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 04:52:40PM -0700, Sage Weil wrote:
> On Thu, 23 Jul 2009, Andi Kleen wrote:
> > Sage Weil <sage@newdream.net> writes:
> > 
> > > A few Ceph ioctls for getting and setting file layout (striping)
> > > parameters.
> > 
> > It would be good if you posted manpages for these ioctls
> > so that the interface can be reviewed. After all
> > that's intended to be used by applications, isn't it?
> 
> Is there some existing manpage I might use as a reference?  e.g., an XFS 
> ioctl manpage or something similar?

For documenting an ioctl? The tcp(7) manpages perhaps

> I'm also happy to replace these ioctls with a virtual xattr interface 
> along the lines of what Andreas proposed.  That would make it much easier 
> to maintain compatibility if the support layout parameters changes 
> going forward.

I personally don't have a problem with them being ioctls, assuming
the interface is relatively sane. I haven't reviewed that 
in detail, mostly because it's in a different patch (but it shouldn't be)

That's where the man pages would come in.

There used to be a strong "all ioctls are evil" ideology camp a few years back,
but I think those people definitely lost a lot of influence recently
and we're back to a pragmatic "where it makes sense" position.
 
> 
> > There don't seem to be compat ioctl handlers?
> 
> Oops,

Well the question is if it works, e.g. if the layout
is the same 32bit and 64bit. From a quick look the
structure seems to only contain __s32 so it might be ok.

I'm not sure what __attribute__((packed)) will do over all
the obscure architectures though.

What I find more suspicious is that it's the direct network
data structure. Presumably that's in a defined endian?
So that means the application would already need to 
change to network endian order at the ioctl level?

That seems wrong if true. I think defining
a ioctl directly based on a network protocol header is 
likely a bad idea.

> 
> diff --git a/src/kernel/file.c b/src/kernel/file.c
> index fbf02c3..fbb5f94 100644
> --- a/src/kernel/file.c
> +++ b/src/kernel/file.c
> @@ -810,5 +810,8 @@ const struct file_operations ceph_file_fops = {
>         .splice_read = generic_file_splice_read,
>         .splice_write = generic_file_splice_write,
>         .unlocked_ioctl = ceph_ioctl,
> +#ifdef CONFIG_COMPAT
> +       .compat_ioctl   = ceph_ioctl,
> +#endif

You don't need the ifdef.

> > How should the application use that if the include file is in fs/ceph?
> > Should be in include/linux I guess
> > 
> > Also this file should define all the types needed for the interface,
> > especialy struct ceph_file_layout, but no kernel internal types.
> 
> The type is defined in ceph_fs.h, which is shared/synced with the userland 
> code.  It's not specific to the ioctl interface.

I don't think applications should include the whole networking
protocol to use an ioctl. You should split that.

> 
> My understanding (IIRC after reading comments from a recent fs merge) was 
> that these sorts of headers normally shouldn't go in include/linux, since 
> any userland (admin) progs will have their own version anyway while being 
> built, and may not be synced with the installed kernel. 

I don't think that's the normal case, no. ioctls are usually 
gotten from include/linux still, although a preprocessed
version of it (mostly unifdefed and the include file has to be 
especially exported)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
