Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbYBWMY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbYBWMY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYBWMYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:24:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42488 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYBWMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:24:45 -0500
Date: Sat, 23 Feb 2008 12:24:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC 01/11] add generic versions of debugfs file operations
Message-ID: <20080223122444.GM27894@ZenIV.linux.org.uk>
References: <20080219040435.825494460@arndb.de> <20080219040828.415218298@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219040828.415218298@arndb.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:04:36AM +0100, Arnd Bergmann wrote:
> +	char buf[3];
> +	u32 *val = file->private_data;
> +
> +	if (*val)
> +		buf[0] = 'Y';
> +	else
> +		buf[0] = 'N';
> +	buf[1] = '\n';
> +	buf[2] = 0x00;
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);

Ewww - caps, \n...  BTW, \0 is pointless here - simple_read_from_buffer() will
not access it with these arguments)...

> +{
> +	char buf[32];
> +	int buf_size;
> +	u32 *val = file->private_data;
> +
> +	buf_size = min(count, (sizeof(buf)-1));
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +
> +	switch (buf[0]) {
> +	case 'y':
> +	case 'Y':
> +	case '1':
> +		*val = 1;
> +		break;
> +	case 'n':
> +	case 'N':
> +	case '0':
> +		*val = 0;
> +		break;

Please, check the length; sloppy input grammar is a bad idea.  Hell, at the
very least you want -EINVAL if input is not recognized...
