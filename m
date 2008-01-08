Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYAHWnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYAHWnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYAHWnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:43:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbYAHWng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:43:36 -0500
Date: Tue, 8 Jan 2008 14:42:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, shaggy@us.ibm.com, sandeen@redhat.com,
       jmoyer@redhat.com
Subject: Re: [PATCH] eCryptfs: Fix dentry handling on create error, unlink,
 and inode destroy
Message-Id: <20080108144215.f21115e2.akpm@linux-foundation.org>
In-Reply-To: <20080108215807.GE10989@localhost.austin.ibm.com>
References: <20080108052542.GX10989@localhost.austin.ibm.com>
	<20080107214517.ebf5a5bd.akpm@linux-foundation.org>
	<20080108215807.GE10989@localhost.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 15:58:07 -0600
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> > >  	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
> > >  				directory_inode->i_sb, 0);
> > 
> > Will this cause an undesirable log storm if the underlying fs runs
> > out of space?
> 
> When you're bumping up against the end of your storage space, you will
> get a lot more that just this message in your logs. There are printk's
> in ecryptfs_write_lower(), ecryptfs_encrypt_page(), ecryptfs_write(),
> and ecryptfs_write_metadata_to_contents() that will get pretty
> noisy. Is it worth wrapping those in a higher level of verbosity?

The consequences of this can actually be pretty harmful.  syslogd typically
does sychronous writes so a random full disk can cause a seek storm over on
the log disk and a runaway ecryptfs-using application could pretty quickly
exhaust the space on the log disk.

So I'd suggest that sometime you go through the fs and find any such
user-triggerable printks and fix them up.  The most robust way of fixing
them up would be to delete them, or make them dependent on
CONFIG_ECRYPTFS_DEBUG.  Fiddling with the facility levels would help, but
it just lessens the probability rather than fixing it completely.

