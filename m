Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbXCEWMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbXCEWMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXCEWMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:12:24 -0500
Received: from [198.99.130.12] ([198.99.130.12]:49451 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXCEWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:12:22 -0500
Date: Mon, 5 Mar 2007 17:03:34 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 04/11] uml - hostfs: avoid possible escapes from hostfs=.
Message-ID: <20070305220334.GB7702@ccure.user-mode-linux.org>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan> <20070305204902.9072.1224.stgit@americanbeauty.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305204902.9072.1224.stgit@americanbeauty.home.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 09:49:02PM +0100, Paolo 'Blaisorblade' Giarrusso wrote:
> From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> 
> Avoid accepting things like -o .., -o dir/../../dir2, -o dir/../.. .
> This may be considered useless, but YMMV. I consider that this has a limited
> security value, exactly like disabling module support (in many case it is
> useful).

Two comments on this one:

> +	return  strstr(path, "/../") != NULL ||
> +		strcmp(path, "..") == 0 ||
> +		strncmp(path, "../", strlen("../")) == 0 ||
> +		str_ends_with(path, "/..");

Minor style point - I'd be happier with more parens:

+	return  (strstr(path, "/../") != NULL) ||
+		(strcmp(path, "..") == 0) ||
+		(strncmp(path, "../", strlen("../")) == 0) ||
+		str_ends_with(path, "/..");

C gets operator precedence wrong in one or two cases, so I just put parens
any place it might matter.

Second, there is code in externfs which does the same thing without
parsing paths which you might consider instead.  It sees whether the
requested directory is outside the jail by cd-ing to it and then
repeatedly cd .. until it either reaches / or the jail root.

A copy is below for your reading pleasure.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


/* This does a careful check of whether it's being asked to mount something
 * that's outside the hostfs jail.  It does so by cd-ing to the requested
 * directory and "cd .." until it either reaches / or the jail directory.
 * If it reaches /, then we were outside the jail and we return -EPERM.
 * I do things this way rather than trying to examine the passed-in root
 * to avoid having to parse the string for instances of ".." and the like.
 * Examining the string also doesn't help with symlinks that point outside
 * the jail.  Plus, if there's no parsing, there's no parser to try to exploit.
 */
static int escaping_jail(char *root)
{
	struct uml_stat jail_inode;
	struct uml_stat last_dir, cur_dir;
	int save_pwd, err, escaping = -EPERM;
	const char *path[] = { jail_dir, root, NULL };
	char tmp[HOSTFS_BUFSIZE], *file;

	err = os_stat_file(jail_dir, &jail_inode);
	if(err)
		goto out;

	save_pwd = os_open_file(".", of_read(OPENFLAGS()), 0);
	if(save_pwd < 0)
		goto out;

	file = get_path(path, tmp, sizeof(tmp));
	if(file == NULL)
		goto out_close;

	err = os_change_dir(file);
	if(err)
		goto out_free;

	err = os_stat_file(".", &cur_dir);
	if(err)
		goto out_back;

	do {
		if(SAME_INO(cur_dir, jail_inode)){
			escaping = 0;
			break;
		}

		err = os_change_dir("..");
		if(err)
			goto out_back;

		last_dir = cur_dir;

		err = os_stat_file(".", &cur_dir);
		if(err)
			goto out_back;

	} while(!SAME_INO(last_dir, cur_dir));

	err = os_fchange_dir(save_pwd);
	if(err)
		goto out_close;

	free_path(file, tmp);
	os_close_file(save_pwd);

	return escaping;

out_back:
	os_fchange_dir(save_pwd);
out_free:
	free_path(file, tmp);
out_close:
	os_close_file(save_pwd);
out:
	return err;
}

