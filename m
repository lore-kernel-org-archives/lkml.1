Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZHJLrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZHJLrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 07:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZHJLrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 07:47:42 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:61682 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZHJLrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 07:47:41 -0400
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and
 write permissions set
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eric Paris <eparis@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-security-module@vger.kernel.org
In-Reply-To: <1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>
	 <1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>
	 <87prb7v0dr.fsf@devron.myhome.or.jp>
	 <1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 10 Aug 2009 07:49:24 -0400
Message-Id: <1249904964.2422.21.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 16:38 -0400, Eric Paris wrote:
> On Sat, 2009-08-08 at 05:23 +0900, OGAWA Hirofumi wrote:
> > Eric Paris <eparis@redhat.com> writes:
> > 
> > > On Fri, 2009-08-07 at 06:05 -0400, Amerigo Wang wrote:
> > >> V2 -> V3:
> > >> Call notify_change() before clearing suid/sgid.
> > >> Thanks to OGAWA Hirofumi.
> > >> 
> > >> V1 -> V2:
> > >> Introduce dentry_remove_suid(), and use it in do_truncate().
> > >> Thanks to Eric Paris.
> > >> 
> > >> 
> > >> When suid is set and the non-owner user has write permission,
> > >> any writing into this file should be allowed and suid should be
> > >> removed after that.
> > >> 
> > >> However, current kernel only allows writing without truncations,
> > >> when we do truncations on that file, we get EPERM. This is a bug.
> > >> 
> > >> Steps to reproduce this bug:
> > >> 
> > >> % ls -l rootdir/file1
> > >> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> > >> % echo h > rootdir/file1
> > >> zsh: operation not permitted: rootdir/file1
> > >> % ls -l rootdir/file1
> > >> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> > >> % echo h >> rootdir/file1
> > >> % ls -l rootdir/file1
> > >> -rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1
> > >> 
> > >> This patch fixes it.
> > >> 
> > >> Signed-off-by: WANG Cong <amwang@redhat.com>
> > >> Cc: Eric Sandeen <esandeen@redhat.com>
> > >> Cc: Eric Paris <eparis@redhat.com>
> > >> Cc: Eugene Teo <eteo@redhat.com>
> > >> Cc: Al Viro <viro@zeniv.linux.org.uk>
> > >> Cc: hirofumi@mail.parknet.co.jp
> > >
> > > I was thinking about this and kept telling myself I was going to test v2
> > > before I ack/nak.  Clearly we shouldn't for the dropping of SUID if the
> > > process didn't have permission to change the ATTR_SIZE.
> > >
> > > Acked-by: Eric Paris <eparis@redhat.com>
> > 
> > BTW, Do you know why doesn't security modules fix the handling of
> > do_truncate() (i.e. ATTR_MODE | ATTR_SIZE). And why doesn't it allow to
> > pass ATTR_FORCE for it?
> 
> I'm not sure what you mean.  I understood ATTR_FORCE to mean 'I am magic
> and get to override all security checks."  Which is why nothing should
> ever be using ATTR_FORCE with things other than SUID.
> 
> I guess we could somehow force logic into the LSM to make it only apply
> to SUID and friends but I'm not sure it buys us anything.

SELinux shouldn't apply a permission check for the clearing of the suid
bit on write or truncate.  It should only apply a permission check for
the actual truncate or write operation, and then the clearing of the
suid bit should always be forced if that check passed.

-- 
Stephen Smalley
National Security Agency

