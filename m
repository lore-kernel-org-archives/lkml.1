Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701AbXDFTZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbXDFTZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXDFTZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:25:49 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:50965 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbXDFTZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:25:48 -0400
Date: Fri, 6 Apr 2007 21:24:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: handle spaces in array size
In-Reply-To: <20070406114730.02c82f43.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0704062117460.6042@yvahk01.tjqt.qr>
References: <20070406114730.02c82f43.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 11:47, Randy Dunlap wrote:
>
>Unfortunately, kernel-doc has problems with a struct field like this:
>	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];
>
>simply due to the spaces around the "+" sign, so drop all spaces inside
>[...] so that parsing is done correctly (in some sense).
>
>@@ -1452,6 +1452,12 @@ sub create_parameterlist($$$) {
> 	    $arg =~ s/\s*:\s*/:/g;
> 	    $arg =~ s/\s*\[/\[/g;
> 
>+	    # no spaces inside [array size expression];
>+	    # messes up split/pop/shift/unshift below;
>+	    while ($arg =~ m/\[.*\s.*\]/) {
>+		$arg =~ s/\[(.*)\s(.*)\]/\[$1$2\]/;
>+	    }
>+
> 	    my @args = split('\s*,\s*', $arg);
> 	    if ($args[0] =~ m/\*/) {
> 		$args[0] =~ s/(\*+)\s*/ $1/;

	while($arg =~ s/\[(.*)\s+(.*)\]/[$1$2]/) {
	}

should do it, and saves us the pre-matching. (Also note the + at \s)
(No need to escape [ and ] in the target pattern.)

I can also offer this gem which should do it the most saving way by
matching the inside of [] exactly once, and otherwise
matching/replacing only on \s:

	$arg =~ s{\[(.*)\]}{($_=$1)=~s/\s+//g;"[$_]"}e;

(I already hear everyone screaming... ;-)


Jan
-- 
