Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbZDGHvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbZDGHvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZDGHvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:51:36 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:54690 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZDGHvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E2roDExE3gTqwSG+kiYwSjYYoqvi22/7Oj9SpRXTCV61PGn2t+hg2TrYjKixPyl91+
         qt2zi3Oou7erjCW4mD47caJ3w01uS957CSq8opcJ6ojlZUW98QCZNL0p/HvF8I65AvVw
         ldP07POcxRZGXQyix+Qv2FDCUqOZKVtaz08TQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	 <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
	 <20090406183157.GD7376@mit.edu>
	 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	 <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>
	 <003001c9b6ff$a9259ce0$fb70d6a0$@com>
	 <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
	 <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain>
	 <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
Date: Tue, 7 Apr 2009 09:51:31 +0200
X-Google-Sender-Auth: 669b7bb09157b190
Message-ID: <10f740e80904070051u4ec81842u931a405ab5bde985@mail.gmail.com>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 01:10, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, 6 Apr 2009, Linus Torvalds wrote:
>> thing that we think people would be happiest with.
>>
>> I think "ordered" was a reasonable default, but that was at least partly
>> because _both_ ordered and writeback sucked (partly in different ways).
>>
>> I do think we could make it a config option.
>
> A patch _something_ like this.
>
> A few notes:
>
>  - This is UNTESTED (of course)
>
>  - If I did this right, this _only_ overrides the data mode if it's not
>   explicitly specified on disk in the superblock mount options.
>
> IOW, if you have done a
>
>        tune2fs -o journal_data_ordered
>
> then this will _not_ override that. Only in the absense of any explicit
> flags should this trigger and then make the choice be 'writeback'.
>
> And just to be _extra_ backwards compatible, if you really want the old
> behavior, and don't want to set the ordering flag explicitly, just answer
> 'y' to the EXT3_DEFAULTS_TO_ORDERED Kconfig question.
>
> What do people think? Anybody want to test?
>
>                Linus
>
> ---
>  fs/ext3/Kconfig |   19 +++++++++++++++++++
>  fs/ext3/super.c |    8 +++++++-
>  2 files changed, 26 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
> index 8e0cfe4..fb3c1a2 100644
> --- a/fs/ext3/Kconfig
> +++ b/fs/ext3/Kconfig
> @@ -28,6 +28,25 @@ config EXT3_FS
>          To compile this file system support as a module, choose M here: the
>          module will be called ext3.
>
> +config EXT3_DEFAULTS_TO_ORDERED
> +       bool "Default to 'data=ordered' in ext3 (legacy option)"
> +       depends on EXT3_FS
> +       help
> +         If a filesystem does not explicitly specify a data ordering
> +         mode, and the journal capability allowed it, ext3 used to
> +         historically default to 'data=ordered'.
> +
> +         That was a rather unfortunate choice, because it leads to all
> +         kinds of latency problems, and the 'data=writeback' mode is more
> +         appropriate these days.
> +
> +         You should probably always answer 'n' here, and if you really
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +         want to use 'data=ordered' mode, set it in the filesystem itself
> +         with 'tune2fs -o journal_data_ordered'.
> +
> +         But if you really want to enable the legacy default, you can do
> +         so by answering 'y' to this question.
> +

So `allmodconfig' will enable it? Is that the right thing to do, or
should it be inverted?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
