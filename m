Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892Ab0AZDF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0AZDF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514Ab0AZDFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:05:55 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:52110 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0AZDFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:05:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uMHfL6N5JQxAaUnIOSEDd4uyzKuki6pVYMJzznEe8sE7SSffZUzZS58KNbGK9UiCYo
         2Ub8lnqHap99UmlinzZTHQkrN7/aPTgFUwi739ElNfey4lnesfD33zi+NxE0NU0ANBEi
         5HfkgTXMiY4YX7xRc8HYFBeiz+EbCanvtvakA=
MIME-Version: 1.0
In-Reply-To: <4B5E5D4F.50803@windriver.com>
References: <4B5E5D4F.50803@windriver.com>
Date: Tue, 26 Jan 2010 11:05:54 +0800
Message-ID: <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com>
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

On Tue, Jan 26, 2010 at 11:11 AM, Hui Zhu <hui.zhu@windriver.com> wrote:
> Sorry guys, the prev mail still have some format trouble.  I send a new mail
> for it.
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
> scripts/markup_oops.pl |   71
> ++++++++++++++++++++++++++++++++++++++++++-------
> 1 file changed, 61 insertions(+), 10 deletions(-)
>
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -15,8 +15,46 @@ use Math::BigInt;
> #       Arjan van de Ven <arjan@linux.intel.com>
>
>
> -my $vmlinux_name = $ARGV[0];
> -if (!defined($vmlinux_name)) {
> +my $cross_compile = "";
> +my $vmlinux_name = "";
> +my $modulefile = "";
> +
> +# Get options
> +my $option = 0;
> +for (my $i = 0; $i <= $#ARGV; $i++) {
> +       if ($option == 0) {
> +               if ($ARGV[$i] eq "-c") {
> +                       $option = 1;
> +               }
> +               elsif ($ARGV[$i] eq "-m") {
> +                       $option = 2;
> +               }
> +               elsif ($ARGV[$i] eq "-h") {
> +                       usage();
> +                       exit;
> +               }
> +               elsif ($i == $#ARGV) {
> +                       $vmlinux_name = $ARGV[$i];
> +               }
> +               else {
> +                       usage();
> +                       exit;
> +               }
> +       }
> +       elsif ($option == 1) {
> +               $cross_compile = $ARGV[$i];
> +               $option = 0;
> +       }
> +       elsif ($option == 2) {
> +               $modulefile = $ARGV[$i];
> +               $option = 0;
> +       }
> +}
> +
> +if ($vmlinux_name ne "") {
> +       $vmlinux_name = $ARGV[$#ARGV];
> +}

Why not using the Perl module 'Getopt' to do this?
