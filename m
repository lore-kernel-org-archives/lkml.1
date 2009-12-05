Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZLEOQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZLEOQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZLEOQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:16:08 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61254 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbZLEOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=p8juazeMd5CtK6Yy+NO2BWnW4BjALeA0syw7iHYxuPWk721dkpMLbbZoYDWGmNDUZd
         sasi5l1BGtcjoYLlRDZj+LLwkrvVk5cj9PGM8YMSM1ZL/N337fGQoXM1siI5ns3mNDCW
         Fu0Ug+iijOcQchXkw/F0GFKjjH9vOITING8j0=
Message-ID: <4B1A6B28.2020501@gmail.com>
Date: Sat, 05 Dec 2009 15:16:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Emese Revfy <re.emese@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 11/31] Constify struct file_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198C43.50205@gmail.com> <4B19A333.5080103@gmail.com>
In-Reply-To: <4B19A333.5080103@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2009 01:02 AM, Emese Revfy wrote:
> diff --git a/drivers/char/pty.c b/drivers/char/pty.c
> index 62f282e..d39c67b 100644
> --- a/drivers/char/pty.c
> +++ b/drivers/char/pty.c
> @@ -682,7 +682,18 @@ static int ptmx_open(struct inode *inode, struct file *filp)
>  	return ret;
>  }
>  
> -static struct file_operations ptmx_fops;
> +static const struct file_operations ptmx_fops = {
> +	.llseek		= no_llseek,
> +	.read		= tty_read,
> +	.write		= tty_write,
> +	.poll		= tty_poll,
> +	.unlocked_ioctl	= tty_ioctl,
> +	.compat_ioctl	= tty_compat_ioctl,
> +	.open		= ptmx_open,
> +	.release	= tty_release,
> +	.fasync		= tty_fasync,
> +};
> +
>  
>  static void __init unix98_pty_init(void)
>  {
> @@ -736,9 +747,6 @@ static void __init unix98_pty_init(void)
>  	register_sysctl_table(pty_root_table);
>  
>  	/* Now create the /dev/ptmx special device */
> -	tty_default_fops(&ptmx_fops);
> -	ptmx_fops.open = ptmx_open;
> -

Apart you CCed hundreds of people and mixed thousand things together
into one patch, this makes no sense.

I think the purpose was to not have the fops on multiple places. When
one changes tty_fops, he has to change even ptmx_fops from now on. Not
that I would say the current approach is clean, but this makes it worse IMO.

And as Greg pointed out, you made many functions global for no real income.
