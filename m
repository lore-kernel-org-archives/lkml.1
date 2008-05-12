Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYELWEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYELWEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYELWEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:04:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44529 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYELWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:04:10 -0400
Date: Mon, 12 May 2008 15:02:32 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
Subject: Re: kobject: Fix kobject_rename and !CONFIG_SYSFS
Message-ID: <20080512220232.GA16914@kroah.com>
References: <m163tocw43.fsf_-_@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163tocw43.fsf_-_@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:41:00PM -0700, Eric W. Biederman wrote:
> 
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> When looking at kobject_rename I found two bugs with
> that exist when sysfs support is disabled in the kernel.
> 
> kobject_rename does not change the name on the kobject when
> sysfs support is not compiled in.
> 
> kobject_rename without locking attempts to check the
> validity of a rename operation, which the kobject layer
> simply does not have the infrastructure to do so.
> 
> This patch documents the previously unstated requirement of
> kobject_rename that is the responsibility of the caller to
> provide mutual exclusion and to be certain that the new_name
> for the kobject is valid.
> 
> This patch modifies sysfs_rename_dir in !CONFIG_SYSFS case
> to call kobject_set_name to actually change the kobject_name.
> 
> This patch removes the bogus and misleading check in kobject_rename
> that attempts to see if a rename is valid.  The check is bogus
> because we do not have the proper locking.  The check is misleading
> because it looks like we can and do perform useful checking at the
> kobject level that we don't.
> 
> The users in net/core/dev.c already have all of the necessary checks
> in place and don't care.  The other use in net/core/wireless.c
> as originally implemented is incorrect because it performs no locking
> and a simple patch has been sent that adds the necessary locking
> and sanity checks there.  Ensuring this patch will not have an
> effect on users of kobject_rename or device_rename.

Eric, Randy Dunlap has found that this patch breaks the build when
CONFIG_SYSFS is not enabled.  Can you please fix it up before I send it
to Linus?

The exact error is:
In file included from /local/linsrc/next-20080509/include/linux/kobject.h:21,
                 from /local/linsrc/next-20080509/include/linux/module.h:16,
                 from /local/linsrc/next-20080509/include/linux/crypto.h:21,
                 from /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets_64.c:7,
                 from /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets.c:4:
/local/linsrc/next-20080509/include/linux/sysfs.h: In function 'sysfs_rename_dir':
/local/linsrc/next-20080509/include/linux/sysfs.h:142: error: implicit declaration of function 'kobject_set_name'


thanks,

greg k-h
