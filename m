Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXGDTat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXGDTat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXGDTal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:30:41 -0400
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:20509 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755109AbXGDTak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:30:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=IzXRyw+OkS/hnvC3HDaMFvH8Gclvp4L/wiiqV/Og49OtFgpIoFASEGwPlxOjkCczZbcGFr7bQVG4Gudp5bsvpXG4Pn7p+Z8puoexblr/8bfMDt/57arRrqUDt5TSdF+tTvvLFhKkjmAyhfbXzdqHUcnZPW01krF2BGNfbeytgXA=  ;
X-YMail-OSG: Wod..iMVM1lOmTyZ7CTbOz_uW0b5AuprjeSIhzBFnb4GoiesTSWO0wgI8RvhgEJ0lxTTxgREVA--
Date: Wed, 4 Jul 2007 21:30:24 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: fix error handling in ext4_create_journal
Message-ID: <20070704193024.GA6802@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070701221111.GA8627@gollum.tnic> <20070703152543.e58ad39a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070703152543.e58ad39a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 03:25:43PM -0700, Andrew Morton wrote:

> Please prepare the equivalent patch for ext4.  Without that, it'd probably
> be better to avoid applying the ext3 patch: there are advantages to keeping
> the two in sync where possible.

Hi Andrew,

   here you go. By the way, this one is with generated diffstat. Do you prefer
   it that way or is a diffstat for a patch touching a single file too much?

-----
From: Borislav Petkov <bbpetkov@yahoo.de>

Fix error handling in ext4_create_journal according to kernel conventions.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

---
 linux-2.6.22-rc7/fs/ext4/super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc7/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc7/fs/ext4/super.c.orig	2007-07-04 21:18:24.000000000 +0200
+++ linux-2.6.22-rc7/fs/ext4/super.c	2007-07-04 21:19:46.000000000 +0200
@@ -2150,6 +2150,7 @@
 			       unsigned int journal_inum)
 {
 	journal_t *journal;
+	int err;
 
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT4-fs: readonly filesystem when trying to "
@@ -2157,13 +2158,15 @@
 		return -EROFS;
 	}
 
-	if (!(journal = ext4_get_journal(sb, journal_inum)))
+	journal = ext4_get_journal(sb, journal_inum);
+	if (!journal)
 		return -EINVAL;
 
 	printk(KERN_INFO "EXT4-fs: creating new journal on inode %u\n",
 	       journal_inum);
 
-	if (jbd2_journal_create(journal)) {
+	err = jbd2_journal_create(journal);
+	if (err) {
 		printk(KERN_ERR "EXT4-fs: error creating journal.\n");
 		jbd2_journal_destroy(journal);
 		return -EIO;
-- 
Regards/Gruﬂ,
    Boris.
