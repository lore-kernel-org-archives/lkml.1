Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZFXCNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZFXCNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 22:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFXCND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 22:13:03 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:50260 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZFXCNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 22:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=maATQ1jG0XPjKfmYeoUytiNUIeUDQO1BZut9iWTawCw5cnLK2PKNoWeoYaylEzD0bH
         w15EjhngawHJU3/JLiHRgQCwj7/8K1X9Zal+xRkmhAAnEsCI4QvPSSktDXNtd0y0Wt0f
         nRa5BOKyYXaPvC/SgcpuuDxDLUlmqJJKC4P00=
Date: Wed, 24 Jun 2009 10:15:06 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Dick Streefland <dick@streefland.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090624021506.GA5871@cr0.nay.redhat.com>
References: <20090623225245.GA10443@streefland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623225245.GA10443@streefland.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 12:52:45AM +0200, Dick Streefland wrote:
>I've rewritten the extract-ikconfig script to extract the kernel
>configuration from a kernel compiled with CONFIG_IKCONFIG. The main
>motivation for the rewrite was to remove the dependency on the
>external C program binoffset.c, which is compiled on the initial run.
>
>The binoffset executable is invoked with a relative path, which means
>that the old script can only be run from the top of the kernel tree,
>and only when you have write permission in the scripts directory.
>The new script uses echo/grep/tail/zcat only, and can be invoked from
>anywhere. The binoffset.c program has been removed.
>
>Signed-off-by: Dick Streefland <dick@streefland.net>

<snip>

>+gzip_header=`/bin/echo -en '\x1f\x8b\x08'`
>+ikconfig_header="IKCFG_ST$gzip_header"
>+
>+dump_config()
> {
>-	echo "  usage: extract-ikconfig [b]zImage_filename"
>-}
>-
>-clean_up()
>-{
>-	if [ "$TMPFILE" != "" ]; then
>-		rm -f $TMPFILE
>+	if	pos=`grep -abo "$ikconfig_header" "$1"`


Are you sure this 'grep' works well?

My tests on a binary file told me no.

>+	then
>+		pos=${pos%%:*}
>+		tail -c+$(($pos+8+1)) "$1" | zcat -q
>+		exit 0
> 	fi
> }
> 
>-if [ $# -lt 1 ]
>+# Check invocation:
>+me=${0##*/}
>+img=$1
>+if	[ $# -ne 1 -o ! -s "$img" ]
> then
>-	usage
>-	exit 1
>+	echo "Usage: $me <kernel-image>" >&2
>+	exit 2
> fi
> 
>-TMPFILE=`mktemp -t ikconfig-XXXXXX` || exit 1
>-image="$1"
>-
>-# vmlinux: Attempt to dump the configuration from the file directly
>-dump_config "$image"
>-
>-GZHDR1="0x1f 0x8b 0x08 0x00"
>-GZHDR2="0x1f 0x8b 0x08 0x08"
>-
>-# vmlinux.gz: Check for a compressed images
>-off=`$binoffset "$image" $GZHDR1 2>/dev/null`
>-[ "$?" != "0" ] && off="-1"
>-if [ "$off" -eq "-1" ]; then
>-	off=`$binoffset "$image" $GZHDR2 2>/dev/null`
>-	[ "$?" != "0" ] && off="-1"
>-fi
>-if [ "$off" -eq "0" ]; then
>-	zcat <"$image" >"$TMPFILE"
>-	dump_config "$TMPFILE"
>-elif [ "$off" -ne "-1" ]; then
>-	(dd ibs="$off" skip=1 count=0 && dd bs=512k) <"$image" 2>/dev/null | \
>-		zcat >"$TMPFILE"
>-	dump_config "$TMPFILE"
>-fi
>-
>-echo "ERROR: Unable to extract kernel configuration information."
>-echo "       This kernel image may not have the config info."
>-
>-clean_up
>+# Initial attempt for uncompressed images or objects:
>+dump_config "$img"
>+
>+# That didn't work, so decompress and try again:
>+tmp=/tmp/ikconfig$$
>+trap "rm -f $tmp" 0


Why do you use trap instead of doing this explicitly
on exit?


>+for	pos in `grep -abo "$gzip_header" "$img"`

Also here...

Can we have more than one $gzip_header? But even if yes,
grep only reports the first one I am afraid, or at least,
the first one in one "line".

>+do
>+	pos=${pos%%:*}
>+	tail -c+$(($pos+1)) "$img" | zcat -q > $tmp
>+	dump_config $tmp
>+done
>+
>+# Bail out:
>+echo "$me: Cannot find kernel config." >&2
> exit 1
