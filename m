Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0BTIdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:33:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43639 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0BTIdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:33:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nWPatHnE90fzW09qrPjIe/yvwMRNB19SiXjn7IyuuJOgr9npe7Og3HPfPHiHm9y6gZ
         5GM8DVQQS0KFBOnclwg/Xf0kfh/3svKxjak01K1oBuyTi7Ein0wmXtU62bzMY5irCM8C
         o+kqANmZc4USXiey3m+BQhIuFyAPAXXyrKqmw=
MIME-Version: 1.0
In-Reply-To: <20100219175429.826376846@vyatta.com>
References: <20100219175217.385580142@vyatta.com> <20100219175429.826376846@vyatta.com>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 20 Feb 2010 16:26:24 +0800
Message-ID: <daef60381002200026g64b09344m51b798315707179d@mail.gmail.com>
Subject: Re: [PATCH 04/10] namespace: perlcritic warnings
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       =?UTF-8?B?VXdlIEtsZWluZS1LxILFm25pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       WANG Cong <amwang@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       =?UTF-8?Q?Ozan_=C4=82aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1K8YRmE028097

On Sat, Feb 20, 2010 at 01:52, Stephen Hemminger <shemminger@vyatta.com> wrote:> Use local file handle not global.> Make loop and other variables local in scope.>> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>>>> --- a/scripts/namespace.pl      2010-02-19 08:59:00.432184740 -0800> +++ b/scripts/namespace.pl      2010-02-19 09:05:52.672644797 -0800> @@ -175,12 +175,11 @@ sub do_nm>        }>        if (! -e "$source.c" && ! -e "$source.S") {>                # No obvious source, exclude the object if it is conglomerate> -               if (! open(OBJDUMPDATA, "$objdump $basename|")) {> -                       printf STDERR "$objdump $fullname failed $!\n";> -                       return;> -               }> +               open(my $objdumpdata, "$objdump $basename|")> +                   or die "$objdump $fullname failed $!\n";
Looks it just want return, are you sure have to change it to die?
> +>                my $comment;> -               while (<OBJDUMPDATA>) {> +               while (<$objdumpdata>) {>                        chomp();>                        if (/^In archive/) {>                                # Archives are always conglomerate> @@ -190,18 +189,18 @@ sub do_nm>                        next if (! /^[ 0-9a-f]{5,} /);>                        $comment .= substr($_, 43);>                }> -               close(OBJDUMPDATA);> +               close($objdumpdata);> +>                if (!defined($comment) || $comment !~ /GCC\:.*GCC\:/m) {>                        printf STDERR "No source file found for $fullname\n";>                }>                return;>        }> -       if (! open(NMDATA, "$nm $basename|")) {> -               printf STDERR "$nm $fullname failed $!\n";> -               return;> -       }> +       open (my $nmdata, "$nm $basename|")> +           or die "$nm $fullname failed $!\n";> +>        my @nmdata;> -       while (<NMDATA>) {> +       while (<$nmdata>) {>                chop;>                ($type, $name) = (split(/ +/, $_, 3))[1..2];>                # Expected types> @@ -268,7 +267,8 @@ sub do_nm>                        }>                }>        }> -       close(NMDATA);> +       close($nmdata);> +>        if ($#nmdata < 0) {>                if (>                        $fullname ne "lib/brlock.o"> @@ -316,8 +316,7 @@ sub drop_def>>  sub list_multiply_defined>  {> -       my ($name, $module);> -       foreach $name (keys(%def)) {> +       foreach my $name (keys(%def)) {>                if ($#{$def{$name}} > 0) {>                        # Special case for cond_syscall>                        if ($#{$def{$name}} == 1 && $name =~ /^sys_/ &&> @@ -333,8 +332,9 @@ sub list_multiply_defined>                                &drop_def("arch/x86/kernel/vsyscall-sysenter_32.o", $name);>                                next;>                        }> +>                        printf "$name is multiply defined in :-\n";> -                       foreach $module (@{$def{$name}}) {> +                       foreach my $module (@{$def{$name}}) {>                                printf "\t$module\n";>                        }>                }> @@ -343,12 +343,13 @@ sub list_multiply_defined>>  sub resolve_external_references>  {> -       my ($object, $type, $name, $i, $j, $kstrtab, $ksymtab, $export);> +       my ($kstrtab, $ksymtab, $export);> +>        printf "\n";> -       foreach $object (keys(%nmdata)) {> +       foreach my $object (keys(%nmdata)) {>                my $nmdata = $nmdata{$object};> -               for ($i = 0; $i <= $#{$nmdata}; ++$i) {> -                       ($type, $name) = split(' ', $nmdata->[$i], 2);> +               for (my $i = 0; $i <= $#{$nmdata}; ++$i) {> +                       my ($type, $name) = split(' ', $nmdata->[$i], 2);>                        if ($type eq "U" || $type eq "w") {>                                if (exists($def{$name}) || exists($ksymtab{$name})) {>                                        # add the owning object to the nmdata> @@ -357,7 +358,7 @@ sub resolve_external_references>                                        $kstrtab = "R __kstrtab_$name";>                                        $ksymtab = "R __ksymtab_$name";>                                        $export = 0;> -                                       for ($j = 0; $j <= $#{$nmdata}; ++$j) {> +                                       for (my $j = 0; $j <= $#{$nmdata}; ++$j) {>                                                if ($nmdata->[$j] eq $kstrtab ||>                                                    $nmdata->[$j] eq $ksymtab) {>                                                        $export = 1;> @@ -424,11 +425,11 @@ sub resolve_external_references>  sub list_extra_externals>  {>        my %noref = ();> -       my ($name, @module, $module, $export);> -       foreach $name (keys(%def)) {> +> +       foreach my $name (keys(%def)) {>                if (! exists($ref{$name})) {> -                       @module = @{$def{$name}};> -                       foreach $module (@module) {> +                       my @module = @{$def{$name}};> +                       foreach my $module (@module) {>                                if (! exists($noref{$module})) {>                                        $noref{$module} = [];>                                }> @@ -438,16 +439,16 @@ sub list_extra_externals>        }>        if (%noref) {>                printf "\nExternally defined symbols with no external references\n";> -               foreach $module (sort(keys(%noref))) {> +               foreach my $module (sort(keys(%noref))) {>                        printf "  $module\n";>                        foreach (sort(@{$noref{$module}})) {> -                               if (exists($export{$_})) {> -                                       $export = " (export only)";> -                               }> -                               else {> -                                       $export = "";> -                               }> -                               printf "    $_$export\n";> +                           my $export;> +                           if (exists($export{$_})) {> +                               $export = " (export only)";> +                           } else {> +                               $export = "";> +                           }> +                           printf "    $_$export\n";>                        }>                }>        }>> -->>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
