Return-Path: <linux-kernel-owner+w=401wt.eu-S965971AbXDGPLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965971AbXDGPLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 11:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966015AbXDGPLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 11:11:33 -0400
Received: from smtp112.plus.mail.re2.yahoo.com ([206.190.53.37]:30842 "HELO
	smtp112.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965971AbXDGPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 11:11:31 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 11:11:31 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=SIRLL28ut+dATnxE0iSbTCzXW8dqbQxCFjUXkBdI8Gu5E2yYm2/b6ByT8+in4sPvacz1a9v/i23dvazH6dzb0j6pCsLGCeWTAdLu55bE2cmTcMDIXKDMzXoHuazNGlfmwJ0kUU/imDnoMpwwOHhMi83DVKCGZld4pJWlxpU+GM0=  ;
X-YMail-OSG: Ju3J9zsVM1lOQAqp6Q2t_jrl84jhmgzS7DPvo4Ojp76k.4FTnwQhs8_eVjiyBTFNl5cBE21gezWxbv1R1Ulu6Abn_Z47hhHMw8KXc1031n2dhEMTg8UYqo72E0snYjVE6J5QNqCgY9O4LQ--
Date: Sat, 7 Apr 2007 17:04:44 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: handle arrays with arithmetic expressions as initializers <was Re: [PATCH v2] kernel-doc: handle spaces in array size>
Message-ID: <20070407150444.GC4048@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070406114730.02c82f43.randy.dunlap@oracle.com> <Pine.LNX.4.61.0704062117460.6042@yvahk01.tjqt.qr> <20070406160335.e125e287.randy.dunlap@oracle.com> <Pine.LNX.4.61.0704070138350.22181@yvahk01.tjqt.qr> <20070406175325.4bb3c904.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070406175325.4bb3c904.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 05:53:25PM -0700, Randy Dunlap wrote:
> From:	Jan Engelhardt <jengelh@linux01.gwdg.de>
> 
> Unfortunately, kernel-doc has problems with a struct field like this:
> 	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];
> 
> simply due to the spaces around the "+" sign, so drop all spaces inside
> [...] so that parsing is done correctly (in some sense).
> 
> Warning(linux-2.6.20-git15/include/linux/mtd/nand.h:304): No description found for parameter 'NAND_MAX_OOBSIZE]'
> 
> This needs to sit in -mm for awhile to see if it has any adverse effects.
> 
> And yes, this is just a hack until kernel-doc learns to do better
> parsing.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  scripts/kernel-doc |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-2.6.21-rc6.orig/scripts/kernel-doc
> +++ linux-2.6.21-rc6/scripts/kernel-doc
> @@ -1452,6 +1452,11 @@ sub create_parameterlist($$$) {
>  	    $arg =~ s/\s*:\s*/:/g;
>  	    $arg =~ s/\s*\[/\[/g;
>  
> +	    # no spaces inside [array size expression];
> +	    # messes up split/pop/shift/unshift below;
> +	    while ($arg =~ s/\[(.*)\s+(.*)\]/[$1$2]/) {
> +	    }
> +
>  	    my @args = split('\s*,\s*', $arg);
>  	    if ($args[0] =~ m/\*/) {
>  		$args[0] =~ s/(\*+)\s*/ $1/;
> -

In a different approach here's a patch that handles the special case of
composite arithmetic expressions in array size initializers. With it,
prior to pushing the split strings on the @first_arg array, I split the
keywords before the array name as before and then keep the array name
along with the subscript expression as a single whole element which gets
pushed last. In this manner, kernel-doc produces correct output without
removing whitespaces which makes the array subscripts unreadable in the docs.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--- 21-rc6/scripts/kernel-doc.orig	2007-04-07 16:48:51.000000000 +0200
+++ 21-rc6/scripts/kernel-doc	2007-04-07 16:51:17.000000000 +0200
@@ -1456,7 +1456,16 @@ sub create_parameterlist($$$) {
 	    if ($args[0] =~ m/\*/) {
 		$args[0] =~ s/(\*+)\s*/ $1/;
 	    }
-	    my @first_arg = split('\s+', shift @args);
+
+	    my @first_arg;
+	    if ($args[0] =~ /^(.*\s+)(.*?\[.*\].*)$/) {
+		    shift @args;
+		    push(@first_arg, split('\s+', $1));
+		    push(@first_arg, $2);
+	    } else {
+		    @first_arg = split('\s+', shift @args);
+	    }
+
 	    unshift(@args, pop @first_arg);
 	    $type = join " ", @first_arg;
 

-- 
Regards/Gruﬂ,
    Boris.
