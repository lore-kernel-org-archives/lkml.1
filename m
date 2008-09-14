Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYINJvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYINJvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYINJvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:51:11 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:42405 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYINJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:51:09 -0400
Date: Sun, 14 Sep 2008 11:51:06 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 8/8] Dump open file descriptors
Message-ID: <20080914095106.GA6300@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Oren Laadan <orenl@cs.columbia.edu>, dave@linux.vnet.ibm.com,
	containers@lists.linux-foundation.org, jeremy@goop.org,
	linux-kernel@vger.kernel.org, arnd@arndb.de
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu> <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 07:06:06PM -0400, Oren Laadan wrote:
> +int cr_scan_fds(struct files_struct *files, int **fdtable)
> +{
> +	struct fdtable *fdt;
> +	int *fds;
> +	int i, n, tot;
> +
> +	n = 0;
> +	tot = CR_DEFAULT_FDTABLE;

Why not?
| int i;
| int n = 0;
| int tot = CR_DEFAULT_FDTABLE;

IHMO easier readable.

> +	spin_lock(&files->file_lock);
> +	fdt = files_fdtable(files);
> +	for (i = 0; i < fdt->max_fds; i++) {

The process is suspended at this state?

> +		if (n == tot) {
> +			/*
> +			 * fcheck_files() is safe with drop/re-acquire
> +			 * of the lock, because it tests:  fd < max_fds
> +			 */
> +			spin_unlock(&files->file_lock);
> +			tot *= 2;
> +			if (tot < 0) {		/* overflow ? */

_NO_. tot is signed, this does not have documented overflow behaviour.
You need to restrict this to a sane number.

> +				kfree(fds);
> +				return -EMFILE;
> +			}
> +			fds = krealloc(fds, tot * sizeof(*fds), GFP_KERNEL);
> +			if (!fds)

krealloc does not free the memory on error, so this is a leak.

Bastian

-- 
The more complex the mind, the greater the need for the simplicity of play.
		-- Kirk, "Shore Leave", stardate 3025.8
