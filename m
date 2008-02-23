Return-Path: <linux-kernel-owner+w=401wt.eu-S936834AbYBWIYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936834AbYBWIYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbYBWIJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:44 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764140AbYBWIJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:30 -0500
Date: Sat, 23 Feb 2008 00:07:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: linux-kernel@vger.kernel.org, Latchesar Ionkov <lucho@ionkov.net>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Jim Meyering <meyering@redhat.com>
Subject: Re: [PATCH] Make v9fs uname and remotename parsing more robust
Message-Id: <20080223000709.33a1c412.akpm@linux-foundation.org>
In-Reply-To: <87skzu5cmd.fsf@pike.pond.sub.org>
References: <87skzu5cmd.fsf@pike.pond.sub.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 18:54:34 +0100 Markus Armbruster <armbru@redhat.com> wrote:

> match_strcpy() is a somewhat creepy function: the caller needs to make
> sure that the destination buffer is big enough, and when he screws up
> or forgets, match_strcpy() happily overruns the buffer.
> 
> There's exactly one customer: v9fs_parse_options().  I believe it
> currently can't overflow its buffer, but that's not exactly obvious.
> 
> The source string is a substing of the mount options.  The kernel
> silently truncates those to PAGE_SIZE bytes, including the terminating
> zero.  See compat_sys_mount() and do_mount().
> 
> The destination buffer is obtained from __getname(), which allocates
> from name_cachep, which is initialized by vfs_caches_init() for size
> PATH_MAX.
> 
> We're safe as long as PATH_MAX <= PAGE_SIZE.  PATH_MAX is 4096.  As
> far as I know, the smallest PAGE_SIZE is also 4096.
> 
> Here's a patch that makes the code a bit more obviously correct.  It
> doesn't depend on PATH_MAX <= PAGE_SIZE.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> 
> 
> diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
> index fbb12da..e42948b 100644
> --- a/fs/9p/v9fs.c
> +++ b/fs/9p/v9fs.c
> @@ -135,10 +135,10 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
>  			v9ses->trans = v9fs_match_trans(&args[0]);
>  			break;
>  		case Opt_uname:
> -			match_strcpy(v9ses->uname, &args[0]);
> +			match_strlcpy(v9ses->uname, &args[0], PATH_MAX);
>  			break;
>  		case Opt_remotename:
> -			match_strcpy(v9ses->aname, &args[0]);
> +			match_strlcpy(v9ses->aname, &args[0], PATH_MAX);
>  			break;
>  		case Opt_legacy:
>  			v9ses->flags &= ~V9FS_EXTENDED;
> diff --git a/include/linux/parser.h b/include/linux/parser.h
> index 26b2bdf..7dcd050 100644
> --- a/include/linux/parser.h
> +++ b/include/linux/parser.h
> @@ -29,5 +29,5 @@ int match_token(char *, match_table_t table, substring_t args[]);
>  int match_int(substring_t *, int *result);
>  int match_octal(substring_t *, int *result);
>  int match_hex(substring_t *, int *result);
> -void match_strcpy(char *, const substring_t *);
> +size_t match_strlcpy(char *, const substring_t *, size_t);
>  char *match_strdup(const substring_t *);
> diff --git a/lib/parser.c b/lib/parser.c
> index 703c8c1..4f0cbc0 100644
> --- a/lib/parser.c
> +++ b/lib/parser.c
> @@ -182,18 +182,25 @@ int match_hex(substring_t *s, int *result)
>  }
>  
>  /**
> - * match_strcpy: - copies the characters from a substring_t to a string
> - * @to: string to copy characters to.
> - * @s: &substring_t to copy
> + * match_strlcpy: - Copy the characters from a substring_t to a sized buffer
> + * @dest: where to copy to
> + * @src: &substring_t to copy
> + * @size: size of destination buffer
>   *
> - * Description: Copies the set of characters represented by the given
> - * &substring_t @s to the c-style string @to. Caller guarantees that @to is
> - * large enough to hold the characters of @s.
> + * Description: Copy the characters in &substring_t @src to the
> + * c-style string @dest.  Copy no more than @size - 1 characters, plus
> + * the terminating NUL.  Return length of @src.
>   */
> -void match_strcpy(char *to, const substring_t *s)
> +size_t match_strlcpy(char *dest, const substring_t *src, size_t size)
>  {
> -	memcpy(to, s->from, s->to - s->from);
> -	to[s->to - s->from] = '\0';
> +	size_t ret = src->to - src->from;
> +
> +	if (size) {
> +		size_t len = ret >= size ? size - 1 : ret;
> +		memcpy(dest, src->from, len);
> +		dest[len] = '\0';
> +	}
> +	return ret;
>  }
>  
>  /**
> @@ -206,9 +213,10 @@ void match_strcpy(char *to, const substring_t *s)
>   */
>  char *match_strdup(const substring_t *s)
>  {
> -	char *p = kmalloc(s->to - s->from + 1, GFP_KERNEL);
> +	size_t sz = s->to - s->from + 1;
> +	char *p = kmalloc(sz, GFP_KERNEL);
>  	if (p)
> -		match_strcpy(p, s);
> +		match_strlcpy(p, s, sz);
>  	return p;
>  }
>  
> @@ -216,5 +224,5 @@ EXPORT_SYMBOL(match_token);
>  EXPORT_SYMBOL(match_int);
>  EXPORT_SYMBOL(match_octal);
>  EXPORT_SYMBOL(match_hex);
> -EXPORT_SYMBOL(match_strcpy);
> +EXPORT_SYMBOL(match_strlcpy);
>  EXPORT_SYMBOL(match_strdup);

It would be better to present this as two patches.  One adds the new core
APIs and the other uses those APIs in v9fs.  The patches would take
separate routes into mainline.

I guess I can sneak this one in as-is, as long as the v9fs guys are OK with
that?
