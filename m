Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYL2NXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYL2NXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYL2NXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:23:25 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33115 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYL2NXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:23:25 -0500
Date: Mon, 29 Dec 2008 14:24:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: warn about headers using __[us]{8,16,32,64} types w/out linux/types.h
Message-ID: <20081229132456.GA6938@uranus.ravnborg.org>
References: <1230553127-953-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230553127-953-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 07:18:47AM -0500, Mike Frysinger wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/headers_check.pl |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> index bdd9fb6..5036319 100644
> --- a/scripts/headers_check.pl
> +++ b/scripts/headers_check.pl
> @@ -37,6 +37,7 @@ foreach my $file (@files) {
>  		check_include();
>  		check_prototypes();
>  		check_config();
> +		check_sizetypes();
>  	}
>  	close FH;
>  }
> @@ -72,3 +73,22 @@ sub check_config
>  		printf STDERR "$filename:$lineno: leaks CONFIG_$1 to userspace where it is not valid\n";
>  	}
>  }
> +
> +my $linux_types;
> +sub check_sizetypes
> +{
> +	if ($lineno == 1) {
> +		$linux_types = 0;
> +	} elsif ($linux_types) {
> +		return;
> +	}
> +	if ($line =~ m/^\s*#\s*include\s+<linux\/types.h>/) {
> +		$linux_types = 1;
> +		return;
> +	}
> +	if ($line =~ m/__[us](8|16|32|64)\b/) {
> +		printf STDERR "$filename:$lineno: found __[us]{8,16,32,64} type w/out #include <linux/types.h>\n";
> +		# Warn until headers are all fixed
> +		#$ret = 1;
> +	}
> +}

We do not need to warn for each line in a file. Only once is enough.
Also I assume that include <asm/types.h> is also ok.

It looks like this now. Acceptable?

kbuild-next.git is updated now (but not with this patch).

	Sam

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 72924a7..27a0d1f 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -35,6 +35,7 @@ foreach my $file (@files) {
 	while ($line = <FH>) {
 		$lineno++;
 		check_include();
+		check_sizetypes();
 		check_prototypes();
 		check_config();
 	}
@@ -73,3 +74,27 @@ sub check_config
 	}
 }
 
+my $linux_types;
+sub check_sizetypes
+{
+	if ($lineno == 1) {
+		$linux_types = 0;
+	} elsif ($linux_types >= 1) {
+		return;
+	}
+	if ($line =~ m/^\s*#\s*include\s+<linux\/types.h>/) {
+		$linux_types = 1;
+		return;
+	}
+	if ($line =~ m/^\s*#\s*include\s+<asm\/types.h>/) {
+		$linux_types = 1;
+		return;
+	}
+	if ($line =~ m/__[us](8|16|32|64)\b/) {
+		printf STDERR "$filename:$lineno: found __[us]{8,16,32,64} type w/out #include <linux/types.h>\n";
+		$linux_types = 2;
+		# Warn until headers are all fixed
+		#$ret = 1;
+	}
+}
+
