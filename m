Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYAIDLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYAIDLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYAIDLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:11:10 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60990 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbYAIDLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:11:09 -0500
X-Sasl-enc: 0R98kMR1PIidFraxqpHn1zqAH+zgMEAyc7fi6ggbc550 1199848268
Subject: Re: umount -l <path>, getcwd and /proc/<pid>/cwd inconsistent
From: Ian Kent <raven@themaw.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1199675850.3156.15.camel@raven.themaw.net>
References: <1199675850.3156.15.camel@raven.themaw.net>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 12:10:30 +0900
Message-Id: <1199848230.23076.14.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-07 at 12:17 +0900, Ian Kent wrote:
> 
> Basically, from a bash shell, setting working directory to a mounted
> directory all is fine with "pwd" and "/proc/<pid>/cwd". Following a
> "umount - l" on the mount "pwd" continues to return the expected string
> but "/proc/<pid>/cwd" returns an empty string.
> 
> What I'm really after is why this happens because sys_getcwd and
> proc_pid_readlink appear to do essentially the same thing to get the
> string.

I think I understand what happens here now.

Basically, following a "umount -l", anything that calls d_path from
within the unlinked mount and doesn't have a d_name dentry ops method
can no longer walk back up to the root to get the path.

Of course this makes perfect sense as the mount has been unlinked from
the tree.

But it can also prevent processes still using the mount from
successfully running through to completion to release the mount. I
expect this was never the intent of the functionality but I think it
should be. Especially since the VFS appears to handle this really well
otherwise.

So, I'm after suggestions:
Does anyone feel strongly that this case shouldn't be handled for some
reason? Why?
Does anyone have any suggestions about how this should be done?
Does anyone have any concerns about what shouldn't be done to deal with
this?

Ian


