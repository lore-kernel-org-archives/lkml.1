Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab0BGQKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 11:10:47 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:37696 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0BGQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 11:10:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xBxB/YwncrZugLxEnHMoclev8aj/hoZWQ+rWjPtey/vFiucLkt/57huzBeZ7EvRjcD
         zCtXL+hpqyZwbZFDobNESZliWLsJYthI/K0666nwAmYEpRZgsC3wy0LyicDVeA2YJFh8
         yFlDIhNhp+Av2ZCrp9yAyfaLDbGHLTEkF3wVM=
Date: Mon, 8 Feb 2010 00:13:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org
Subject: Re: tags: include headers before source files
Message-ID: <20100207161311.GB17447@hack>
References: <Pine.LNX.4.64.1002031704550.6324@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002031704550.6324@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 05:25:27PM +0100, Guennadi Liakhovetski wrote:
>Currently looking up a structure definition in TAGS / tags takes one to 
>one of multiple "static struct X" definitions in arch sources, which makes 
>it for many structs practically impossible to get to the required header. 
>This patch changes the order of sources being tagged to first scan 
>architecture includes, then the top-level include/ directory, and only 
>then the rest. It also takes into account, that many architectures have 
>more than one include directory, i.e., not only arch/$ARCH/include, but 
>also arch/$ARCH/mach-X/include etc.

This is a good idea!

>
>Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>


Besides what Michal mentioned, this patch looks fine for me too.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

>---
>
>I am no expert in Kbuild, so, please, review, comment, suggest 
>improvements, but at least, this does make TAGS usable for me.
>
>diff --git a/scripts/tags.sh b/scripts/tags.sh
>index 1a0c44d..b84ce1c 100755
>--- a/scripts/tags.sh
>+++ b/scripts/tags.sh
>@@ -32,13 +32,18 @@ fi
> # find sources in arch/$ARCH
> find_arch_sources()
> {
>-	find ${tree}arch/$1 $ignore -name "$2" -print;
>+	for i in $archincludedir; do
>+		prune+="-wholename $i -prune -o "
>+	done
>+	find ${tree}arch/$1 $ignore $prune -name "$2" -print;
> }
> 
> # find sources in arch/$1/include
> find_arch_include_sources()
> {
>-	find ${tree}arch/$1/include $ignore -name "$2" -print;
>+	include=$(find ${tree}arch/$1/ -name include -type d);
>+	archincludedir+=$include
>+	find $include $ignore -name "$2" -print;
> }
> 
> # find sources in include/
>@@ -63,14 +68,15 @@ find_sources()
> 
> all_sources()
> {
>-	for arch in $ALLSOURCE_ARCHS
>-	do
>-		find_sources $arch '*.[chS]'
>-	done
>+	find_arch_include_sources $ARCH '*.[chS]'
> 	if [ ! -z "$archinclude" ]; then
> 		find_arch_include_sources $archinclude '*.[chS]'
> 	fi
> 	find_include_sources '*.[chS]'
>+	for arch in $ALLSOURCE_ARCHS
>+	do
>+		find_sources $arch '*.[chS]'
>+	done
> 	find_other_sources '*.[chS]'
> }
> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
