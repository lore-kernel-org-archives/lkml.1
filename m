Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbXFXP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbXFXP5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbXFXP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:57:45 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:40217 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755477AbXFXP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:57:43 -0400
X-YMail-OSG: mxFyJ8UVM1mMVCHlzkJvlkaLHT_Xmmbv6OqGf6DUJD2RzpyCoZaQRBiq77vlVYxOD.tfaL7WwsA4rwNqp51ovBaZSXZUiDboVWpt11sMQsCnWTTQFg--
Date: Sun, 24 Jun 2007 10:51:00 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
Message-ID: <20070624155100.GA5167@vino.hallyn.com>
References: <20070611123714.GA2063@sergelap.austin.ibm.com> <878322.98602.qm@web36606.mail.mud.yahoo.com> <afff21250706110926l244ddc28i44289cb08a6721e2@mail.gmail.com> <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467CD63B.4000703@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge,
> 
> [time passes]
> 
> I'm a little better up to speed on all the kernel now. I don't feel that
> I conceptually object so much to this patch-series any more.... :-)
> 
> I do, however, think the patch needs some work:
> 
> 1) As previously discussed, fE should be an all or nothing single bit:
> 
> How about?:
> 
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

I don't particularly mind, but can you point out any case where
it is an advantage to have the one bit for f'E rather than just
drop f'E altogether?  Instead of having

	f'I=something
	f'P=something
	f'E=off

we can always just remove the security.capability xattr.  Right?

If there's a case where that does not suffice, then I have no objection
to doing it this way.

> 2) Allocate capability bit-31 for CAP_SETFCAP, and use it to gate
> whether the user can set this xattr on a file or not. CAP_SYS_ADMIN is
> way too overloaded and this functionality is special.

The functionality is special, but someone with CAP_SYS_ADMIN can always
unload the capability module and create the security.capability xattr
using the dummy module.

If we do add this cap, do we want to make it apply to all security.*
xattrs?

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

Ok, so you're saying that when we do switch to 64-bit caps or some other
evolution, we switch to completely separate logic based on the
VFS_CAP_REVISION?

That seems sane to me.

> 5) I would rename 'set_file_caps' to 'get_file_caps' since this is what
> the function actually does. If you must use 'set' then call the function
> 'set_bprm_caps'.

set_bprm_caps actually sounds best to me.

> 6) I also don't see the value of explicitly zero'ing the capabilities
> (in cap_bprm_set_security()) only to override them elsewhere.
> 
> I'd move the 'cap_clear (bprm->cap_...)' code from
> cap_bprm_set_security() into the 'out:' code at the end of
> 'get_file_caps()' (sic). Put rc=0 at the top of the function, and
> replace the return 0; at the top of that function with a 'goto
> clear_out;' then replace the out: code as follows:
> 
>    out:
>        dput(dentry);
>        if ((void *)dcaps != (void *)&v1caps)
> 		kfree(dcaps);
>        if (rc) {
>        clear_out:
>   	        cap_clear (bprm->cap_inheritable);
>  	        cap_clear (bprm->cap_permitted);
>  	        cap_clear (bprm->cap_effective);
>        }
>        return rc;

Sounds sane.  If it looks less sane when I try to write the patch I'll
get back to you  :)

> 7) This one is subtle, and to my mind not well appreciated. In
> cap_bprm_apply_creds(), the wart of the global 'cap_bset' masking
> permitted bits can lead to problems like the one we saw a few years back
> with sendmail and capabilities. There is an assumption in setting
> permitted (they are called 'forced' in some documents) capabilities on a
> file that the file will execute with at least these. The inheritable
> ones are optional.

Hmm, changing the behavior of the cap_bset is something that seems to
belong in 8), though I see what you're saying, it does affect the
behavior of vfs caps.

One gets a cozy feeling from the fact that cap_bset is set to
(~0 & ~~CAP_TO_MASK(CAP_SETPCAP)), but since it's sysctl controllable
that seems like it could present a real security problem.

So yeah, I think you're right - but the question is whose word do we
take here?  The admin who set the vfs caps on the binary, or the admin
who set cap_bset through sysctl?

I wonder whether anyone actually uses the cap_bset sysctl...

> The long and the short of it is there needs to be a check somewhere that:
> 
>    current->cap_permitted is a superset of file->cap_permitted
> 
> That is, what cap_bset takes away, current->cap_inheritable gives back.
> If the above is not true, then the executable should fail to execute;
> - -EPERM. On the surface I don't see how to do this with the LSM framework
> because the relevant function is a 'void' one and can't return an error.
> 
> 8) There are a number of (massive) cleanups that I would like to see
> done, but they are more related to the non-file capabilities support in
> the kernel and I won't pollute this present discussion any more with those.
> 
> I hope that was helpful. FWIW I did set up a git repostitory on
> kernel.org to port my old patches, but in the process of porting them
> better understood what you had done. If you do the above I think I'd be
> happy to work from that...

If you have a list of such cleanups you could send out, we can then
decide whether those all are safe to apply to the current capability
module, or whether it makes sense to fork off a shiny new capabiltyv2
module :)

many thanks for all the suggestions,
-serge

> Cheers
> 
> Andrew
> 
> PS. If anyone is touching file with my transmeta email in them, feel
> free to replace them with the @kernel.org address.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
> 
> iD8DBQFGfNYwQheEq9QabfIRAgQ2AJ9q3+BgOPlZvTboqEyM3O845xKZOQCcCLQm
> zKVfemAw2F5h43rApDXuJ4o=
> =OJWn
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
