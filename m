Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbZHOBom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbZHOBom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 21:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZHOBoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 21:44:39 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:41027 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755517AbZHOBoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 21:44:39 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 1r4w4wAVM1kVMthRnp3e5kqEwyICpgBFNiqsquANT5EsVJNWCFKk.XX6aa5gUzrFz_DmiLa1BX2Rgg8SHCoYNVWgfq_YIlQROdfHtW7mowfef253HKkBi55TCMxbjKYW3HLZwNVf0tW7ea10MUjEgkdprLRb3WTvQCe.k3llt_7tIx1db8237yfj3ok1H5vRZumict07fdqeuFtxnPcTypBJHJf6cStr9sq7kGq0eUJBgd_SjAg9wj7epphu8BOj7fv_lsI6IYvd2BVN7vCR9OfId2XMoRdRxu_qIvrp
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A861291.1030404@schaufler-ca.com>
Date: Fri, 14 Aug 2009 18:42:41 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>, gregkh@susa.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	<4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>
In-Reply-To: <m1my62xde6.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> >From a long term maintenance perspective I have to say I like Casey's
> version that doesn't require any magic security module compression
> hooks to implement this.
>   

Thank you.

> >From an implementation point of view Stephen's comments seem accurate.
>   

They usually are.

> Is there any debate that Casey's version will get the job done?
>   

There may be from the SELinux side because they have a specific
behavior that they want for sysfs that is not strictly in touch
with the usual xattr behavior.

> If not the only real question is how do we store xattrs efficiently for
> in memory filesystems.  
>   

Actually, I see that as a justification for the special purpose
scheme rather than a real issue. The real attribute data is going
to take up the same amount of space regardless of how it gets
managed. And Stephen is correct in thinking that is most cases
where there are xattrs there will be only one. I don't see that
a mechanism more elaborate than a list is going to gain much in
real life. On the other hand, if you wanted to take the ball and
run with it, I have a window manager to deal with.

> Let me propose a different xattr compression scheme instead of making
> the security module responsible for compression.
>
> How about we have:
> struct sysfs_xattr *sysfs_store_xattr(const char *name, const void *value, size_t size);
> void sysfs_release_xattr(struct sysfs_xattr *xattr);
>
> Where sysfs_xattr looks something like:
> struct sysfs_xattr {
>        struct hlist_node list;
>        atomic_t count;
>        const char *name;
>        const void *value;
>        size_t size;
> }
>
> And then at the end of of what is today s_iattr we have something like:
> struct sysfs_xattr *xattrs[2];
>
>
> The key point here is that sysfs_store_xattr will look to see in a
> hash table to see if another inode/dentry has already stored the
> specified xattr and if so increment the count of sysfs_xattr count
> and return it.
>
> My design assumption is that the set of xattrs that people want to
> apply to filesystems is small.
>
> By optimizing for a small number of distinct xattrs we keep the
> storage size small (even for those filesystems who want to label
> everything), and we keep the generality by not making storage of
> xattrs a security module responsibility.
>
> Does that sound like it will work?
>
> Eric
>
>
>   

