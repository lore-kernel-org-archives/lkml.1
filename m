Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbZJEIA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbZJEIA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbZJEIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:00:57 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:49332 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619AbZJEIA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U7uWqHUBwrm6cYzAi0Ha4vzXdXHPLU32xxkdfLS9/XmOnLyneKHZZmT6Ozu6SpzTdx
         Qb/AqDThengF2tdyJ4ASDedfAJtgbddK/o32F1ISs4dgDc0DB1Omu0cyBFsHI8lKYPJ+
         jWSfseVIg3ljPGJAU3I6CVyHnTkk4XYxgn01M=
MIME-Version: 1.0
In-Reply-To: <1254618769.1799.280.camel@Joe-Laptop.home>
References: <20091002113038.1dc3d284@hyperion.delvare>
	 <20091002.095402.42770342.davem@davemloft.net>
	 <4AC77003.9090805@computer.org>
	 <1254618769.1799.280.camel@Joe-Laptop.home>
Date: Mon, 5 Oct 2009 15:59:49 +0800
Message-ID: <2375c9f90910050059n636ab68dw651225f14b86ee15@mail.gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add WARN on sizeof(&
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
       Jan Ceuleers <jan.ceuleers@computer.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 9:12 AM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2009-10-03 at 17:38 +0200, Jan Ceuleers wrote:
>> David Miller wrote:
>> > Any time you see "&" in a sizeof() expression, it's almost
>> > certainly a bug.  Something for the folks with automated
>> > tools to look for if they haven't already :-)
>>
>> Your remark prompted me to find four more instances of such bugs
>> (none of which in the networking bits). I have submitted patches.
>
> Perhaps a checkpatch test.

A quick grep shows we have more:

grep -e '\bsizeof[:space:]*([:space:]*\&.*)' -nr ./
./drivers/media/video/em28xx/em28xx-cards.c:2237:
memset(&dev->info, 0, sizeof(&dev->info));
./drivers/media/video/saa7164/saa7164-cmd.c:350:
memset(&response_t, 0, sizeof(&response_t));
./drivers/media/dvb/dvb-usb/ce6230.c:108:       memset(&req, 0, sizeof(&req));
./drivers/video/backlight/lcd.c:59:     memset(&ld->fb_notif, 0,
sizeof(&ld->fb_notif));

>
> ---
>
> sizeof(&foo) is frequently an error.  Warn on its use.
>
> Signed-off-by: Joe Perches <joe@perches.com>


This patch looks fine for me,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 87bbb8b..596dd72 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2534,6 +2534,11 @@ sub process {
>                        WARN("plain inline is preferred over $1\n" . $herecurr);
>                }
>
> +# check for sizeof(&)
> +               if ($line =~ /\bsizeof\s*\(\s*\&/) {
> +                       WARN("sizeof(& should be avoided\n" . $herecurr);
> +               }
> +
>  # check for new externs in .c files.
>                if ($realfile =~ /\.c$/ && defined $stat &&
>                    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
>
>
