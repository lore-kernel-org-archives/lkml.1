Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYBYWTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYBYWTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbYBYWTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:19:41 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:48827 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772AbYBYWTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:19:40 -0500
Date: Tue, 26 Feb 2008 01:18:32 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Quigley <dpquigl@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Eric Paris <eparis@redhat.com>, Harald Welte <laforge@gnumonks.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kill_pid_info_as_uid: don't use security_task_kill()
Message-ID: <20080225221832.GA129@tv-sign.ru>
References: <20080225174228.GA22084@tv-sign.ru> <1203965042.2804.196.camel@moss-spartans.epoch.ncsc.mil> <20080225200328.GA83@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225200328.GA83@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Oleg Nesterov wrote:
>
> On 02/25, Stephen Smalley wrote:
> > 
> > On Mon, 2008-02-25 at 20:42 +0300, Oleg Nesterov wrote:
> > > kill_pid_info_as_uid() is solely used by drivers/usb/core/. The original
> > > "[PATCH] Fix signal sending in usbdevio on async URB completion" commit
> > > 46113830a18847cff8da73005e57bc49c2f95a56 was right, but nowadays we use
> > > struct pid and this solves most of the addressed problems.
> > > 
> > > It would be nice to use kill_pid_info() instead, but we can't because USB
> > > uses .si_code = SI_ASYNCIO which fools SI_FROMUSER() and thus security checks.
> > > 
> > > I think we should omit the permission checks completely, the task which does
> > > ioctl(USBDEVFS_SUBMITURB) explicitly asks to send the signal to it, we should
> > > not deny the signal even if the task changes its credentials in any way.
> > 
> > If we are applying checks based on uid/gid to protect suid/sgid
> > programs, then we ought to also invoke the LSM hook to allow protection
> > of other credential-changing transformations, like SELinux context
> > transitions.  You either remove all checking or none, please.
> 
> Yes, you are right. I'd like to remove all uid/euid checks.

Actually, I may be wrong, sorry. If the task does setuid exec, we probably
should do these checks.

OK, please ignore 2nd and 3rd patches.

Still. The usage of security_task_kill(secid) doesn't look good, imho.
We have the similar issues with send_sigio(). In that case we use
security_file_send_sigiotask(), not security_task_kill().

Oleg.

