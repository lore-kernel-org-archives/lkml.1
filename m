Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190Ab0AZHxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0AZHxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577Ab0AZHxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:53:34 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:30074 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0AZHxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:53:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MRt6PWG7J8GaFRZSHhljc+UWA06gSPqKjT4pzc/F6ZGQV6Bi7mM/aKQCReYVWRWWww
         Ax3I/x89Jsebh0gKk1SADTx4Wh2mb/eJO3CP9/yYzojWnkRgnjBXIinAwmKMWkFd1Dsl
         YZai3RPSN6Mr0ruoko3lHx/EJlxOExfiWFEFU=
MIME-Version: 1.0
In-Reply-To: <4B5E9BE9.2030702@windriver.com>
References: <4B5E5D4F.50803@windriver.com>
	 <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com>
	 <4B5E9BE9.2030702@windriver.com>
Date: Tue, 26 Jan 2010 15:53:32 +0800
Message-ID: <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com>
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation 
	environments
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Hui Zhu <hui.zhu@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 3:38 PM, Hui Zhu <hui.zhu@windriver.com> wrote:
> Américo Wang:
>>
>> On Tue, Jan 26, 2010 at 11:11 AM, Hui Zhu <hui.zhu@windriver.com> wrote:
>>>
>>> Sorry guys, the prev mail still have some format trouble.  I send a new
>>> mail
>>> for it.
>>> +}
>>> +
>>> +if ($vmlinux_name ne "") {
>>> +       $vmlinux_name = $ARGV[$#ARGV];
>>> +}
>>
>> Why not using the Perl module 'Getopt' to do this?
>>
> Hi Américo,
>
> Thanks for remind me about it.  The following patch use Getopt.
>
> The markup_oops.pl have 3 troubles to support cross-compiler environment:
> 1.  It use objdump directly.
> 2.  It use modinfo to get the message of module.
> 3.  It use hex function that cannot support 64-bit number in 32-bit arch.
>
> This patch add 3 options to markup_oops.pl:
> 1. -c CROSS_COMPILE     Specify the prefix used for toolchain.
> 2. -m MODULE_DIRNAME    Specify the module directory name.
> 3. Change hex function to Math::BigInt->from_hex.
>
> After this patch, parse the x8664 oops in x86, we can:
> cat amd64m | perl ~/kernel/tmp/m.pl -c /home/teawater/kernel/bin/x8664- -m
> ./e.ko vmlinux
>
> Thanks,
> Hui
>
> Signed-off-by: Hui Zhu <teawater@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: ozan@pardus.org.tr
> Cc: Matthew Wilcox <willy@linux.intel.com>
>
> ---
> scripts/markup_oops.pl |   45 +++++++++++++++++++++++++++++++++++----------
> 1 file changed, 35 insertions(+), 10 deletions(-)
>
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -2,6 +2,7 @@
>
> use File::Basename;
> use Math::BigInt;
> +use Getopt::Long;
>
> # Copyright 2008, Intel Corporation
> #
> @@ -15,7 +16,17 @@ use Math::BigInt;
> #       Arjan van de Ven <arjan@linux.intel.com>
>
>
> -my $vmlinux_name = $ARGV[0];
> +my $cross_compile = "";
> +my $vmlinux_name = "";
> +my $modulefile = "";
> +
> +# Get options
> +Getopt::Long::GetOptions(
> +       'cross_compile|c=s'     => \$cross_compile,


Please make it "cross-compile", because underline is not common
in command line, so "--cross_compile" is worse than "--cross-compile".


> +       'modulefile|m=s'        => \$modulefile,


"module" should be enough to express the meaning, I think.


> +       'help|h'                => \&usage,
> +);
> +my $vmlinux_name = $ARGV[$#ARGV];
> if (!defined($vmlinux_name)) {
>        my $kerver = `uname -r`;
>        chomp($kerver);
> @@ -23,6 +34,7 @@ if (!defined($vmlinux_name)) {
>        print "No vmlinux specified, assuming $vmlinux_name\n";
> }
> my $filename = $vmlinux_name;
> +


Adding this empty line probably is not what you really want.

> #
> # Step 1: Parse the oops to find the EIP value
> #

{snip}

>
> +sub usage {
> +       print <<EOT;
> +Usage:
> +  dmesg | perl $0 [OPTION] [VMLINUX]
> +
> +OPTION:
> +  -c, -cross_compile CROSS_COMPILE     Specify the prefix used for
> toolchain.
> +  -m, -modulefile MODULE_DIRNAME       Specify the module directory name.
> +  -h, -help                            Help.
> +EOT
> +       exit;
> +}
> +

GNU style is preferred here, please use "--foo" instead of "-foo".

Thanks.
