Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZHGUij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZHGUij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZHGUii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:38:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58133 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZHGUih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:38:37 -0400
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and
 write permissions set
From: Eric Paris <eparis@redhat.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <87prb7v0dr.fsf@devron.myhome.or.jp>
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>
	 <1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>
	 <87prb7v0dr.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:38:01 -0400
Message-Id: <1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-08 at 05:23 +0900, OGAWA Hirofumi wrote:
> Eric Paris <eparis@redhat.com> writes:
> 
> > On Fri, 2009-08-07 at 06:05 -0400, Amerigo Wang wrote:
> >> V2 -> V3:
> >> Call notify_change() before clearing suid/sgid.
> >> Thanks to OGAWA Hirofumi.
> >> 
> >> V1 -> V2:
> >> Introduce dentry_remove_suid(), and use it in do_truncate().
> >> Thanks to Eric Paris.
> >> 
> >> 
> >> When suid is set and the non-owner user has write permission,
> >> any writing into this file should be allowed and suid should be
> >> removed after that.
> >> 
> >> However, current kernel only allows writing without truncations,
> >> when we do truncations on that file, we get EPERM. This is a bug.
> >> 
> >> Steps to reproduce this bug:
> >> 
> >> % ls -l rootdir/file1
> >> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> >> % echo h > rootdir/file1
> >> zsh: operation not permitted: rootdir/file1
> >> % ls -l rootdir/file1
> >> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> >> % echo h >> rootdir/file1
> >> % ls -l rootdir/file1
> >> -rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1
> >> 
> >> This patch fixes it.
> >> 
> >> Signed-off-by: WANG Cong <amwang@redhat.com>
> >> Cc: Eric Sandeen <esandeen@redhat.com>
> >> Cc: Eric Paris <eparis@redhat.com>
> >> Cc: Eugene Teo <eteo@redhat.com>
> >> Cc: Al Viro <viro@zeniv.linux.org.uk>
> >> Cc: hirofumi@mail.parknet.co.jp
> >
> > I was thinking about this and kept telling myself I was going to test v2
> > before I ack/nak.  Clearly we shouldn't for the dropping of SUID if the
> > process didn't have permission to change the ATTR_SIZE.
> >
> > Acked-by: Eric Paris <eparis@redhat.com>
> 
> BTW, Do you know why doesn't security modules fix the handling of
> do_truncate() (i.e. ATTR_MODE | ATTR_SIZE). And why doesn't it allow to
> pass ATTR_FORCE for it?

I'm not sure what you mean.  I understood ATTR_FORCE to mean 'I am magic
and get to override all security checks."  Which is why nothing should
ever be using ATTR_FORCE with things other than SUID.

I guess we could somehow force logic into the LSM to make it only apply
to SUID and friends but I'm not sure it buys us anything.

-Eric

