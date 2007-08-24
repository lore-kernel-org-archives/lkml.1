Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbXHXQFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbXHXQFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXHXQFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:05:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59738 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXHXQFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:05:33 -0400
Date: Fri, 24 Aug 2007 09:03:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rpjday@mindspring.com
Subject: Re: [PATCH] Script to check for undefined Kconfig symbols - v2
Message-Id: <20070824090325.84e6cf7e.randy.dunlap@oracle.com>
In-Reply-To: <20070824145649.18124.33973.stgit@americanbeauty.home.lan>
References: <20070824145649.18124.33973.stgit@americanbeauty.home.lan>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 16:56:49 +0200 Paolo 'Blaisorblade' Giarrusso wrote:

> In this version, I've updated the scripts to search for "\<$symb_bare\>" instead
> of $symb_bare in Kconfig files. Please ignore my previous message.
> 
> To avoid to look manually for used but undefined Kconfig variables, I've
> written a script which tries do this efficiently, in case all other attention
> fail. It accounts for _MODULE suffix and for UML_ prefixes to Kconfig variable,
> but otherwise looks for exact matches (i.e. \<CONFIG_; this is done to exclude
> macros like MMCONFIG_).
> 
> Undefined Kconfig variables should be not be removed without care, but for
> instance arch/i386/boot/ uses a bunch of undefined Kconfig vars:
> 
> $ scripts/checkunknowndefines.sh arch/i386/boot/
> arch/i386/boot/video.h uses undefined symbol VIDEO_400_HACK
> arch/i386/boot/video-vga.c uses undefined symbol VIDEO_400_HACK
> arch/i386/boot/video.c uses undefined symbol VIDEO_RETAIN
> arch/i386/boot/video.h uses undefined symbol VIDEO_RETAIN
> arch/i386/boot/video.h uses undefined symbol VIDEO_SVGA
> arch/i386/boot/video.h uses undefined symbol VIDEO_VESA
> arch/i386/boot/video-vesa.c uses undefined symbol VIDEO_VESA
> 
> Hope you can merge this in -mm and use it frequently (probably, a script to look for
> regressions in its output is useful). It should also be mentioned in
> SubmittingPatches if you agree.

or added to Documentation/SubmitChecklist.

How does this script compare to
http://www.fsdev.net/wiki/index.php?title=Misspelled_CONFIG_variables
and
http://www.fsdev.net/wiki/index.php?title=Dead_CONFIG_variables
?


> Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> ---
> 
>  scripts/checkunknowndefines.sh |   59 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkunknowndefines.sh b/scripts/checkunknowndefines.sh
> new file mode 100755
> index 0000000..dbb5cef
> --- /dev/null
> +++ b/scripts/checkunknowndefines.sh
> @@ -0,0 +1,59 @@
> +#!/bin/sh
> +# Find Kconfig variables used in source code but never defined in Kconfig
> +# Copyright (C) 2007, Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> +
> +# Tested with dash.
> +paths="$@"
> +[ -z "$paths" ] && paths=.
> +
> +# Doing this once at the beginning saves a lot of time, on a cache-hot tree.
> +Kconfigs="`find . -name 'Kconfig' -o -name 'Kconfig*[^~]'`"
> +
> +echo "File list \tundefined symbol used"
> +find $paths -name '*.[chS]' -o -name 'Makefile' -o -name 'Makefile*[^~]'| while read i
> +do
> +	# Output the bare Kconfig variable and the filename; the _MODULE part at
> +	# the end is not removed here (would need perl an not-hungry regexp for that).
> +	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Z_]\+\).*!\2 '$i'!p' < $i
> +done | \
> +# Smart "sort|uniq" implemented in awk and tuned to collect the names of all
> +# files which use a given symbol
> +awk '{map[$1, count[$1]++] = $2; }
> +END {
> +	for (combIdx in map) {
> +		split(combIdx, separate, SUBSEP);
> +		# The value may have been removed.
> +		if (! ( (separate[1], separate[2]) in map ) )
> +			continue;
> +		symb=separate[1];
> +		printf "%s ", symb;
> +		#Use gawk extension to delete the names vector
> +		delete names;
> +		#Portably delete the names vector
> +		#split("", names);
> +		for (i=0; i < count[symb]; i++) {
> +			names[map[symb, i]] = 1;
> +			# Unfortunately, we may still encounter symb, i in the
> +			# outside iteration.
> +			delete map[symb, i];
> +		}
> +		i=0;
> +		for (name in names) {
> +			if (i > 0)
> +				printf ", %s", name;
> +			else
> +				printf "%s", name;
> +			i++;
> +		}
> +		printf "\n";
> +	}
> +}' |
> +while read symb files; do
> +	# Remove the _MODULE suffix when checking the variable name. This should
> +	# be done only on tristate symbols, actually, but Kconfig parsing is
> +	# beyond the purpose of this script.
> +	symb_bare=`echo $symb | sed -e 's/_MODULE//'`
> +	if ! grep -q "\<$symb_bare\>" $Kconfigs; then
> +		echo "$files: \t$symb"
> +	fi
> +done|sort


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
