Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZGMQvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZGMQvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZGMQvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:51:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49729 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZGMQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:51:02 -0400
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov,
       Casey Schaufler <casey@schaufler-ca.com>,
       <linux-kernel@vger.kernel.org>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	<m1r5wmnee0.fsf@fess.ebiederm.org>
	<1247498399.4398.259.camel@localhost>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 13 Jul 2009 09:50:54 -0700
In-Reply-To: <1247498399.4398.259.camel@localhost> (David P. Quigley's message of "Mon\, 13 Jul 2009 11\:19\:59 -0400")
Message-ID: <m1zlb8a5n5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: dpquigl@tycho.nsa.gov, linux-kernel@vger.kernel.org, casey@schaufler-ca.com, sds@tycho.nsa.gov, gregkh@suse.de, jmorris@namei.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"David P. Quigley" <dpquigl@tycho.nsa.gov>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs files, directories, and symlinks.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Taking the conversation back on the list.

"David P. Quigley" <dpquigl@tycho.nsa.gov> writes:

> On Sun, 2009-07-12 at 07:51 -0700, Eric W. Biederman wrote:
>> "David P. Quigley" <dpquigl@tycho.nsa.gov> writes:
>> 
>> > This patch adds a setxattr handler to the file, directory, and symlink
>> > inode_operations structures for sysfs. This handler uses two new LSM hooks. The
>> > first hook takes the xattr name and value and turns the context into a secid.
>> > This is embedded into the sysfs_dirent structure so it remains persistent even
>> > if the inode structures are evicted from the cache. The second hook allows for
>> > the secid to be taken from the sysfs_dirent and be pushed into the inode
>> > structure as the actual secid for the inode.
>> >
>> > This patch addresses an issue where SELinux was denying KVM access to the PCI
>> > configuration entries in sysfs. The lack of setxattr handlers for sysfs
>> > required that a single label be assigned to all entries in sysfs. Granting KVM
>> > access to every entry in sysfs is not an acceptable solution so fine grained
>> > labeling of sysfs is required such that individual entries can be labeled
>> > appropriately.
>> 
>> You are talking about write access from KVM?
>> 
>> How can direct hardware access to something that can do arbitrary
>> DMAs be secure?
>
> The bug in question is listed below.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=499259

I see a discussion, but no discuss of the security of direct hardware
access of a DMA capable device.

>> > diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
>> > index 3fa0d98..732d183 100644
>> > --- a/fs/sysfs/sysfs.h
>> > +++ b/fs/sysfs/sysfs.h
>> > @@ -57,6 +57,7 @@ struct sysfs_dirent {
>> >  	ino_t			s_ino;
>> >  	umode_t			s_mode;
>> >  	struct iattr		*s_iattr;
>> > +	u32			s_secid;
>> >  };
>> 
>> Could you please expand s_iattr and store the secid there?
>> That is where all of the rest of the security information is
>> stored in sysfs.
>
> I'm sorry but doing that would make the security labels first class
> attributes. It was decided a long time ago that security labels are
> stored in xattrs and as such don't belong in the iattr structure. I
> tried placing the label in the iattr structure for the Labeled NFS code
> and Christoph told me to do it another way since he didn't find that
> approach acceptable. I'm assuming his response will be the same for a
> secid which is supposed to be very sparingly used outside of the
> security module.

What I mean is something like:

struct sysfs_iattr {
	struct iattr	s_iattr;
        u32		s_secid;
};

struct sysfs_dirent {
...
	ino_t		s_ino;
        umode_t		s_mode;
        struct sysfs_inode_attr	*s_iattr;
};

The point is to simply allocate all of this optional stuff together,
and not use two fields in sysfs_dirent.

sysfs by default keeps a very sparse inode because it can assume
default values for all of the fields, and only bothers to keep
the extra fields when someone changes things explicitly.  Like your
xattrs, the uid or the gid.

>> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> > index 2081055..395c36d 100644
>> > --- a/security/selinux/hooks.c
>> > +++ b/security/selinux/hooks.c
>> > @@ -448,6 +448,10 @@ static int sb_finish_set_opts(struct super_block *sb)
>> >  	    sbsec->behavior > ARRAY_SIZE(labeling_behaviors))
>> >  		sbsec->flags &= ~SE_SBLABELSUPP;
>> >  
>> > +	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
>> > +	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
>> > +		sbsec->flags |= SE_SBLABELSUPP;
>> 
>> What is this about?  My impression is that if we have generic xattr
>> handling sysfs is not special so why do we have a special case?
>> 
>> Is this interface appropriate for dealing with xattrs to all
>> linux virtual filesystmes similar to sysfs that do not currently
>> implement xattrs. aka debugfs, proc, etc?
>
> Even though sysfs has a setxattr handler the labeling behavior with
> respect to SELinux needs special handling. The idea here is that by
> default sysfs will be labeled across the board with the same label. The
> reason we can't use a normal style xattr handler here is because there
> is no original backing store to pull the label from. Only after a label
> has been changed is there a semi-persistent value that can be used for
> reinstantiating the inode in the case that it is pruned from the cache.
> Otherwise it falls back to the base genfs labeling of sysfs entries as
> sysfs_t.

Sounds like we want a mount option or the like here.  Something explicit
in sysfs not something explicit in the security module.

I am also a bit dubious about 


> Proc also has some special case handling in the SELinux module but I
> haven't had a chance to look at it and try to understand why. I don't
> think that this would be a general purpose solution for all pseudo file
> systems like you mentioned above but it may work for some of them. I'll
> look into them a bit more and then respond about them.

Sounds good.  If we are going to expand the LSM it would be good to design
something decent instead of adding a nasty add-hoc case.

And on a silly note.  Rumor has it that selinux has provable security.
If so what impact does this change make to the proofs?

Eric
