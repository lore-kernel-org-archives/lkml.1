Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbYGQA7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbYGQA7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbYGQA7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:59:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbYGQA7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:59:37 -0400
Subject: Re: /proc/mounts unreadable - bisected
From: Eric Paris <eparis@redhat.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org, sds@tycho.nsa.gov
In-Reply-To: <487E9815.6060803@gmail.com>
References: <487E9815.6060803@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 20:59:31 -0400
Message-Id: <1216256371.3070.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 20:53 -0400, Marc Dionne wrote:
> With current git, /proc/mounts is unreadable on my system, with any attempts to 
> read it returning EINVAL.  This breaks many init scripts, among other things.
> 
> I bisected it down to this commit:
> 
> commit 2069f457848f846cb31149c9aa29b330a6b66d1b
> Author: Eric Paris <eparis@redhat.com>
> Date:   Fri Jul 4 09:47:13 2008 +1000
> 
>      LSM/SELinux: show LSM mount options in /proc/mounts
> 
>      This patch causes SELinux mount options to show up in /proc/mounts.  As
>      with other code in the area seq_put errors are ignored.  Other LSM's
>      will not have their mount options displayed until they fill in their own
>      security_sb_show_options() function.
> 
> In my case, selinux_get_mnt_opts() never gets very far because 
> sbsec->initialized never becomes true, and the function systematically returns 
> EINVAL which is then passed back up to the reader of /proc/mounts.
> 
> Changing show_sb_opts() to always return 0 (it was a void function before this 
> commit) makes the system behave normally.
> 
> Now it's possible that my selinux config is hosed - I have it enabled in 
> permissive mode but I don't pay much attention to it - but the failure mode in 
> that case should probably be more graceful.  Seems like it would be better to 
> print out the available mount info minus the LSM options than to bail out 
> completely?

Yes, your SELinux config is hosed.  But I'll agree that we should just
pass over the LSM options in that case (since clearly there aren't any)
and not fail the read altogether.  Patch will be forthcoming.

-Eric

