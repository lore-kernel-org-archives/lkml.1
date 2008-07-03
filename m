Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYGCV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYGCV7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYGCV7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:59:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26567 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbYGCV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:59:34 -0400
Date: Thu, 3 Jul 2008 14:58:56 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [BUGFIX][PATCH 1/2] configfs: Prevent userspace
	from creating new entries under attaching directories
Message-ID: <20080703215856.GG1502@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com> <1214503549-15678-2-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214503549-15678-2-git-send-email-louis.rilling@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:05:48PM +0200, Louis Rilling wrote:
> This commit fixes 1/, tagging new directories with CONFIGFS_USET_CREATING before
> building the inode and instantiating the dentry, and validating the whole
> group+default groups hierarchy in a second pass by clearing
> CONFIGFS_USET_CREATING.

	Man, I'm wary of all these in-flight flags.  I hope they are all
orthogonal :-)

> 	mkdir(), symlink(), lookup(), and dir_open() simply return -ENOENT if
> called in (or linking to) a directory tagged with CONFIGFS_USET_CREATING. This

	Why not block until the create is done?

> +	/*
> +	 * Fake invisibility if dir belongs to a group/default groups hierarchy
> +	 * being attached
> +	 *
> +	 * This forbids userspace to read/write attributes of items which may
> +	 * not complete their initialization, since the dentries of the
> +	 * attributes won't be instantiated.
> +	 */
int configfs_dirent_is_ready(struct configfs_dirent *sd)
{
	int err = 0;
> +	spin_lock(&configfs_dirent_lock);
> +	if (parent_sd->s_type & CONFIGFS_USET_CREATING)
> +		err = -ENOENT;
> +	spin_unlock(&configfs_dirent_lock);
	return err;
}

	Then use is_ready() in the five places you check it ;-)  Perhaps
change configfs_validate_dir() to configfs_dir_set_ready().  I do like
the way validate_dir() is coded.

Joel

-- 

"There are only two ways to live your life. One is as though nothing
 is a miracle. The other is as though everything is a miracle."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
