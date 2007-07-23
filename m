Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXGWXIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXGWXIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXGWXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:08:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:63807 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbXGWXI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:08:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="269643206"
Message-ID: <46A534EA.6030008@intel.com>
Date: Mon, 23 Jul 2007 16:08:26 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
In-Reply-To: <740c90243aaa6f6d4640d71230c4fa27@pinky>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2007 23:08:27.0798 (UTC) FILETIME=[60DC6B60:01C7CD7E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> This version brings a number of new checks, and a number of bug
> fixes.  Of note:
> 
>   - warnings for multiple assignments per line


This is bugged. e.g. the following line will hit this exception check:

	int i = some_function(a, b, c);



>   - warnings for multiple declarations per line
>   - checks for single statement blocks with braces
> 
> This patch includes an update for feature-removal-schedule.txt to
> better target checks.
> 
> Andy Whitcroft (12):
>       check for single statement braced blocks
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
> 
> +# check for redundant bracing round if etc
> +		if ($line =~ /\b(if|while|for|else)\b/) {
> +			# Locate the end of the opening statement.
> +			my @control = ctx_statement($linenr, $realcnt, 0);
> +			my $nr = $linenr + (scalar(@control) - 1);
> +			my $cnt = $realcnt - (scalar(@control) - 1);
> +
> +			my $off = $realcnt - $cnt;
> +			#print "$off: line<$line>end<" . $lines[$nr - 1] . ">\n";
> +
> +			# If this is is a braced statement group check it
> +			if ($lines[$nr - 1] =~ /{\s*$/) {
> +				my ($lvl, @block) = ctx_block_level($nr, $cnt);
> +
> +				my $stmt = join(' ', @block);
> +				$stmt =~ s/^[^{]*{//;
> +				$stmt =~ s/}[^}]*$//;
> +
> +				#print "block<" . join(' ', @block) . "><" . scalar(@block) . ">\n";
> +				#print "stmt<$stmt>\n\n";
> +
> +				# Count the ;'s if there is fewer than two
> +				# then there can only be one statement,
> +				# if there is a brace inside we cannot
> +				# trivially detect if its one statement.
> +				# Also nested if's often require braces to
> +				# disambiguate the else binding so shhh there.
> +				my @semi = ($stmt =~ /;/g);
> +				##print "semi<" . scalar(@semi) . ">\n";
> +				if ($lvl == 0 && scalar(@semi) < 2 &&
> +				    $stmt !~ /{/ && $stmt !~ /\bif\b/) {
> +				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
> +				    	shift(@block);
> +					ERROR("braces {} are not necessary for single statement blocks\n" . $herectx);


This is a royal pain, since it now throws an ERROR for the obviously preferable 
piece of code below:

if (err) {
	do_something();
	return -ERR;
} else {
	do_somthing_else();
}



Also, CondingStyle explicitly permits this style (even encourages it):

---
Do not unnecessarily use braces where a single statement will do.

if (condition)
	action();

This does not apply if one branch of a conditional statement is a single
statement. Use braces in both branches.

if (condition) {
	do_this();
	do_that();
} else {
	otherwise();
}
---

So, IMO this test needs to go, unless the script becomes smart enough to know 
that either side of the else requires braces. It's definately not an ERROR.

Cheers,

Auke
