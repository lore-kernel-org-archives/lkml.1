Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYJ0MjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYJ0MjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYJ0MjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:39:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34812 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbYJ0MjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:39:15 -0400
To: ncunningham@crca.org.au
CC: rjw@sisk.pl, miklos@szeredi.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1225107607.26724.9.camel@nigel-laptop> (message from Nigel
	Cunningham on Mon, 27 Oct 2008 22:40:07 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop>  <200810271237.40049.rjw@sisk.pl> <1225107607.26724.9.camel@nigel-laptop>
Message-Id: <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 27 Oct 2008 13:38:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Nigel Cunningham wrote:
> Hi.
> 
> On Mon, 2008-10-27 at 12:37 +0100, Rafael J. Wysocki wrote:
> > Well, I guess it's better if you post the entire thing so that we can see
> > what the role of the $subject patch is in it, even if this patch finally gets
> > merged separately.
> 
> Ah.. that makes me see how vfs_check_frozen was getting triggered...
> (fs/namei.c, below).

Nigel, thanks for the patch, it makes thinks a lot clearer.

>From a quick look through the patch it seems to solve a bunch of cases
where new fuse requests during the freezing could cause problems.  But
it doesn't do anything with requests that are already under way when
the freezing starts, which would still result in all the same
problems.

Take this scenario:

 1) process A does rename("/mnt/fuse/a", "/mnt/fuse/b")
 2) request goes to process B serving the fuse filesystem
 3) filesystems are frozen, no new fuse requests
 4) processes are frozen, let's say B first, then A
 5) freezing A will fail, since it's still waiting for the request to finish

Several solutions have been posted, none of which really solve the problem:

 a) Let's tag fuse server processes and freeze them later.  This is
 basically impossible, because many processes could be interoperating
 and there's no way to know which is depending on which (example:
 sshfs uses ssh for communication, which possibly relies on openvpn
 process for packet transmission).

 b) While waiting for replies to fuse request, allow process to
 freeze.  Does not fully solve the problem, as VFS might be holding
 locks, and other processes waiting for those locks will not be
 freezable.

Miklos
