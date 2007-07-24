Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbXGXJHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbXGXJHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbXGXJHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:07:05 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3572 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbXGXJHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:07:03 -0400
Message-ID: <46A5C12B.3080904@shadowen.org>
Date: Tue, 24 Jul 2007 10:06:51 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com>
In-Reply-To: <46A534EA.6030008@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Andy Whitcroft wrote:
>> This version brings a number of new checks, and a number of bug
>> fixes.  Of note:
>>
>>   - warnings for multiple assignments per line
> 
> 
> This is bugged. e.g. the following line will hit this exception check:
> 
>     int i = some_function(a, b, c);

Yep that is plainly wrong.  Will sort that one out.

>>   - warnings for multiple declarations per line
>>   - checks for single statement blocks with braces
>>
>> This patch includes an update for feature-removal-schedule.txt to
>> better target checks.
>>
>> Andy Whitcroft (12):
>>       check for single statement braced blocks
>>
>> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
>> ---
>>
>> +# check for redundant bracing round if etc
>> +        if ($line =~ /\b(if|while|for|else)\b/) {
>> +            # Locate the end of the opening statement.
>> +            my @control = ctx_statement($linenr, $realcnt, 0);
>> +            my $nr = $linenr + (scalar(@control) - 1);
>> +            my $cnt = $realcnt - (scalar(@control) - 1);
>> +
>> +            my $off = $realcnt - $cnt;
>> +            #print "$off: line<$line>end<" . $lines[$nr - 1] . ">\n";
>> +
>> +            # If this is is a braced statement group check it
>> +            if ($lines[$nr - 1] =~ /{\s*$/) {
>> +                my ($lvl, @block) = ctx_block_level($nr, $cnt);
>> +
>> +                my $stmt = join(' ', @block);
>> +                $stmt =~ s/^[^{]*{//;
>> +                $stmt =~ s/}[^}]*$//;
>> +
>> +                #print "block<" . join(' ', @block) . "><" .
>> scalar(@block) . ">\n";
>> +                #print "stmt<$stmt>\n\n";
>> +
>> +                # Count the ;'s if there is fewer than two
>> +                # then there can only be one statement,
>> +                # if there is a brace inside we cannot
>> +                # trivially detect if its one statement.
>> +                # Also nested if's often require braces to
>> +                # disambiguate the else binding so shhh there.
>> +                my @semi = ($stmt =~ /;/g);
>> +                ##print "semi<" . scalar(@semi) . ">\n";
>> +                if ($lvl == 0 && scalar(@semi) < 2 &&
>> +                    $stmt !~ /{/ && $stmt !~ /\bif\b/) {
>> +                        my $herectx = "$here\n" . join("\n",
>> @control, @block[1 .. $#block]) . "\n";
>> +                        shift(@block);
>> +                    ERROR("braces {} are not necessary for single
>> statement blocks\n" . $herectx);
> 
> 
> This is a royal pain, since it now throws an ERROR for the obviously
> preferable piece of code below:
> 
> if (err) {
>     do_something();
>     return -ERR;
> } else {
>     do_somthing_else();
> }

Hmmm, is that obviouly nicer than the below?  Its fully a line longer
for no benefit.  But ignoring that, this seems to have snuck in to
CodingStyle hmmm ... will see what I can do if anything to stop these
being picked up I guess.

	if (err) {
		do_something();
		return -ERR;
	} else
		do_something_else();

Andrew, as you merged the change to CodingStyle I'll take that as your
being ok with these being accepted.

-apw
