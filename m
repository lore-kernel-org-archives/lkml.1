Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYJOUO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYJOUO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYJOUOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:14:03 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57016 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbYJOUOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:14:00 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, bnaujok@sgi.com
Subject: Re: [PATCH 6/6] vfs: add LOOKUP_RENAME_NEW intent
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	<524881153e848f5f6f3426623.ps@mail.parknet.co.jp>
	<f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp>
	<a9ddfd693e848f5f6f3626623.ps@mail.parknet.co.jp>
	<20081015193716.GA22707@infradead.org>
Date: Thu, 16 Oct 2008 05:13:54 +0900
In-Reply-To: <20081015193716.GA22707@infradead.org> (Christoph Hellwig's
	message of "Wed, 15 Oct 2008 15:37:16 -0400")
Message-ID: <87r66hpqf1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Oct 15, 2008 at 10:58:11PM +0900, OGAWA Hirofumi wrote:
>> 
>> This adds LOOKUP_RENAME_NEW intent for lookup of rename destination.
>> 
>> LOOKUP_RENAME_NEW is going to be used like LOOKUP_CREATE. But since
>> the destination of rename() can be existing directory entry, so it has a
>> difference. Although that difference doesn't matter in my usage, this
>> tells it to user of this intent.
>
> Is this for handling CI rename properly?  Barry was looking into this,

Exactly, it is for some kind of CI rename workaround.

> but i told him to hold off for a while - the lookup code is changing
> quite a bit because Al is trying to sort out the lookup intent mess and
> we hopefully will stop passing the nameidata to ->lookup soon.

Umm.. however the intent for ->lookup() is useful for optimization in
some case?

> Also I think LOOKUP_RENAME_TARGET might be a little more descriptive
> than LOOKUP_RENAME_NEW.

It is the name which namei.c is using, anyway I don't care at all.
I'll take it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


[PATCH] vfs: add LOOKUP_RENAME_TARGET intent

This adds LOOKUP_RENAME_TARGET intent for lookup of rename destination.

LOOKUP_RENAME_TARGET is going to be used like LOOKUP_CREATE. But since
the destination of rename() can be existing directory entry, so it has a
difference. Although that difference doesn't matter in my usage, this
tells it to user of this intent.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/namei.c            |    1 +
 include/linux/namei.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/namei.c~dcache-add-rename-intent fs/namei.c
--- linux-2.6/fs/namei.c~dcache-add-rename-intent	2008-10-15 20:35:24.000000000 +0900
+++ linux-2.6-hirofumi/fs/namei.c	2008-10-16 05:06:53.000000000 +0900
@@ -2660,6 +2660,7 @@ asmlinkage long sys_renameat(int olddfd,
 
 	oldnd.flags &= ~LOOKUP_PARENT;
 	newnd.flags &= ~LOOKUP_PARENT;
+	newnd.flags |= LOOKUP_RENAME_TARGET;
 
 	trap = lock_rename(new_dir, old_dir);
 
diff -puN include/linux/namei.h~dcache-add-rename-intent include/linux/namei.h
--- linux-2.6/include/linux/namei.h~dcache-add-rename-intent	2008-10-15 20:35:24.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/namei.h	2008-10-16 05:07:15.000000000 +0900
@@ -53,6 +53,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
  */
 #define LOOKUP_OPEN		(0x0100)
 #define LOOKUP_CREATE		(0x0200)
+#define LOOKUP_RENAME_TARGET	(0x0400)
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 
_
