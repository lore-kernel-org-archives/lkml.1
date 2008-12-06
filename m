Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYLFFyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYLFFyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 00:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYLFFx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 00:53:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41659 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYLFFxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 00:53:55 -0500
Date: Sat, 6 Dec 2008 05:53:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sds@tycho.nsa.gov, miklos@szeredi.hu, serue@us.ibm.com, jmorris@namei.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp
Subject: Re: [RFC] Add "reason" parameter to mnt_want_write().
Message-ID: <20081206055342.GL28946@ZenIV.linux.org.uk>
References: <493649C5.2060402@nttdata.co.jp> <1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil> <200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp> <1228513998.21715.75.camel@localhost.localdomain> <200812060827.ECD30776.FLOOHVFMtSOFJQ@I-love.SAKURA.ne.jp> <200812061425.GIH12430.FMOFOVFSJtHQLO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812061425.GIH12430.FMOFOVFSJtHQLO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 02:25:01PM +0900, Tetsuo Handa wrote:
> We want to allow LSM modules to perform MAC which takes an absolute pathname of
> a requested file into account. Since we can't pass "struct vfsmount" to VFS
> helper functions, we are trying to somehow pass "struct vfsmount"'s pathnames
> instead of "struct vfsmount" itself.
> 
> The mnt_want_write() and mnt_drop_write() hooks are inserted around VFS helper
> functions call. Thus, I think we can insert security_path_set() into
> mnt_want_write() and secuity_path_clear() into mnt_drop_write() rather than
> scattering security_path_set() and security_path_clear() all around the places.

No.  Use separate set of hooks AND PASS vfsmount DIRECTLY TO THEM.  Damnit,
people, just how many times does it have to be repeated?

Any version that pulls that class of tricks is no-go.  I don't _CARE_ whether
you hide vfsmount in task struct, do the same with string, send yourself a
datagram over magic socket or mail it to kludges-R-US.webtv.com, downloading
it back in LSM hook.

It's not a problem with implementation; it's a problem with the kludge
itself *and* with having the effect of vfs_mkdir() et.al. dependent on
anything except the arguments it's getting.

Adding global context of that kind is every bit as wrong as passing vfsmount
(or absolute pathname, or...) to vfs_mkdir() and its ilk.  It's worse,
actually, since it has an extra helping of ugliness on top of doing the
wrong thing.
