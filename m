Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZGLX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZGLX5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 19:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZGLX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 19:57:23 -0400
Received: from ozlabs.org ([203.10.76.45]:46061 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZGLX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 19:57:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Mierswa <impulze@impulze.org>
Subject: Re: [RFC] Re: Parsing kernel parameters and escaping "
Date: Mon, 13 Jul 2009 09:27:15 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A50B09B.9030901@impulze.org> <200907121911.58333.rusty@rustcorp.com.au> <4A5A248B.1070606@impulze.org>
In-Reply-To: <4A5A248B.1070606@impulze.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907130927.16203.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 03:29:39 am Daniel Mierswa wrote:
> Tested:
> |param| => [param[(none)]]
> |param=| => [param[]]
> |param=value| => [param[value]]
> |param=value=withequal | => [param[value=withequal]]
> |param="value with spaces" | => [param[value with spaces]]
> |param="value with spaces and quotes \"" | => [param[value with spaces and
> | quotes "]] param=\"foo\" | => [param[\"foo" ]]
> |"param = value" | => [param = value[(none)]]

Hi Daniel!

It might be nice to have that test code somewhere at the bottom of param.c,
at least while we're playing with the code.

> Thanks for your kind feedback, I'm willing to put more effort into this
> when needed. I really first wanted to check if patches for this are
> welcomed.

Well, IMO it's a maintainer's job to give feedback, and patches should always be welcomed (even if not applied!).

Now to the details:

> +static size_t pull_token(char *args, char const *delim)
>  {
> -       unsigned int i, equals = 0;
> -       int in_quote = 0, quoted = 0;
> -       char *next;
> +       size_t length = 0;
> +       char *iterator = NULL, *last_quote = NULL;
> +
> +       for (iterator = args; *iterator; iterator++, length++) {

I really prefer "i" instead of "iterator".  I actually think i as an
unsigned/size_t here would probably make the code neater, but that's an aside.

> +               if (*iterator == '"') {
> +                       if (last_quote) {
> +                               char *mover = last_quote;
> +
> +                               /* move whole string back until current " is reached */ 
> +                               while (mover != iterator - 1) {
> +                                       *mover = *(mover + 1);
> +                                       mover++;
> +                               }

memmove?

> +               {
> +                       /* check for delimiter */
> +                       char const *delim_iterator = NULL;
> +                       for (delim_iterator = delim; *delim_iterator; delim_iterator++) {
> +                               if (*iterator == *delim_iterator) {
> +                                       return length;
> +                               }
> +                       }

How about:
	if (strchr(delim, *iterator))
		return length;

> +static char *next_arg(char *args, char **param, char **val)
> +{
> +       size_t len;
> +
> +       /* Chew leading spaces */
> +       while (*args == ' ')
> +               args++;

Note that this will undo another pending patch, which changes this to
isspace() to handle tabs et al.

Thanks!
Rusty.

