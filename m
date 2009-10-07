Return-Path: <linux-kernel-owner+w=401wt.eu-S933876AbZJGCNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbZJGCNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZJGCNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:13:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZJGCNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:13:42 -0400
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Dick Streefland <dick@streefland.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20091006203540.GA14634@streefland.net>
References: <20091006203540.GA14634@streefland.net>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 06 Oct 2009 22:11:43 -0400
Message-Id: <1254881503.1696.115.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 22:35 +0200, Dick Streefland wrote:
> I've rewritten the extract-ikconfig script to extract the kernel
> configuration from a kernel compiled with CONFIG_IKCONFIG. The main
> motivation for the rewrite was to remove the dependency on the
> external C program binoffset.c, which is compiled on the initial run.
> 
> The binoffset executable is invoked with a relative path, which means
> that the old script can only be run from the top of the kernel tree,
> and only when you have write permission in the scripts directory.
> 
> The new script uses tr/grep/tail/zcat only, and can be invoked from
> anywhere. The binoffset.c program has been removed. This script
> requires GNU grep 2.5 (released 2002-03-13) or higher, because the -o
> option was introduced in that version.

Thanks Dick!

Now the question is, is this something that we should try to get into
the 32 release, or let this version go through linux-next for another
release?

-- Steve

