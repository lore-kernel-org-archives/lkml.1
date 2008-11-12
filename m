Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYKLOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYKLOXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 09:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYKLOXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 09:23:38 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:31864 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYKLOXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 09:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=qLENOCDT6KWUCGisMbohh3e4BPfk6iPfakMOClPtWxLi3asyaZX5nk8ESXLGUAGe2A
         /G4UFwWV9NpCFDp1NwLSrzpXIIWiz8LzTEh/ApkEr0+g3urgGdheCkYrZ4JyQCmUPNfp
         c1icahNZ7FdQ+yqAsHAA68Yy3qn6Rxs7dRMPw=
Message-ID: <9ea470500811120623q4334f840t4540649edba935@mail.gmail.com>
Date: Wed, 12 Nov 2008 15:23:35 +0100
From: "Borislav Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH][RESEND] checkpatch: Add warning for p0-patches
Cc: "Wolfram Sang" <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20081112135522.GD8302@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de>
	 <20081112135522.GD8302@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 2:55 PM, Andy Whitcroft <apw@shadowen.org> wrote:
> On Fri, Oct 31, 2008 at 04:36:10PM +0100, Wolfram Sang wrote:
>> Some people work internally with -p0-patches which has the danger that
>> one forgets to convert them to -p1 before mainlining. Bitten myself and
>> seen p0-patches in mailing lists occasionally, this patch adds a warning
>> to checkpatch.pl in case a patch is -p0. If you really want, you can
>> fool this check to generate false positives, this is why it just spits a
>> warning. Making the check 100% proof is trickier than it looks, so let's
>> start with a version which catches the cases of real use.
>>
>> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
>> ---
>>  scripts/checkpatch.pl |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index f88bb3e..dae5854 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -1051,6 +1051,7 @@ sub process {
>>       my $in_comment = 0;
>>       my $comment_edge = 0;
>>       my $first_line = 0;
>> +     my $p1_prefix = '';
>>
>>       my $prev_values = 'E';
>>
>> @@ -1196,7 +1197,12 @@ sub process {
>>               # extract the filename as it passes
>>               if ($line=~/^\+\+\+\s+(\S+)/) {
>>                       $realfile = $1;
>> -                     $realfile =~ s@^[^/]*/@@;
>> +                     $realfile =~ s@^([^/]*)/@@;
>> +
>> +                     $p1_prefix = $1;
>> +                     if ($tree && -e "$root/$p1_prefix") {
>> +                             WARN("Patch prefix '$p1_prefix' exists. Is it maybe a p0-patch?\n");
>> +                     }
>>
>>                       if ($realfile =~ m@^include/asm/@) {
>>                               ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
>
> Looks reasonable.  Committed this with a few mods to my tree.  Will be
> in the next batch of updates.

Hi,

I had sent you a very similar patch (see http://lkml.org/lkml/2007/12/17/19) and
and you turned it down then since it would trigger when the patch creates new
files. Well, this one suffers from the exact opposite problem - it won't trigger
even if it is a -p0 patch on new files, AFAICT.

-- 
Regards/Gruss,
Boris
