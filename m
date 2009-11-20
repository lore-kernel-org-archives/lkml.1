Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZKTRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZKTRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZKTRZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:25:25 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:32986 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbZKTRZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EgxEdPqcKCB1XlzAcmhnbOHxBr6Y5w8bf5cClIZomxVToIK35BkzwzxBnW22klKY4a
         MpZqOSaaX22kQKq6glhbVjEXPxC+D0SALhDBYCfwfD68gN0k1aAopXDTEyzPxQLvIA0N
         KEUDseizRuD1dYI31e1NFsKKr5eqAfIMvBfa8=
MIME-Version: 1.0
In-Reply-To: <20091120164633.GC13136@tux>
References: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <20091120164633.GC13136@tux>
Date: Fri, 20 Nov 2009 17:25:25 +0000
Message-ID: <9b2b86520911200925r55e08858wceae2471fcf3b063@mail.gmail.com>
Subject: Re: [PATCH 2/4] kconfig: streamline_config.pl: fix out-of-tree builds
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> On Fri, Nov 20, 2009 at 07:50:52AM -0800, Alan Jenkins wrote:
>> We should look for Kconfig under $srctree, just like zconf.l does.
>> This allows "make localmodconfig" to work when using a separate build
>> directory (e.g. make O=../build).
>>
>> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> ---
>>  scripts/kconfig/streamline_config.pl |   10 +++++++---
>>  1 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/scripts/kconfig/streamline_config.pl
>> b/scripts/kconfig/streamline_config.pl
>> index 7d898e3..7a7bcf7 100644
>> --- a/scripts/kconfig/streamline_config.pl
>> +++ b/scripts/kconfig/streamline_config.pl
>> @@ -46,7 +46,7 @@ use warnings;
>>  #    make oldconfig
>>  #
>>  my $config = ".config";
>> -my $linuxpath = ".";
>> +my $srctree = $ENV{"srctree"} || ".";
>>
>>  my $uname = `uname -r`;
>>  chomp $uname;
>> @@ -114,7 +114,7 @@ sub find_config {
>>
>>  find_config;
>>
>> -my @makefiles = `find $linuxpath -name Makefile`;
>> +my @makefiles = `find $srctree -name Makefile`;
>>  my %depends;
>>  my %selects;
>>  my %prompts;
>> @@ -135,7 +135,11 @@ sub read_kconfig {
>>      my $config;
>>      my @kconfigs;
>>
>> -    open(KIN, $kconfig) || die "Can't open $kconfig";
>> +    open(KIN, $kconfig) || (
>> +       $kconfig =~ "^[^/]" &&
>> +       open(KIN, $srctree . "/" . $kconfig)
>> +    ) || die "Can't open $kconfig";
>> +
>
> God I hate perl, can this be a little perl-un-obfuscated a bit?

Agreed.  I'll simplify it to

$kconfig = $srctree . "/" . $kconfig;
open(KIN, $kconfig) || die "Can't open $kconfig";

I'll re-send when I've figured out how to stop CONFIG_ATA=m being
deselected.  (It looks like I need to handle "menuconfig" as well as
"config").

Thanks
Alan
