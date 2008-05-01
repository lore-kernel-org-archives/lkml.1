Return-Path: <linux-kernel-owner+w=401wt.eu-S1763393AbYEAQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763393AbYEAQqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759985AbYEAQqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:46:00 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:36359 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYEAQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:45:58 -0400
Subject: Re: [TOMOYO #8 (2.6.25-mm1) 1/7] Introduce new LSM hooks.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, viro@ZenIV.linux.org.uk,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp
In-Reply-To: <20080501154716.GL30511@sequoia.sous-sol.org>
References: <20080501055405.024390000@nttdata.co.jp>
	 <20080501055543.269648000@nttdata.co.jp>
	 <20080501080144.GJ30511@sequoia.sous-sol.org>
	 <200805020007.HHC90622.OQSFOJtVOMFHFL@I-love.SAKURA.ne.jp>
	 <20080501154716.GL30511@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 01 May 2008 12:45:33 -0400
Message-Id: <1209660333.25678.495.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-01 at 08:47 -0700, Chris Wright wrote:
> * Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp) wrote:
> > The MAY_WRITE flag is not passed to security_inode_permission()
> > if security_inode_permission() is called from __open_namei_create().
> > Since TOMOYO Linux doesn't check MAY_READ/MAY_WRITE permissions for individual
> > read()/write() requests, the permission checks at open() time (i.e. may_open())
> > is the only chance to check MAY_WRITE flag. If I can't check MAY_WRITE flag
> > here, TOMOYO Linux can't control open(O_WRONLY | O_CREATE | O_EXCL).
> > 
> > Also, the O_TRUNC flag is not passed to security_inode_permission() because
> > vfs_permission() receives only MAY_READ/MAY_WRITE/MAY_APPEND flags, but
> > I have to check O_TRUNC flag before do_truncate().
> > 
> > So, I inserted a new hook here so that this hook can check all
> > MAY_READ/MAY_WRITE/O_APPEND/O_TRUNC flags together in a single place.
> 
> The reason I ask is because it doesn't check.  It only checks O_APPEND,
> but that's already passed in (MAY_APPEND).  So AFAICT, it's only O_TRUNC
> that you are trying to special case.  But in that case...all that is
> being asked for is MAY_WRITE permission.  Anything else doesn't make
> sense, especially since that's all you get from the truncate(2) path.
> 
> <snip>
> > This is an inevitable duplication since I want to do conventional checks
> > (DAC checks and inode operation existence checks) before TOMOYO Linux's check.
> > 
> > By the way, Stephen Smalley thinks it is better to copy codes which is needed by
> > pre_vfs_*() (i.e. may_create()/may_delete()/check_sticky()) into
> > security/tomoyo/ directory and leave vfs_*() untouched rather than
> > extract pre_vfs_*() from vfs_*() and call pre_vfs_*() from vfs_*().
> 
> I'm not sure he means literally copy.  Typically we take existing
> functionality and make it externally usable.

I didn't think splitting pre functions out of all of the vfs helpers was
such a good idea.   Making may_create/delete() available might make
sense.  And for complex combinations of DAC logic, perhaps introducing
may_link(), may_rename(), etc. might make sense.  

> Also, all the changes you make that are not in vfs_* helpers won't get
> picked up by NFS.

-- 
Stephen Smalley
National Security Agency

