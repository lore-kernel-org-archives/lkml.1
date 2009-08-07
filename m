Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZHGBka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZHGBka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZHGBka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:40:30 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:60061 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZHGBk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rNjbToACq+StIWuVNb1368xYOg8jEQutZFNkWVM/Id4gME3oWg8glyq6EbslzHWeFp
         gE8tadBTV6v59TokF8RG3Fxytm4Ass4vTqmXxC39NKoiuMlWliOIymhCu5KD1x9boScP
         84IV6mQA11wU3Aya2pa5+jtU5Yf1uWeK3MktU=
Date: Fri, 7 Aug 2009 09:42:34 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] markup_oops: Use modinfo to avoid confusion with
	underscored module names
Message-ID: <20090807014234.GA5047@cr0.nay.redhat.com>
References: <1249561315-2227-1-git-send-email-ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249561315-2227-1-git-send-email-ozan@pardus.org.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 03:21:55PM +0300, Ozan Çağlayan wrote:
>When EIP is at a module having an underscore in its name, the current
>code fails to find it because the module filenames has '-' instead of
>'_'.
>
>Use modinfo to correctly get the full path to the module.
>
>Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
>---
>This is just a trivial patch to pinpoint the problem. Usage of modinfo is faster than
>searching through the filesystem but may not be desirable as it brings a dependency
>to module-init-tools. Replacing underscore occurences by '-' can be another solution.
>
> scripts/markup_oops.pl |    5 +----
> 1 files changed, 1 insertions(+), 4 deletions(-)
>
>diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
>index 8977401..bc14f4c 100644
>--- a/scripts/markup_oops.pl
>+++ b/scripts/markup_oops.pl
>@@ -184,10 +184,7 @@ if ($target eq "0") {
> 
> # if it's a module, we need to find the .ko file and calculate a load offset
> if ($module ne "") {
>-	my $dir = dirname($filename);
>-	$dir = $dir . "/";
>-	my $mod = $module . ".ko";
>-	my $modulefile = `find $dir -name $mod | head -1`;
>+	my $modulefile = `modinfo $module | grep 'filename' | gawk '{ print \$2 }'`;


I know this works, but how about grep '^filename:' ? This is more strict.

Also, although on most Linux awk is just a symbol link to gawk,
but it is still better to use awk instead of gawk for portability reason.


> 	chomp($modulefile);
> 	$filename = $modulefile;
> 	if ($filename eq "") {
