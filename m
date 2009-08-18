Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbZHRHjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbZHRHjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZHRHjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:39:06 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:58964 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZHRHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:39:03 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Amerigo Wang <amwang@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
	<20090817071011.5913.69970.sendpatchset@localhost.localdomain>
	<1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>
	<87prau5ld1.fsf@devron.myhome.or.jp>
	<1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>
	<873a7q441a.fsf@devron.myhome.or.jp>
	<1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil>
	<87fxbq19qs.fsf@devron.myhome.or.jp>
	<87my5yxidt.fsf@devron.myhome.or.jp>
Date: Tue, 18 Aug 2009 16:39:00 +0900
In-Reply-To: <87my5yxidt.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue, 18 Aug 2009 06:03:42 +0900")
Message-ID: <87y6pha7vv.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry if this killed thread. My ISP seems to be stopping email server
now. I've read this email from web archive.]

>> @@ -2711,12 +2711,17 @@ static int selinux_inode_permission(stru
>>  static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
>>  {
>>  	const struct cred *cred = current_cred();
>> +	unsigned int ia_valid = iattr->ia_valid;
>>  
>> -	if (iattr->ia_valid & ATTR_FORCE)
>> -		return 0;
>> +	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
>> +	if (ia_valid & ATTR_FORCE) {
>> +		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_MODE);
>> +		if (!ia_valid)
>> +			return 0;
>>   
> 
> So if I read this correctly, (ATTR_FORCE| ATTR_KILL_SUID|ATTR_MODE) will 
> not return here, since 'ia_valid' will be ATTR_FORCE finally.
> 
> I think you forgot to clear ATTR_FORCE here...

Whoops, good catch. Fortunately, it doesn't seem to have actual problem,
but it's bug obviously, and sorry for that. Fixed patch was attached.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


[PATCH] selinux: adjust rules for ATTR_FORCE

From: Amerigo Wang <amwang@redhat.com>

As suggested by OGAWA Hirofumi in thread: http://lkml.org/lkml/2009/8/7/132,
we should let selinux_inode_setattr() to match our ATTR_* rules.
ATTR_FORCE should not force things like ATTR_SIZE.

Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
[tweaks]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 security/selinux/hooks.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN security/selinux/hooks.c~selinux-truncate-fix security/selinux/hooks.c
--- linux-2.6/security/selinux/hooks.c~selinux-truncate-fix	2009-08-18 06:27:58.000000000 +0900
+++ linux-2.6-hirofumi/security/selinux/hooks.c	2009-08-18 16:10:50.000000000 +0900
@@ -2711,12 +2711,18 @@ static int selinux_inode_permission(stru
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	const struct cred *cred = current_cred();
+	unsigned int ia_valid = iattr->ia_valid;
 
-	if (iattr->ia_valid & ATTR_FORCE)
-		return 0;
+	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
+	if (ia_valid & ATTR_FORCE) {
+		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_MODE |
+			      ATTR_FORCE);
+		if (!ia_valid)
+			return 0;
+	}
 
-	if (iattr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
-			       ATTR_ATIME_SET | ATTR_MTIME_SET))
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
+			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
 		return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
 
 	return dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
_
