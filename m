Return-Path: <linux-kernel-owner+w=401wt.eu-S1422992AbXCGSrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422992AbXCGSrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422978AbXCGSrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:47:13 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:62076 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422984AbXCGSrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:47:10 -0500
Date: Wed, 7 Mar 2007 10:43:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Martin Peschke <mp3@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Wu Fengguang <wfg@mail.ustc.edu.cn>
Subject: Re: [Patch 1/2] add for_each_substring() and match_substring()
Message-Id: <20070307104310.907f23fb.randy.dunlap@oracle.com>
In-Reply-To: <1173208763.5266.8.camel@dix>
References: <1173208763.5266.8.camel@dix>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 20:19:23 +0100 Martin Peschke wrote:

> This adds for_each_substring() and match_substring() to lib/parser.c.
> Using these instead of strsep() and match_token() is more comfortable,
> less error prone and safer.
> 
> strsep() is destructive; it changes the string it is working on.
> match_token() needs strsep() to chop a large string up into smaller
> \0-terminated pieces. Callers might need to create a working copy
> of the string to be parsed.  
> 
> In contrast, match_substring() contents itself with non-\0-terminated
> substrings provided by for_each_substring().
> 
> Converting users of strsep() / match_token() to for_each_substring() /
> match_substring(), e.g. all the stuff in fs/, should not be difficult.
> 
> Signed-off-by: Martin Peschke <mp3@de.ibm.com>
> ---

Hi,
When a patch applies only to -mm, please let us know that.  Thanks.


>  include/linux/parser.h |    7 +++++++
>  lib/parser.c           |   45 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/parser.h
> ===================================================================
> --- linux.orig/include/linux/parser.h
> +++ linux/include/linux/parser.h
> @@ -26,9 +26,16 @@ typedef struct {
>  } substring_t;
>  
>  int match_token(char *, match_table_t table, substring_t args[]);
> +int match_substring(substring_t *, match_table_t table, substring_t args[]);
>  int match_int(substring_t *, int *result);
>  int match_octal(substring_t *, int *result);
>  int match_hex(substring_t *, int *result);
>  void match_strcpy(char *, substring_t *);
>  char *match_strdup(substring_t *);
> +char *match_to(const char *cs, const char *ct);
>  int match_s64(substring_t *, s64 *result, int);
> +
> +#define for_each_substring(s, start, delim) \
> +	for ((s)->from = start, (s)->to = match_to((s)->from, delim); \
> +	     (s)->to; \
> +	     (s)->from = (s)->to + 1, (s)->to = match_to((s)->from, delim))
> Index: linux/lib/parser.c
> ===================================================================
> --- linux.orig/lib/parser.c
> +++ linux/lib/parser.c
> @@ -27,7 +27,7 @@ static int match_one(char *s, char *p, s
>  	char *meta;
>  	int argc = 0;
>  
> -	if (!p)
> +	if (!p || !s)
>  		return 1;
>  
>  	while(1) {
> @@ -111,6 +111,36 @@ int match_token(char *s, match_table_t t
>  }
>  
>  /**
> + * match_substring: - Find a token (and optional args) in a substring
> + * @sub: the substring to examine for token/argument pairs
> + * @table: match_table_t describing the set of allowed option tokens and the
> + * arguments that may be associated with them. Must be terminated with a
> + * &struct match_token whose pattern is set to the NULL pointer.
> + * @args: array of %MAX_OPT_ARGS &substring_t elements. Used to return match
> + * locations.
> + *
> + * Description: Detects which if any of a set of token strings has been passed
> + * to it. Tokens can include up to MAX_OPT_ARGS instances of basic c-style
> + * format identifiers which will be taken into account when matching the
> + * tokens, and whose locations will be returned in the @args array.
> + */
> +int match_substring(substring_t *sub, match_table_t table, substring_t args[])
> +{
> +	char *s;
> +	int token, i;
> +
> +	memset(args, 0, MAX_OPT_ARGS * sizeof(substring_t));
> +	s = match_strdup(sub);
> +	token = match_token(s, table, args);
> +	for (i = 0; i < MAX_OPT_ARGS; i++) {
> +		args[i].from += sub->from - s;
> +		args[i].to += sub->from - s;
> +	}
> +	kfree(s);
> +	return token;
> +}
> +
> +/**
>   * match_number: scan a number in the given base from a substring_t
>   * @s: substring to be scanned
>   * @result: resulting integer on success
> @@ -237,6 +267,17 @@ char *match_strdup(substring_t *s)
>  	return p;
>  }
>  
> +char *match_to(const char *cs, const char *ct)
> +{
> +	char *delim = strpbrk(cs, ct);
> +	if (delim)
> +		return delim;
> +	else if (*cs != '\0')
> +		return (char *)(cs + strlen(cs));
> +	else
> +		return NULL;
> +}
> +
>  EXPORT_SYMBOL(match_token);
>  EXPORT_SYMBOL(match_int);
>  EXPORT_SYMBOL(match_octal);
> @@ -244,3 +285,5 @@ EXPORT_SYMBOL(match_hex);
>  EXPORT_SYMBOL(match_strcpy);
>  EXPORT_SYMBOL(match_strdup);
>  EXPORT_SYMBOL(match_s64);
> +EXPORT_SYMBOL(match_to);
> +EXPORT_SYMBOL(match_substring);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
