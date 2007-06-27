Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbXF0NRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbXF0NRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbXF0NRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:17:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35482 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbXF0NQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:16:58 -0400
Date: Wed, 27 Jun 2007 08:16:54 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
Message-ID: <20070627131654.GA2679@sergelap>
References: <afff21250706110926l244ddc28i44289cb08a6721e2@mail.gmail.com> <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <4681EED8.6050005@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4681EED8.6050005@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge E. Hallyn wrote:
> > 
> >> I don't particularly mind, but can you point out any case where
> >> it is an advantage to have the one bit for f'E rather than just
> >> drop f'E altogether?  Instead of having
> > 
> >> 	f'I=something
> >> 	f'P=something
> >> 	f'E=off
> > 
> >> we can always just remove the security.capability xattr.  Right?
> 
> No. Bear in mind that capabilities are all about trusting specific
> applications with privilege as opposed to trusting the superuser to not
> run dangerous applications.
> 
> There are three situations, we'll take them in turn:
> 
>   - no capabilities (fP=fI=fE=0): this is for applications that are not
> intended to operate with privilege. Because of the way the capability
> convolution rules work, such a program can't execute with privilege. Period.

(Except that in Linux, with SECURE_NOROOT=0, root will be able to.  With
SECURE_NOROOT=y it won't.)

>   - with capabilities (fP and/or fI != 0), but fE=0 (off): this is for
> applications that are intended to operate with privilege, but they were
> designed to know about capabilities and they manipulate (raise and
> lower) capabilities as needed to do the things they do.
> 
>   - with capabilities, but fE=1 (on): this is a class of applications
> loosely called 'legacy'. They can use privilege to operate, but don't
> strictly need to know about it. For example, /bin/chown . Such a program
> will have fP=0,fI=CAP_CHOWN. Since the administrator sets
> fP=0,fI=CAP_CHOWN,fE=1 on the /bin/chown file, any process with
> CAP_CHOWN in its inheritable set (pI) can "exec /bin/chown" and have it
> do the thing historically reserved for the superuser...
> 
> In some future world, the legacy fE bit may become unnecessary because
> every application will be rewritten to be careful about exercising
> privilege explicitly. In the meantime, the fE bit can be used to drop
> the setuid-0 bits from things like ping and traceroute.
> 
> >> If there's a case where that does not suffice, then I have no objection
> >> to doing it this way.
> 
> Does that explain it?

Yes, thanks, but then it still could come in handy to have fE be a full
bitset, so the application gets some eff caps automatically, while
others it has to manually set...

> > 2) Allocate capability bit-31 for CAP_SETFCAP, and use it to gate
> > whether the user can set this xattr on a file or not. CAP_SYS_ADMIN is
> > way too overloaded and this functionality is special.
> > 
> >> The functionality is special, but someone with CAP_SYS_ADMIN can always
> >> unload the capability module and create the security.capability xattr
> >> using the dummy module.
> 
> This argument leads down a rat hole. (As appears to have happened with
> the non-modularization LSM thread elsewhere...)
> 
> The simple fact is that CAP_SYS_ADMIN is equivalent to every other
> capability in the system if it can be used to load any flavor of kernel
> module. Arguing that you don't need a capability for something because
> you can do it with CAP_SYS_ADMIN is very close to admitting that you
> prefer the superuser (uid=0) model.

Well no, it could also just be acknowledging that at some point some
better cap breakup should be attempted, though of course some amount of
"these caps can subvert that cap" will always be there.

But I'm not actually objecting  :)  I expect this will be the first of
the patches I whip up.

> >> If we do add this cap, do we want to make it apply to all security.*
> >> xattrs?
> 
> I recommend limiting it to just capabilities.
> 
> For now, you can leave the other security attributes with the
> CAP_SYS_ADMIN ("misc") capability. In the original 'POSIX' drafts, there
> is a separate notion of advisory and mandatory access control;
> leveraging different capabilities to override.
> 
> > 3) The cap_from_disk() interface checking needs some work.... Most
> > notably, size must be greater than sizeof(u32) or the very first line
> > will do something nasty... I'd recommend you use code like this:
> > 
> > [...] cap_from_disk(...)
> > {
> >    if (size != sizeof(struct vfs_cap_data)) {
> [...]
> > mistake at least once... The future is uncertain, so don't trust it will
> > look the way you want it to. ;-)
> > 
> >> Ok, so you're saying that when we do switch to 64-bit caps or some other
> >> evolution, we switch to completely separate logic based on the
> >> VFS_CAP_REVISION?
> 
> Yes.
> 
> >> That seems sane to me.
> 
> You might also want to verify that unallocated bits hold the value
> 'zero'. Its funny what people do when they realize they can silently
> store bits in obscure places like this. That really messes up allocating
> bits in the future. Add a check that is something like:
> 
>   if (version & ~(VFS_CAP_REVISION_MASK|VFS_CAP_FLAGS_EFFECTIVE)) {
>       return -EINVAL;
>   }

I used to do that (except with a stupid loop), but let's say you update
your distro, but the updated kernel has a problem.  So you boot into an
older kernel.  But the distro update added a new capability.  Now
nothing runs with privilege.

Or are you saying that we would name the xattrs
'security.capability.vN', and with each capability we add bump N, so
that after we've added 5 capabilities, each binary carries with it 5
xattrs, security.capability.v1 through security.capability.v5?

> > 7) This one is subtle, and to my mind not well appreciated. In
> > cap_bprm_apply_creds(), the wart of the global 'cap_bset' masking
> > permitted bits can lead to problems like the one we saw a few years back
> > with sendmail and capabilities. There is an assumption in setting
> > permitted (they are called 'forced' in some documents) capabilities on a
> > file that the file will execute with at least these. The inheritable
> > ones are optional.
> > 
> >> Hmm, changing the behavior of the cap_bset is something that seems to
> >> belong in 8), though I see what you're saying, it does affect the
> >> behavior of vfs caps.
> 
> I'm not really changing the behavior of cap_bset. I'm specifying the
> behavior of fP. ;-)
> 
> [Your comments on cap_bset and CAP_SETPCAP are exactly where my
> ax^H^H^Hscalpel will fall after all this VFS support is stable. But
> *that* is a subject for a different thread... aka item 8.]
> 
> >> So yeah, I think you're right - but the question is whose word do we
> >> take here?  The admin who set the vfs caps on the binary, or the admin
> >> who set cap_bset through sysctl?
> 
> The former.

Well how about I whip up the patch (when time permits) and see if anyone
complains  :)

thanks,
-serge
