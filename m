Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZBZEys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZBZEys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZBZEyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:54:38 -0500
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:64634 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZBZEyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:54:38 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/8] Aufs2 documents 
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil>
References: <7558.1235374266@jrobl> <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil>
Date: Thu, 26 Feb 2009 13:54:22 +0900
Message-ID: <7390.1235624062@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"David P. Quigley":
> I think it would be useful to see the source code for AUFS2 posted to
> LKML. One of the questions I have not which doesn't seem to be addressed
> in these documents is how robust is your xattr support and are you
> making the appropriate LSM calls to make this usable with SELinux and
> Smack. Also from a labeling perspective you have a very interesting
> question of which label do you select when unifying directories. If you
> have a/foo and b/foo each with different labels which do you choose.
> Based on the history of Union type file systems I would suspect the
> answer is whichever branch is listed first. 

Aufs doesn't support xattr curretnly because I don't decide how to
support it yet.
As far as I know, the implementation of xattr and its key/name pairs are
filesystem dependent. For instance,
- there are two branches (rw and ro) in aufs and their filesystem type
  differs from each other.
- an application issues getxattr() or listxattr() and makes sure
  "key.brabra" exists (or set).
- and then it issues setxattr() for "key.brabra".
- aufs will copies-up the file and tries setxattr() for the upper one.
- I am afraid there may happen "key.brabra" is not supported by the
  upper filesystem and aufs returns an error.
- from the users' point of view, this behaviour must be very strange.

Finally I am considering to make some levels to support xattr.
- support minimum common set of key only (if such set exists)
  Here "minimum common set" means a group of key which are surely
  supported by all filesystems. Aufs will filter-out other keys.
- create a new internal status flag
  This flag is set when the type of all branches are same. When the flag
  is set, aufs will handle xattr by simply redirecting.
- create a new aufs mount option
  the option will select two behaviours (above).

Unfortunately I could not understand what label means.
Is it a volume label at mounting like UUID?


J. R. Okajima
