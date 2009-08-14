Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZHNWCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZHNWCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZHNWCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:02:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37741 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZHNWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:02:31 -0400
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>, gregkh@susa.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	<4A84EF1D.8060408@schaufler-ca.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 14 Aug 2009 15:02:25 -0700
In-Reply-To: <4A84EF1D.8060408@schaufler-ca.com> (Casey Schaufler's message of "Thu\, 13 Aug 2009 21\:59\:09 -0700")
Message-ID: <m1my62xde6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: casey@schaufler-ca.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@susa.de, sds@tycho.nsa.gov, jmorris@namei.org, dpquigl@tycho.nsa.gov
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
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


>From a long term maintenance perspective I have to say I like Casey's
version that doesn't require any magic security module compression
hooks to implement this.

>From an implementation point of view Stephen's comments seem accurate.

Is there any debate that Casey's version will get the job done?

If not the only real question is how do we store xattrs efficiently for
in memory filesystems.  

Let me propose a different xattr compression scheme instead of making
the security module responsible for compression.

How about we have:
struct sysfs_xattr *sysfs_store_xattr(const char *name, const void *value, size_t size);
void sysfs_release_xattr(struct sysfs_xattr *xattr);

Where sysfs_xattr looks something like:
struct sysfs_xattr {
       struct hlist_node list;
       atomic_t count;
       const char *name;
       const void *value;
       size_t size;
}

And then at the end of of what is today s_iattr we have something like:
struct sysfs_xattr *xattrs[2];


The key point here is that sysfs_store_xattr will look to see in a
hash table to see if another inode/dentry has already stored the
specified xattr and if so increment the count of sysfs_xattr count
and return it.

My design assumption is that the set of xattrs that people want to
apply to filesystems is small.

By optimizing for a small number of distinct xattrs we keep the
storage size small (even for those filesystems who want to label
everything), and we keep the generality by not making storage of
xattrs a security module responsibility.

Does that sound like it will work?

Eric
