Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXGBOih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXGBOih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbXGBOi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:38:27 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:33511 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753844AbXGBOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:38:26 -0400
X-YMail-OSG: s8_I7z8VM1mklYkgmZCaoLdGyPOhmv754v4eVHGdIr2nrc.w40fNK3JEGIqrc2iP6hf97BVd4A--
Date: Mon, 2 Jul 2007 09:38:16 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
Message-ID: <20070702143816.GA17723@vino.hallyn.com>
References: <20070611123714.GA2063@sergelap.austin.ibm.com> <878322.98602.qm@web36606.mail.mud.yahoo.com> <afff21250706110926l244ddc28i44289cb08a6721e2@mail.gmail.com> <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467CD63B.4000703@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,

Regarding future/backward compatibility of file capabilities:

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----

...

> #define VFS_CAP_REVISION_MASK     0xFF000000
> #define VFS_CAP_REVISION          0x01000000
> 
> #define VFS_CAP_FLAGS_MASK        ~VFS_CAP_REVISION_MASK
> #define VFS_CAP_FLAGS_EFFECTIVE     0x000001
> 
> struct vfs_cap_data {
> 	__u32  magic_etc;
> 	struct {
>         	__u32 permitted;     /* Little endian */
> 	        __u32 inheritable;   /* Little endian */
>         } data[1];
> };

...

> 3) The cap_from_disk() interface checking needs some work.... Most
> notably, size must be greater than sizeof(u32) or the very first line
> will do something nasty... I'd recommend you use code like this:
> 
> [...] cap_from_disk(...)
> {
>    if (size != sizeof(struct vfs_cap_data)) {
> 	printk(KERN_WARNING "%s: invalid cap size %d for file %s\n",
> 	     __FUNCTION__, size, bprm->filename);
> 	return -EINVAL;
>    }
> 
>    switch ((version & VFS_CAP_REVISION_MASK)) {
>    case VFS_CAP_REVISION:
>         bprm->cap_effective = (version & VFS_CAP_FLAGS_EFFECTIVE)
> 		? CAP_FULL_SET : CAP_EMPTY_SET;
> 	bprm->cap_permitted =
> 		to_cap_t( le32_to_cpu(dcap->data[0].permitted) );
> 	bprm->cap_inheritable =
> 		to_cap_t( le32_to_cpu(dcap->data[0].inheritable) );
>         return 0;
>    default:
> 	return -EINVAL;
>    }
> }
> 
> Basically, I don't believe in designing a secure interface to be forward
> compatible - things never work out that way and the legacy you are
> implicitly committing to will haunt you in the future... FWIW I've known
> a few x86 MSR designers over the years and each one has made this
> mistake at least once... The future is uncertain, so don't trust it will
> look the way you want it to. ;-)

There are a few obvious approaches we can take:

1. Exactly Andrew describes.  Once userspace switches to a new cap
format, an older kernel simply won't support them

2. As Andrew describes, but also encode the version number into the
capability name, i.e. security.capability.v3.  Now userspace can
optionally tack on more than one capability version to be backward
compatible.

3. Somewhat different than Andrew describes.  We mandate that any
capability version N+1 consist of

struct vfs_cap_data {
	__u32 magic;
	capability_version_1;
	capability_version_2;
	...
	capability_version_N;
	capability_version_N+1;
};

Or, for brevity,

struct vfs_cap_data {
	__u32 first_magic;
	__u32 last_magic;
	capability_version_first;
	...
	capability_version_last;
};

4. Stick to the current plan, where switching to 64-bit caps will be
done as

struct vfs_cap_data_disk {
	__le32 version;
	__le32 data[]; /* eff[0], perm[0], inh[0], eff[1], ... */
};

What would people prefer?

thanks,
-serge