> 
> Signed-off-by: Dick Streefland <dick@streefland.net>
> Tested-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> ---
> 
>  Documentation/dontdiff   |    1 -
>  scripts/.gitignore       |    1 -
>  scripts/binoffset.c      |  163 ----------------------------------------------
>  scripts/extract-ikconfig |  127 ++++++++++++-----------------------
>  4 files changed, 44 insertions(+), 248 deletions(-)
> 
> diff --git a/Documentation/dontdiff b/Documentation/dontdiff
> index e1efc40..bc01a5a 100644
> --- a/Documentation/dontdiff
> +++ b/Documentation/dontdiff
> @@ -68,7 +68,6 @@ autoconf.h*
>  bbootsect
>  bin2c
>  binkernel.spec
> -binoffset
>  bootsect
>  bounds.h
>  bsetup
> diff --git a/scripts/.gitignore b/scripts/.gitignore
> index 52cab46..c5d5db5 100644
> --- a/scripts/.gitignore
> +++ b/scripts/.gitignore
> @@ -6,5 +6,4 @@ kallsyms
>  pnmtologo
>  bin2c
>  unifdef
> -binoffset
>  ihex2fw
> diff --git a/scripts/binoffset.c b/scripts/binoffset.c
> deleted file mode 100644
> index 1a2e39b..0000000
> --- a/scripts/binoffset.c
> +++ /dev/null
> @@ -1,163 +0,0 @@
> -/***************************************************************************
> - * binoffset.c
> - * (C) 2002 Randy Dunlap <rdunlap@xenotime.net>
> -
> -#   This program is free software; you can redistribute it and/or modify
> -#   it under the terms of the GNU General Public License as published by
> -#   the Free Software Foundation; either version 2 of the License, or
> -#   (at your option) any later version.
> -#
> -#   This program is distributed in the hope that it will be useful,
> -#   but WITHOUT ANY WARRANTY; without even the implied warranty of
> -#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -#   GNU General Public License for more details.
> -#
> -#   You should have received a copy of the GNU General Public License
> -#   along with this program; if not, write to the Free Software
> -#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> -
> -# binoffset.c:
> -# - searches a (binary) file for a specified (binary) pattern
> -# - returns the offset of the located pattern or ~0 if not found
> -# - exits with exit status 0 normally or non-0 if pattern is not found
> -#   or any other error occurs.
> -
> -****************************************************************/
> -
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <string.h>
> -#include <errno.h>
> -#include <unistd.h>
> -#include <fcntl.h>
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <sys/mman.h>
> -
> -#define VERSION		"0.1"
> -#define BUF_SIZE	(16 * 1024)
> -#define PAT_SIZE	100
> -
> -char		*progname;
> -char		*inputname;
> -int		inputfd;
> -unsigned int	bix;			/* buf index */
> -unsigned char	patterns [PAT_SIZE] = {0}; /* byte-sized pattern array */
> -int		pat_len;		/* actual number of pattern bytes */
> -unsigned char	*madr;			/* mmap address */
> -size_t		filesize;
> -int		num_matches = 0;
> -off_t		firstloc = 0;
> -
> -void usage (void)
> -{
> -	fprintf (stderr, "%s ver. %s\n", progname, VERSION);
> -	fprintf (stderr, "usage:  %s filename pattern_bytes\n",
> -			progname);
> -	fprintf (stderr, "        [prints location of pattern_bytes in file]\n");
> -	exit (1);
> -}
> -
> -void get_pattern (int pat_count, char *pats [])
> -{
> -	int ix, err, tmp;
> -
> -#ifdef DEBUG
> -	fprintf (stderr,"get_pattern: count = %d\n", pat_count);
> -	for (ix = 0; ix < pat_count; ix++)
> -		fprintf (stderr, "  pat # %d:  [%s]\n", ix, pats[ix]);
> -#endif
> -
> -	for (ix = 0; ix < pat_count; ix++) {
> -		tmp = 0;
> -		err = sscanf (pats[ix], "%5i", &tmp);
> -		if (err != 1 || tmp > 0xff) {
> -			fprintf (stderr, "pattern or value error in pattern # %d [%s]\n",
> -					ix, pats[ix]);
> -			usage ();
> -		}
> -		patterns [ix] = tmp;
> -	}
> -	pat_len = pat_count;
> -}
> -
> -void search_pattern (void)
> -{
> -	for (bix = 0; bix < filesize; bix++) {
> -		if (madr[bix] == patterns[0]) {
> -			if (memcmp (&madr[bix], patterns, pat_len) == 0) {
> -				if (num_matches == 0)
> -					firstloc = bix;
> -				num_matches++;
> -			}
> -		}
> -	}
> -}
> -
> -#ifdef NOTDEF
> -size_t get_filesize (int fd)
> -{
> -	off_t end_off = lseek (fd, 0, SEEK_END);
> -	lseek (fd, 0, SEEK_SET);
> -	return (size_t) end_off;
> -}
> -#endif
> -
> -size_t get_filesize (int fd)
> -{
> -	int err;
> -	struct stat stat;
> -
> -	err = fstat (fd, &stat);
> -	fprintf (stderr, "filesize: %ld\n", err < 0 ? (long)err : stat.st_size);
> -	if (err < 0)
> -		return err;
> -	return (size_t) stat.st_size;
> -}
> -
> -int main (int argc, char *argv [])
> -{
> -	progname = argv[0];
> -
> -	if (argc < 3)
> -		usage ();
> -
> -	get_pattern (argc - 2, argv + 2);
> -
> -	inputname = argv[1];
> -
> -	inputfd = open (inputname, O_RDONLY);
> -	if (inputfd == -1) {
> -		fprintf (stderr, "%s: cannot open '%s'\n",
> -				progname, inputname);
> -		exit (3);
> -	}
> -
> -	filesize = get_filesize (inputfd);
> -
> -	madr = mmap (0, filesize, PROT_READ, MAP_PRIVATE, inputfd, 0);
> -	if (madr == MAP_FAILED) {
> -		fprintf (stderr, "mmap error = %d\n", errno);
> -		close (inputfd);
> -		exit (4);
> -	}
> -
> -	search_pattern ();
> -
> -	if (munmap (madr, filesize))
> -		fprintf (stderr, "munmap error = %d\n", errno);
> -
> -	if (close (inputfd))
> -		fprintf (stderr, "%s: error %d closing '%s'\n",
> -				progname, errno, inputname);
> -
> -	fprintf (stderr, "number of pattern matches = %d\n", num_matches);
> -	if (num_matches == 0)
> -		firstloc = ~0;
> -	printf ("%ld\n", firstloc);
> -	fprintf (stderr, "%ld\n", firstloc);
> -
> -	exit (num_matches ? 0 : 2);
> -}
> -
> -/* end binoffset.c */
> diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
> index de233ff..37f30d3 100755
> --- a/scripts/extract-ikconfig
> +++ b/scripts/extract-ikconfig
> @@ -1,92 +1,53 @@
>  #!/bin/sh
> -# extracts .config info from a [b]zImage file
> -# uses: binoffset (new), dd, zcat, strings, grep
> -# $arg1 is [b]zImage filename
> -
> -binoffset="./scripts/binoffset"
> -test -e $binoffset || cc -o $binoffset ./scripts/binoffset.c || exit 1
> -
> -IKCFG_ST="0x49 0x4b 0x43 0x46 0x47 0x5f 0x53 0x54"
> -IKCFG_ED="0x49 0x4b 0x43 0x46 0x47 0x5f 0x45 0x44"
> -dump_config() {
> -    file="$1"
> -
> -    start=`$binoffset $file $IKCFG_ST 2>/dev/null`
> -    [ "$?" != "0" ] && start="-1"
> -    if [ "$start" -eq "-1" ]; then
> -	return
> -    fi
> -    end=`$binoffset $file $IKCFG_ED 2>/dev/null`
> -    [ "$?" != "0" ] && end="-1"
> -    if [ "$end" -eq "-1" ]; then
> -	return
> -    fi
> -
> -    start=`expr $start + 8`
> -    size=`expr $end - $start`
> -
> -    dd if="$file" ibs=1 skip="$start" count="$size" 2>/dev/null | zcat
> -
> -    clean_up
> -    exit 0
> -}
> -
> -
> -usage()
> -{
> -	echo "  usage: extract-ikconfig [b]zImage_filename"
> -}
> -
> -clean_up()
> +# ----------------------------------------------------------------------
> +# extract-ikconfig - Extract the .config file from a kernel image
> +#
> +# This will only work when the kernel was compiled with CONFIG_IKCONFIG.
> +#
> +# The obscure use of the "tr" filter is to work around older versions of
> +# "grep" that report the byte offset of the line instead of the pattern.
> +#
> +# (c) 2009, Dick Streefland <dick@streefland.net>
> +# Licensed under the terms of the GNU General Public License.
> +# ----------------------------------------------------------------------
> +
> +gz1='\037\213\010'
> +gz2='01'
> +cf1='IKCFG_ST\037\213\010'
> +cf2='0123456789'
> +
> +dump_config()
>  {
> -	if [ "$TMPFILE" != "" ]; then
> -		rm -f $TMPFILE
> +	if	pos=`tr "$cf1\n$cf2" "\n$cf2=" < "$1" | grep -abo "^$cf2"`
> +	then
> +		pos=${pos%%:*}
> +		tail -c+$(($pos+8)) "$1" | zcat -q
> +		exit 0
>  	fi
>  }
>  
> -if [ $# -lt 1 ]
> +# Check invocation:
> +me=${0##*/}
> +img=$1
> +if	[ $# -ne 1 -o ! -s "$img" ]
>  then
> -	usage
> -	exit 1
> +	echo "Usage: $me <kernel-image>" >&2
> +	exit 2
>  fi
>  
> -TMPFILE=`mktemp -t ikconfig-XXXXXX` || exit 1
> -image="$1"
> -
> -# vmlinux: Attempt to dump the configuration from the file directly
> -dump_config "$image"
> -
> -GZHDR1="0x1f 0x8b 0x08 0x00"
> -GZHDR2="0x1f 0x8b 0x08 0x08"
> -
> -ELFHDR="0x7f 0x45 0x4c 0x46"
> -
> -# vmlinux.gz: Check for a compressed images
> -off=`$binoffset "$image" $GZHDR1 2>/dev/null`
> -[ "$?" != "0" ] && off="-1"
> -if [ "$off" -eq "-1" ]; then
> -	off=`$binoffset "$image" $GZHDR2 2>/dev/null`
> -	[ "$?" != "0" ] && off="-1"
> -fi
> -if [ "$off" -eq "0" ]; then
> -	zcat <"$image" >"$TMPFILE"
> -	dump_config "$TMPFILE"
> -elif [ "$off" -ne "-1" ]; then
> -	(dd ibs="$off" skip=1 count=0 && dd bs=512k) <"$image" 2>/dev/null | \
> -		zcat >"$TMPFILE"
> -	dump_config "$TMPFILE"
> -
> -# check if this is simply an ELF file
> -else
> -	off=`$binoffset "$image" $ELFHDR 2>/dev/null`
> -	[ "$?" != "0" ] && off="-1"
> -	if [ "$off" -eq "0" ]; then
> -		dump_config "$image"
> -	fi
> -fi
> -
> -echo "ERROR: Unable to extract kernel configuration information."
> -echo "       This kernel image may not have the config info."
> -
> -clean_up
> +# Initial attempt for uncompressed images or objects:
> +dump_config "$img"
> +
> +# That didn't work, so decompress and try again:
> +tmp=/tmp/ikconfig$$
> +trap "rm -f $tmp" 0
> +for	pos in `tr "$gz1\n$gz2" "\n$gz2=" < "$img" | grep -abo "^$gz2"`
> +do
> +	pos=${pos%%:*}
> +	tail -c+$pos "$img" | zcat 2> /dev/null > $tmp
> +	dump_config $tmp
> +done
> +
> +# Bail out:
> +echo "$me: Cannot find kernel config." >&2
>  exit 1

