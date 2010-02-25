Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab0BYUij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:38:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933362Ab0BYUih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:38:37 -0500
Date: Thu, 25 Feb 2010 15:38:35 -0500
From: Josef Bacik <josef@redhat.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
Message-ID: <20100225203834.GD10960@localhost.localdomain>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com> <20100225202358.GC10960@localhost.localdomain> <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 03:29:34PM -0500, Andrew Lutomirski wrote:
> On Thu, Feb 25, 2010 at 3:23 PM, Josef Bacik <josef@redhat.com> wrote:
> > On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
> >> Mounting btrfs corrupts memory and causes nasty crashes within a few
> >> seconds.  This seems to happen even if the mount fails (note the
> >> unrecognized mount option).  This is a regression from 2.6.32, and
> >> I've attached an example.
> >>
> >
> > And it only happens when you mount a btrfs fs?  Can you show me a trace of when
> > you mount a btrfs fs with valid mount options?  I'd like to see if we're not
> > cleaning up something properly or what.  Thanks,
> 
> Seems OK.  Or maybe I just got lucky, but it's crashed every time I
> tried to mount with 'acl' before.
> 
> I even went through a couple iterations of trying to mount with
> 'xattr' and 'user_xattr', both of which failed.
> 

Ok it looks like we have a problem kfree'ing the wrong stuff.  we kstrdup the
options string, but then strsep screws with the pointer, so when we kfree() it,
we're not giving it the right pointer.  Please try this patch, and mount with -o
acl and other such garbage to make sure it actually worked (acl isn't a valid
mount option btw).  Let me know if it works.  Thanks,

Josef


diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8a1ea6e..f8b4521 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -128,7 +128,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
-	char *p, *num;
+	char *p, *num, *orig;
 	int intarg;
 	int ret = 0;
 
@@ -143,6 +143,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	if (!options)
 		return -ENOMEM;
 
+	orig = options;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -280,7 +281,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		}
 	}
 out:
-	kfree(options);
+	kfree(orig);
 	return ret;
 }
 
