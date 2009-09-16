Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZIPGaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZIPGaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZIPGaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:30:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZIPGaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:30:08 -0400
Message-ID: <4AB085A6.8000605@cn.fujitsu.com>
Date: Wed, 16 Sep 2009 14:28:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH] kallsyms: Fix segfault in prefix_underscores_count().
References: <20090916050845.GA5805@linux-sh.org>
In-Reply-To: <20090916050845.GA5805@linux-sh.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Paulo Marques <pmarques@grupopie.com> (who reviewed that patch)

Paul Mundt wrote:
> [ I'm not sure who exactly this should go to, so I've attempted to get all of
>   the interested parties in the Cc. ]
> 
> This is a re-send of a problem that I reported on August 7th, both Sam and Lai
> have been unresponsive, so hopefully someone else can take a look at this.
>

Lai is off office and won't be back in 2 weeks, so I'm afraid
he won't be responsive..

> Commit b478b782e110fdb4135caa3062b6d687e989d994 "kallsyms, tracing:
> output more proper symbol name" introduces a "bugfix" that introduces
> a segfault in kallsyms in my configurations.
> 
> The cause is the introduction of prefix_underscores_count() which
> attempts to count underscores, even in symbols that do not have them.
> As a result, it just uselessly runs past the end of the buffer until it
> crashes:
> 

But the fix looks obviously correct, as long as @str is guaranteed
to be NULL-terminated.

...
> @@ -584,9 +538,14 @@ static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
>  static int prefix_underscores_count(const char *str)
>  {
>  	const char *tail = str;
> +	size_t len = strlen(str);
> +
> +	while (*tail != '_') {
> +		if (!len--)
> +			return 0;
>  
> -	while (*tail != '_')
>  		tail++;
> +	}

Can be simplified as:

	while (*tail != '\0' && *tail != '_')
		tail++;

But..as the name "prefix_underscores_count" suggests, shouldn't
it be:
	while (*tail == '_')
		tail++;
??

>  
>  	return tail - str;
>  }
