Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbZKOI5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbZKOI5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZKOI5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:57:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47834 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbZKOI5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:57:20 -0500
Date: Sun, 15 Nov 2009 09:57:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2] perf tools: New function to parse string representing
 size in bytes
Message-ID: <20091115085711.GB27393@elte.hu>
References: <20091115.171553.84484979.mitake@dcl.info.waseda.ac.jp>
 <1258273022-1504-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258273022-1504-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> This patch modifies util/string.[ch] to add new function: bytesexp2int()
> to parse string representing size in bytes.
> 
> This is version 2. Acording to Frederic and Ingo's advice,
> I removed static function digit() and rewrote to use
> isdigit() macro of util.h.
> 
> Below is the description of bytesexp2int().
> 
> Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
> and return its numeric value. (e.g. 268435456)
> 
> The parameter str is not changed before and after calling,
> but it changed temporally and internally for atoi().
> So type of str is char *, not const char *.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/util/string.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/string.h |    1 +
>  2 files changed, 83 insertions(+), 0 deletions(-)

Please run checkpatch on patches in the future, for this patch it shows 
this small problem:

ERROR: trailing whitespace
#68: FILE: tools/perf/util/string.c:66:
+^I$

> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index 04743d3..1ee7b17 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -1,4 +1,5 @@
>  #include <string.h>
> +#include <stdlib.h>
>  #include "string.h"
>  
>  static int hex(char ch)
> @@ -43,3 +44,84 @@ char *strxfrchar(char *s, char from, char to)
>  
>  	return s;
>  }
> +
> +#define K 1024
> +/*
> + * bytesexp2int()
> + * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
> + * and return its numeric value
> + *
> + * The parameter str is not changed before and after calling,
> + * but it changed temporally and internally for atoi().
> + * So type of str is char *, not const char *.
> + */
> +int bytesexp2int(char *str)

why not to longlong?

> +{
> +	int i, unit = 1;
> +	char shelter = '\0';
> +	size_t length = -1;
> +
> +	if (!isdigit(str[0]))
> +		goto err;
> +	
> +	for (i = 1; i < (int)strlen(str); i++) {

This extra '(int)' cast should be eliminated. In the kernel we avoid 
unnecessary casts - here i suspect it can be done by changing 'int i' to 
'unsigned int i'.

> +		switch (str[i]) {
> +		case 'B':
> +		case 'b':
> +			break;
> +		case 'K':
> +			if (str[i + 1] != 'B')
> +				goto err;
> +			else
> +				goto kilo;
> +		case 'k':
> +			if (str[i + 1] != 'b')
> +				goto err;
> +kilo:
> +			unit = K;
> +			break;
> +		case 'M':
> +			if (str[i + 1] != 'B')
> +				goto err;
> +			else
> +				goto mega;
> +		case 'm':
> +			if (str[i + 1] != 'b')
> +				goto err;
> +mega:
> +			unit = K * K;
> +			break;
> +		case 'G':
> +			if (str[i + 1] != 'B')
> +				goto err;
> +			else
> +				goto giga;
> +		case 'g':
> +			if (str[i + 1] != 'b')
> +				goto err;
> +giga:
> +			unit = K * K * K;
> +			break;
> +		case '\0':	/* only specified figures */
> +			unit = 1;
> +			break;
> +		default:
> +			if (!isdigit(str[i]))
> +				goto err;
> +			break;

(Might want to add tera as well, just in case this gets librarized into 
the rest of the kernel some day.)

> +		}
> +	}
> +
> +	shelter = str[i];
> +	str[i] = (char)'\0';

a spurious type cast again - they should really be avoided. Here it's 
unnecessary, character literals should auto-convert to the proper type 
just fine.


> +	length = atoi(str) * unit;
> +	if (shelter != '\0')
> +		str[i] = shelter;
> +
> +	goto end;
> +
> +err:
> +	length = -1;
> +end:
> +	return length;
> +}

small naming nit, please use 'out_err:' and 'out:' labels. (which is how 
we generally name such exception exit points)


Thanks,

	Ingo
