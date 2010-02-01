Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0BAWp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:45:29 -0500
Received: from mail.perches.com ([173.55.12.10]:1723 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab0BAWp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:45:28 -0500
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100201222511.GA12882@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 14:45:26 -0800
Message-ID: <1265064326.25140.398.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 22:25 +0000, Al Viro wrote:
> 	There's a lot of places doing printks with ->d_name of various
> dentries.  Unfortunately, as often as not they are b0rken due to races
> with rename().
> 
> 	I propose to add a new format - %pd.  It would print dentry name.
> However, unlike everything else in vsnprintf, it would NOT be locking-agnostic.
> It would grab and release dentry->d_lock.  And yes, I hate that as much as
> anyone.  I don't see any sane alternative.
[]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 3b8aeec..52a09dc 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -880,6 +880,18 @@ static char *uuid_string(char *buf, char *end, const u8 *addr,
>  	return string(buf, end, uuid, spec);
>  }
>  
> +static char *dname_string(char *buf, char *end, struct dentry *d,
> +			 struct printf_spec spec)

Maybe there's value in passing fmt here to allow
printing of the various dentry fields?

"%pd<foo>"

for things like:

pr_debug("ds_read(socket %d)\n", iminor(file->f_path.dentry->d_inode));
dprintk("%s: dentry = %s/%s, cookie = %Lu\n", __func__,
			dentry->d_parent->d_name.name,
			dentry->d_name.name,



