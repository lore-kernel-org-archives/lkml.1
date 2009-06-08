Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZFHXjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZFHXjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZFHXjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:39:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070AbZFHXjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:39:35 -0400
Date: Mon, 8 Jun 2009 16:38:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: riel@redhat.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Add a gfp-translate script to help understand page
 allocation failure reports
Message-Id: <20090608163827.47b4738b.akpm@linux-foundation.org>
In-Reply-To: <20090608132950.GB15070@csn.ul.ie>
References: <20090608132950.GB15070@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 14:29:50 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> The page allocation failure messages include a line that looks like
> 
> page allocation failure. order:1, mode:0x4020
> 
> The mode is easy to translate but irritating for the lazy and a bit error
> prone. This patch adds a very simple helper script gfp-translate for the mode:
> portion of the page allocation failure messages. An example usage looks like
> 
>   mel@machina:~/linux-2.6 $ scripts/gfp-translate 0x4020
>   Source: /home/mel/linux-2.6
>   Parsing: 0x4020
>   #define __GFP_HIGH	(0x20)	/* Should access emergency pools? */
>   #define __GFP_COMP	(0x4000) /* Add compound page metadata */
> 
> The script is not a work of art but it has come in handy for me a few times
> so I thought I would share.
> 

hm, OK.  Most of the gfp masks I have to decode are in emails and
bugzilla reports.  I guess I'm different.  Plus I wouldn't trust a tool
run on my machine's kernel tree to correctly interpret a gfp mask from
someone else's kernel of different vintage.

But I can see that it would be useful for someone who's debugging a
locally built kernel.

> diff --git a/scripts/gfp-translate b/scripts/gfp-translate
> new file mode 100755

I don't know how to get patches into Linus's tree with the X bit still
set :(  To avoid solving that problem, maybe Pekka can merge this?

> +# Guess the kernel source directory if it's not set. Preference is in order of
> +# o current directory
> +# o /usr/src/linux
> +if [ "$SOURCE" = "" ]; then
> +	if [ -r "/usr/src/linux/Makefile" ]; then
> +		SOURCE=/usr/src/linux
> +	fi
> +	if [ -r "`pwd`/Makefile" ]; then
> +		SOURCE=`pwd`
> +	fi
> +fi

OK.

> +# Confirm that a source directory exists
> +if [ ! -r "$SOURCE/Makefile" ]; then
> +	die "Could not locate source directory or it is invalid"
> +fi

"kernel source directory".

> +# Confirm that a GFP mask has been specified
> +if [ "$GFPMASK" = "none" ]; then
> +	usage
> +fi
> +
> +# Extract GFP flags from the kernel source
> +TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
> +grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
> +
> +# Parse the flags
> +IFS="
> +"
> +echo Source: $SOURCE
> +echo Parsing: $GFPMASK
> +for LINE in `cat $TMPFILE`; do
> +	MASK=`echo $LINE | awk '{print $3}'`
> +	if [ $(($GFPMASK&$MASK)) -ne 0 ]; then
> +		echo $LINE
> +	fi
> +done
> +
> +rm -f $TMPFILE
> +exit 0
